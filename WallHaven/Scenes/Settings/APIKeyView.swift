import SwiftUI
import Lottie
import KeychainAccess

struct APIKeyView: View {

    @FocusState private var isEditingAPIKey: Bool
    @State private var apiKey: String = ""
    @State private var showingChangePasswordAlert = false
    @State private var showVerifyingOverlay = false
    @State private var showAPIKeyInputAlert = false

    @State private var apiKeyFieldAlert: String = ""
    @State private var isPresentWebView = false

    @State private var showInvalidAPIKeyAlert = false

    let apiService = APIService()
    let keychainService = KeychainService()

    var body: some View {
        NavigationStack {
            if apiKey.isEmpty {
                contentUnavailableField
                    .alert("Add Key", isPresented: $showAPIKeyInputAlert) {
                        TextField("Enter your key", text: $apiKeyFieldAlert)
                        Button("Verify", action: {
                            Task {
                                let result = await apiService.verifyAPIKey(withKey: apiKeyFieldAlert)
                                switch result {
                                case .success:
                                    keychainService.saveAPIKey(apiKeyFieldAlert)
                                    apiKey = apiKeyFieldAlert
                                    apiKeyFieldAlert = ""
                                case .failure(let error):
                                    showInvalidAPIKeyAlert = true
                                    apiKeyFieldAlert = ""
                                    print(error.localizedDescription)
                                }
                            }
                        })
                    } message: {
                        Text("Please enter your API Key")
                    }
                    .alert("Invalid API Key. Please try again.", isPresented: $showInvalidAPIKeyAlert) {
                        Button("Dismiss", role: .cancel) {
                            showInvalidAPIKeyAlert.toggle()
                        }
                    }
            } else {
                Form {
                    Section {
                        apiKeyDisplayField
                    } footer: {
                        Text("To delete the key, tap on it")
                    }
                }
                .navigationTitle("API Config")
                .alert(isPresented: $showingChangePasswordAlert) {
                    changePasswordAlert
                }
                .onAppear(perform: {
                    if apiKey.isEmpty {
                        apiKey = keychainService.loadAPIKey()
                    }
                })
                .overlay(alignment: .center) {
                    if showVerifyingOverlay {
                        VStack(spacing: 20) {
                            Button("Dismiss", systemImage: "x.circle") {
                                print("Dismiss")
                            }
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.red)
                            ProgressView()
                            Text("Verifying API key...")

                            LottieView(animation: .named(Constants.Lottie.checkMarkSuccess))
                                .playing(loopMode: .loop)

                        }
                        .padding(50)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 20.0))
                    }
                }
            }
        }
        .onAppear(perform: {
            if apiKey.isEmpty {
                apiKey = keychainService.loadAPIKey()
            }
        })
    }
    var contentUnavailableField: some View {
        VStack {
            LottieView(animation: .named(Constants.Lottie.key))
                .playing(loopMode: .loop)

            Spacer()

            Text("Add your WallHaven API Key")
            HStack {

                Button(action: {
                    withAnimation {
                        isPresentWebView.toggle()
                    }
                }) {
                    Text("Find Mine")
                        .padding(.horizontal)
                        .bold()
                        .font(.headline)

                }
                .buttonStyle(.bordered)

                Button(action: {
                    withAnimation {
                        showAPIKeyInputAlert.toggle()
                    }
                }) {
                    Text("Add")
                        .padding(.horizontal)
                        .bold()
                        .font(.headline)

                }
                .buttonStyle(.borderedProminent)

                .sheet(isPresented: $isPresentWebView) {
                    NavigationStack {
                        WebView(url: URL(string: "https://wallhaven.cc/settings/account")!)

                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button(action: {
                                        isPresentWebView = false
                                    }) {
                                        Image(systemName: "x.circle.fill")
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                    }
                }
            }
        }
    }

    var apiKeyDisplayField: some View {
        HStack {
            Text("Your Key")
            Spacer()
            SecureField("Field", text: $apiKey)
                .multilineTextAlignment(.trailing)
                .textContentType(.password)
                .overlay(
                    Rectangle()
                        .foregroundColor(Color.red.opacity(0.001)) //
                        .onTapGesture {
                            showingChangePasswordAlert = true
                        }
                )
        }
    }

//    var saveToolbarItem: some ToolbarContent {
//        ToolbarItem(placement: .navigationBarTrailing) {
//            Button("save") {
//                Task {
//                    let _ = await  apiService.verifyAPIKey(withKey: apiKey)
//                }
//            }
//        }
//    }

    var changePasswordAlert: Alert {
        Alert(
            title: Text("Change API Key"),
            message: Text("Would you like to change your API Key?"),
            primaryButton: .default(Text("Yes")) {
                keychainService.clearAPIKey()
                apiKey = ""
            },
            secondaryButton: .cancel()
        )
    }
}

#Preview {
    APIKeyView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
}
