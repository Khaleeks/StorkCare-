import SwiftUI
import FirebaseAuth

struct PregnantWomanPage: View {
    let uid: String
    @Binding var isAuthenticated: Bool
    @StateObject private var viewModel = PregnantWomanViewModel()
    @State private var showSexPicker = false
    @State private var showHeightPicker = false
    @State private var showWeightPicker = false
    @State private var showDatePicker = false
    @State private var showPregnancyDatePicker = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Personalized Health Data")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.pink)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text("This information ensures that your health data is as accurate as possible. This information is only shared with your healthcare provider.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            Form {
                Section(header: Text("Personal Info")) {
                    HStack {
                        Text("Name")
                            .bold()
                        Spacer()
                        TextField("Enter your name", text: $viewModel.name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Sex")
                            .bold()
                        Spacer()
                        Text(viewModel.selectedSex.isEmpty ? "Select" : viewModel.selectedSex)
                            .foregroundColor(.black)
                            .onTapGesture {
                                showSexPicker = true
                            }
                    }
                    
                    HStack {
                        Text("Date of Birth")
                            .bold()
                        Spacer()
                        Text(viewModel.dateFormatted(date: viewModel.dateOfBirth))
                            .onTapGesture {
                                showDatePicker = true
                            }
                    }
                }
                
                Section(header: Text("Pregnancy Info")) {
                    HStack {
                        Text("Pregnancy Start Date")
                            .bold()
                        Spacer()
                        Text(viewModel.dateFormatted(date: viewModel.pregnancyStartDate))
                            .onTapGesture {
                                showPregnancyDatePicker = true
                            }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Medical History")
                            .bold()
                        TextEditor(text: $viewModel.medicalHistory)
                            .frame(height: 100)
                    }
                }
                
                Section(header: Text("Physical Info")) {
                    HStack {
                        Text("Height (cm)")
                            .bold()
                        Spacer()
                        Text("\(viewModel.selectedHeight) cm")
                            .onTapGesture {
                                showHeightPicker = true
                            }
                    }
                    
                    HStack {
                        Text("Weight (kg)")
                            .bold()
                        Spacer()
                        Text("\(viewModel.selectedWeight) kg")
                            .onTapGesture {
                                showWeightPicker = true
                            }
                    }
                }
            }
            
            Button(action: {
                viewModel.savePregnantWomanData(uid: uid)
            }) {
                Text("Complete Profile")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(viewModel.isProfileCreated ? .green : .red)
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.isProfileCreated) {
            PregnantWomanContentView(isAuthenticated: $isAuthenticated)
                .navigationBarBackButtonHidden(true)
        }
        .sheet(isPresented: $showSexPicker) {
            pickerView(title: "Select Sex", selection: $viewModel.selectedSex, options: ["Male", "Female", "Other"])
        }
        .sheet(isPresented: $showHeightPicker) {
            heightPickerView
        }
        .sheet(isPresented: $showWeightPicker) {
            weightPickerView
        }
        .sheet(isPresented: $showDatePicker) {
            datePickerView(title: "Date of Birth", selection: $viewModel.dateOfBirth)
        }
        .sheet(isPresented: $showPregnancyDatePicker) {
            datePickerView(title: "Pregnancy Start Date", selection: $viewModel.pregnancyStartDate)
        }
        .onAppear {
            viewModel.loadUserProfile(uid: uid)
        }
    }
    
    // Helper Views
    private func pickerView(title: String, selection: Binding<String>, options: [String]) -> some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.wheel)
            
            Button("Done") {
                if title == "Select Sex" {
                    showSexPicker = false
                }
            }
            .padding()
        }
    }
    
    private var heightPickerView: some View {
        VStack {
            Picker("Height", selection: $viewModel.selectedHeight) {
                ForEach(120...220, id: \.self) { height in
                    Text("\(height) cm").tag(height)
                }
            }
            .pickerStyle(.wheel)
            
            Button("Done") {
                showHeightPicker = false
            }
            .padding()
        }
    }
    
    private var weightPickerView: some View {
        VStack {
            Picker("Weight", selection: $viewModel.selectedWeight) {
                ForEach(30...200, id: \.self) { weight in
                    Text("\(weight) kg").tag(weight)
                }
            }
            .pickerStyle(.wheel)
            
            Button("Done") {
                showWeightPicker = false
            }
            .padding()
        }
    }
    
    private func datePickerView(title: String, selection: Binding<Date>) -> some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            
            DatePicker(title, selection: selection, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
            
            Button("Done") {
                if title == "Date of Birth" {
                    showDatePicker = false
                } else {
                    showPregnancyDatePicker = false
                }
            }
            .padding()
        }
    }
    private func signOut() {
            do {
                try Auth.auth().signOut()
                isAuthenticated = false
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
}
