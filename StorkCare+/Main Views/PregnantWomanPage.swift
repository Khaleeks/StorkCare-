//
//  PregnantWomanPage.swift
//  StorkCare+
//
//  Created by Bamlak T on 11/7/24.
//

import SwiftUI
struct PregnantWomanPage: View {
    @ObservedObject var viewModel: PregnantWomanViewModel
    let uid: String

    var body: some View {
        VStack(spacing: 15) {
            Spacer().frame(height: 20)

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
                        Text("Name").bold()
                        Spacer()
                        TextField("Enter your name", text: $viewModel.name)
                            .multilineTextAlignment(.trailing)
                            .tag(1) // Add tag to the name TextField for testing
                    }

                    HStack {
                        Text("Sex").bold()
                        Spacer()
                        Text(viewModel.selectedSex.isEmpty ? "Select" : viewModel.selectedSex)
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.showSexPicker.toggle()
                            }
                    }

                    HStack {
                        Text("Date of Birth").bold()
                        Spacer()
                        Text(viewModel.dateFormatted(date: viewModel.dateOfBirth))
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.showDatePicker.toggle()
                            }
                    }
                }

                Section(header: Text("Pregnancy Info")) {
                    HStack {
                        Text("Pregnancy Start Date").bold()
                        Spacer()
                        Text(viewModel.dateFormatted(date: viewModel.pregnancyStartDate))
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.showPregnancyDatePicker.toggle()
                            }
                    }

                    VStack(alignment: .leading) {
                        Text("Past Medical History").bold()
                        TextField("Enter any relevant medical history", text: $viewModel.medicalHistory)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                Section(header: Text("Physical Info")) {
                    HStack {
                        Text("Height (cm)").bold()
                        Spacer()
                        Text("\(viewModel.selectedHeight) cm")
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.showHeightPicker.toggle()
                            }
                            .tag(2) // Tag for height picker toggle button
                    }

                    HStack {
                        Text("Weight (kg)").bold()
                        Spacer()
                        Text("\(viewModel.selectedWeight) kg")
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.showWeightPicker.toggle()
                            }
                    }
                }
            }
            .padding()

            Button("Continue") {
                viewModel.savePregnantWomanData(uid: uid)
            }
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

        }
        .navigationDestination(isPresented: $viewModel.isProfileCreated) {
            ContentView() // Navigate to main features page
        }
        .padding()

        // Sex Picker Bottom Sheet
        .sheet(isPresented: $viewModel.showSexPicker) {
            VStack {
                Picker("Sex", selection: $viewModel.selectedSex) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Nonbinary").tag("Nonbinary")
                }
                .pickerStyle(.wheel)

                Button(action: {
                    viewModel.showSexPicker = false
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
        .sheet(isPresented: $viewModel.showHeightPicker) {
            VStack {
                Picker("Height", selection: $viewModel.selectedHeight) {
                    ForEach(30...275, id: \.self) { height in
                        Text("\(height) cm").tag(height)
                    }
                }
                .pickerStyle(.wheel)
                .tag(3) // Tag for height picker sheet

                Button(action: {
                    viewModel.showHeightPicker = false
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
        .sheet(isPresented: $viewModel.showWeightPicker) {
            VStack {
                Picker("Weight", selection: $viewModel.selectedWeight) {
                    ForEach(0...454, id: \.self) { weight in
                        Text("\(weight) kg").tag(weight)
                    }
                }
                .pickerStyle(.wheel)

                Button(action: {
                    viewModel.showWeightPicker = false
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
        .sheet(isPresented: $viewModel.showDatePicker) {
            VStack {
                DatePicker("Select your date of birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .frame(maxWidth: .infinity)
                    .padding()

                Button(action: {
                    viewModel.showDatePicker = false
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
        .sheet(isPresented: $viewModel.showPregnancyDatePicker) {
            VStack {
                DatePicker("Select pregnancy start date", selection: $viewModel.pregnancyStartDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .frame(maxWidth: .infinity)
                    .padding()

                Button(action: {
                    viewModel.showPregnancyDatePicker = false
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
}

struct PregnantWomanPage_Previews: PreviewProvider {
    static var previews: some View {
        PregnantWomanPage(viewModel: PregnantWomanViewModel(), uid: "sampleUID")
    }
}
