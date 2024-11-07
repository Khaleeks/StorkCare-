//
//  PregnantWomanPage.swift
//  StorkCare+
//
//  Created by Bamlak T on 11/7/24.
//

import SwiftUI

struct PregnantWomanPage: View {
    let uid: String
    
    @State private var name: String = ""
    @State private var selectedSex: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var pregnancyStartDate: Date = Date() // New field for pregnancy start date
    @State private var selectedHeight: Int = 160 // Default value for height
    @State private var selectedWeight: Int = 70 // Default value for weight
    @State private var medicalHistory: String = "" // New field for past medical history

    @State private var showSexPicker = false
    @State private var showHeightPicker = false
    @State private var showWeightPicker = false
    @State private var showDatePicker = false
    @State private var showPregnancyDatePicker = false // Show picker for pregnancy start date

    var body: some View {
        VStack(spacing: 15) {
            Spacer()
                .frame(height: 20)

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
                .frame(maxWidth: .infinity, alignment: .center)

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
                        Text(dateFormatted(date: dateOfBirth))
                            .foregroundColor(.black)
                            .onTapGesture {
                                showDatePicker.toggle()
                            }
                    }
                }

                Section(header: Text("Pregnancy Info")) {
                    HStack {
                        Text("Pregnancy Start Date")
                            .bold()
                        Spacer()
                        Text(dateFormatted(date: pregnancyStartDate))
                            .foregroundColor(.black)
                            .onTapGesture {
                                showPregnancyDatePicker.toggle()
                            }
                    }

                    VStack(alignment: .leading) {
                        Text("Past Medical History")
                            .bold()
                        TextField("Enter any relevant medical history", text: $medicalHistory)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                Section(header: Text("Physical Info")) {
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

        // Date Picker Bottom Sheet for Date of Birth
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("Select your date of birth", selection: $dateOfBirth, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .frame(maxWidth: .infinity)
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
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }

        // Date Picker Bottom Sheet for Pregnancy Start Date
        .sheet(isPresented: $showPregnancyDatePicker) {
            VStack {
                DatePicker("Select pregnancy start date", selection: $pregnancyStartDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .frame(maxWidth: .infinity)
                    .padding()

                Button(action: {
                    showPregnancyDatePicker = false
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
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }

    // Helper function to format date for display
    private func dateFormatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    PregnantWomanPage(uid: "sampleUID")
}

