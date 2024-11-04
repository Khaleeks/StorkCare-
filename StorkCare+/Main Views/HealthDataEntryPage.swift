
// BabyDevelopment.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 10/23/24.

import SwiftUI

struct HealthDataEntryPage: View {
    @State private var name: String = ""
    @State private var selectedSex: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var selectedHeight: Int = 160 // Default value for height
    @State private var selectedWeight: Int = 70 // Default value for weight

    @State private var showSexPicker = false
    @State private var showHeightPicker = false
    @State private var showWeightPicker = false
    @State private var showDatePicker = false

    var body: some View {
        VStack(spacing: 15) {
            Spacer() // Slightly pushes the title down
                .frame(height: 20) // Adjust this value for finer control

            Text("Personalized Health Data")
                .font(.largeTitle)
                .bold() // Make the title bold
                .foregroundColor(.pink) // Set the text color
                .frame(maxWidth: .infinity, alignment: .center) // Center the title
                .lineLimit(1) // Ensure it stays on one line
                .minimumScaleFactor(0.5) // Allow the font to scale down if needed

            Text("This information ensures that your health data is as accurate as possible. This information is only shared with your healthcare provider.")
                .font(.body) // Regular font
                .multilineTextAlignment(.center) // Center align the text
                .padding(.bottom) // Add some padding below
                .frame(maxWidth: .infinity, alignment: .center) // Center the description


            Form {
                Section(header: Text("Personal Info")) {
                    HStack {
                        Text("Name")
                            .bold()
                        Spacer()
                        TextField("Enter your name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Sex")
                            .bold()
                        Spacer()
                        Text(selectedSex.isEmpty ? "Select" : selectedSex)
                            .foregroundColor(.black)
                            .onTapGesture {
                                showSexPicker.toggle()
                            }
                    }

                    HStack {
                        Text("Date of Birth")
                            .bold()
                        Spacer()
                        Text(dateFormatted(date: dateOfBirth)) // Display formatted date
                            .foregroundColor(.black)
                            .onTapGesture {
                                showDatePicker.toggle() // Show date picker on tap
                            }
                    }
                }

                Section(header: Text("Physical Info")) {
                    // Height picker
                    HStack {
                        Text("Height (cm)")
                            .bold()
                        Spacer()
                        Text("\(selectedHeight) cm")
                            .foregroundColor(.black)
                            .onTapGesture {
                                showHeightPicker.toggle()
                            }
                    }

                    // Weight picker
                    HStack {
                        Text("Weight (kg)")
                            .bold()
                        Spacer()
                        Text("\(selectedWeight) kg")
                            .foregroundColor(.black)
                            .onTapGesture {
                                showWeightPicker.toggle()
                            }
                    }
                }
            }
            .padding()

            NavigationLink(destination: ContentView()) {
                Text("Continue")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
        
        // Sex Picker Bottom Sheet
        .sheet(isPresented: $showSexPicker) {
            VStack {
                Picker("Sex", selection: $selectedSex) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Nonbinary").tag("Nonbinary")
                }
                .pickerStyle(.wheel)

                Button(action: {
                    showSexPicker = false
                }) {
                    Text("Done")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        
        // Height Picker Bottom Sheet
        .sheet(isPresented: $showHeightPicker) {
            VStack {
                Picker("Height", selection: $selectedHeight) {
                    ForEach(30...275, id: \.self) { height in
                        Text("\(height) cm").tag(height)
                    }
                }
                .pickerStyle(.wheel)

                Button(action: {
                    showHeightPicker = false
                }) {
                    Text("Done")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        
        // Weight Picker Bottom Sheet
        .sheet(isPresented: $showWeightPicker) {
            VStack {
                Picker("Weight", selection: $selectedWeight) {
                    ForEach(0...454, id: \.self) { weight in
                        Text("\(weight) kg").tag(weight)
                    }
                }
                .pickerStyle(.wheel)

                Button(action: {
                    showWeightPicker = false
                }) {
                    Text("Done")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
        }

        // Date Picker Bottom Sheet
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("Select your date of birth", selection: $dateOfBirth, displayedComponents: .date)
                    .datePickerStyle(.graphical) // Change this to .graphical for a better layout
                    .frame(maxWidth: .infinity) // Ensure it uses full width
                    .padding()

                Button(action: {
                    showDatePicker = false
                }) {
                    Text("Done")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.white) // Optional: add background color for better visibility
            .edgesIgnoringSafeArea(.all) // Ensures it covers the whole screen
        }
    }

    // Helper function to format date for display
    private func dateFormatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Change this as needed
        return formatter.string(from: date)
    }
}

#Preview {
    HealthDataEntryPage()
}
