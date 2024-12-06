import SwiftUI

struct HealthcarePage: View {
    let uid: String
    @Binding var isAuthenticated: Bool  // Add this line
    @StateObject private var viewModel = HealthcarePageViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Healthcare Provider Onboarding")
                .font(.largeTitle)
                .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Gender", text: $viewModel.gender)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Occupation", text: $viewModel.occupation)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Place of Work", text: $viewModel.placeOfWork)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Button(action: {
                    viewModel.saveHealthcareProviderData(uid: uid)
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Complete Onboarding")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(viewModel.isLoading)
            }
            
            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(viewModel.isOnboardingComplete ? .green : .red)
                    .padding()
            }
        }
        .padding()
        .navigationDestination(isPresented: $viewModel.isOnboardingComplete) {
                HealthcareContentView(isAuthenticated: $isAuthenticated)
            }
        .onAppear {
            viewModel.loadHealthcareProviderData(uid: uid)
        }
    }
}
