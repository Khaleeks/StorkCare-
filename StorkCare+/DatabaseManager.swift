//
//  DatabaseManager.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 10/31/24.
//


import SQLite3
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager() // Singleton instance

    private var db: OpaquePointer? = nil

    private init() {
        openDatabase()
        createTables()
    }

    // Open Database
    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("StorkCareDatabase.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database.")
        }
    }

    // Close Database
    deinit {
        sqlite3_close(db)
    }
}


extension DatabaseManager {
    func createTables() {
        createUserTable()
        createBabyDevelopmentTable()
        createMedicationReminderTable()
    }

    private func createUserTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS User (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT,
                password TEXT,
                email TEXT
            );
        """
        executeQuery(query: createTableQuery)
    }

    private func createBabyDevelopmentTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS BabyDevelopment (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                userId INTEGER,
                date TEXT,
                milestone TEXT,
                FOREIGN KEY (userId) REFERENCES User(id)
            );
        """
        executeQuery(query: createTableQuery)
    }

    private func createMedicationReminderTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS MedicationReminder (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                userId INTEGER,
                medicationName TEXT,
                frequency TEXT,
                time TEXT,
                startDate TEXT,
                endDate TEXT,
                FOREIGN KEY (userId) REFERENCES User(id)
            );
        """
        executeQuery(query: createTableQuery)
    }
    
    private func executeQuery(query: String) {
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table created or already exists.")
            } else {
                print("Table creation failed.")
            }
        } else {
            print("Preparation failed.")
        }
        sqlite3_finalize(statement)
    }
}

extension DatabaseManager {
    func insertUser(username: String, password: String, email: String) {
        let insertQuery = "INSERT INTO User (username, password, email) VALUES (?, ?, ?);"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (email as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("User added successfully.")
            } else {
                print("Failed to add user.")
            }
        }
        sqlite3_finalize(statement)
    }

    func fetchUsers() -> [(Int, String, String, String)] {
        let selectQuery = "SELECT * FROM User;"
        var statement: OpaquePointer?
        var users: [(Int, String, String, String)] = []

        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let username = String(cString: sqlite3_column_text(statement, 1))
                let password = String(cString: sqlite3_column_text(statement, 2))
                let email = String(cString: sqlite3_column_text(statement, 3))
                users.append((id, username, password, email))
            }
        }
        sqlite3_finalize(statement)
        return users
    }
}

extension DatabaseManager {
    func addBabyMilestone(userId: Int, date: String, milestone: String) {
        let insertQuery = "INSERT INTO BabyDevelopment (userId, date, milestone) VALUES (?, ?, ?);"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))
            sqlite3_bind_text(statement, 2, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (milestone as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Milestone added.")
            } else {
                print("Failed to add milestone.")
            }
        }
        sqlite3_finalize(statement)
    }

    func fetchBabyMilestones(userId: Int) -> [(Int, String, String)] {
        let selectQuery = "SELECT * FROM BabyDevelopment WHERE userId = ?;"
        var statement: OpaquePointer?
        var milestones: [(Int, String, String)] = []

        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let date = String(cString: sqlite3_column_text(statement, 2))
                let milestone = String(cString: sqlite3_column_text(statement, 3))
                milestones.append((id, date, milestone))
            }
        }
        sqlite3_finalize(statement)
        return milestones
    }
}

extension DatabaseManager {
    func addMedicationReminder(userId: Int, name: String, frequency: String, time: String, startDate: String, endDate: String) {
        let insertQuery = "INSERT INTO MedicationReminder (userId, medicationName, frequency, time, startDate, endDate) VALUES (?, ?, ?, ?, ?, ?);"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))
            sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (frequency as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (time as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (startDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (endDate as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Medication reminder added.")
            } else {
                print("Failed to add reminder.")
            }
        }
        sqlite3_finalize(statement)
    }

    func fetchMedicationReminders(userId: Int) -> [(Int, String, String, String, String, String)] {
        let selectQuery = "SELECT * FROM MedicationReminder WHERE userId = ?;"
        var statement: OpaquePointer?
        var reminders: [(Int, String, String, String, String, String)] = []

        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 2))
                let frequency = String(cString: sqlite3_column_text(statement, 3))
                let time = String(cString: sqlite3_column_text(statement, 4))
                let startDate = String(cString: sqlite3_column_text(statement, 5))
                let endDate = String(cString: sqlite3_column_text(statement, 6))
                reminders.append((id, name, frequency, time, startDate, endDate))
            }
        }
        sqlite3_finalize(statement)
        return reminders
    }
}
