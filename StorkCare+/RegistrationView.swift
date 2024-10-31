import SwiftUI
import SQLite3

struct RegistrationView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistered = false
    @State private var message: String? = nil // For success/error messages
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Register for StorkCare+")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Register") {
                    let success = saveUser(name: name, email: email, password: password)
                    if success {
                        isRegistered = true
                        message = "Registration successful!"
                    } else {
                        message = "Registration failed. Try again."
                    }
                }
                .padding()
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if let message = message {
                    Text(message)
                        .foregroundColor(isRegistered ? .green : .red)
                        .padding()
                }
            }
            .padding()
            .navigationDestination(isPresented: $isRegistered) {
                IntroductionPage()
            }
        }
    }

    // Save user details to the SQLite database
    func saveUser(name: String, email: String, password: String) -> Bool {
        guard let db = openDatabase() else { return false }
        
        let insertStatementString = "INSERT INTO Users (Name, Email, Password) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                sqlite3_finalize(insertStatement)
                sqlite3_close(db)
                return true
            }
        }
        sqlite3_finalize(insertStatement)
        sqlite3_close(db)
        return false
    }

    // Open the database
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("StorkCare.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database.")
            return nil
        }
        
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Users(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT,
        Email TEXT,
        Password TEXT);
        """
        if sqlite3_exec(db, createTableString, nil, nil, nil) != SQLITE_OK {
            print("Error creating table.")
            return nil
        }
        
        return db
    }
}
