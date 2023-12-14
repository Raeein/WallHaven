import SwiftUI
import KeychainAccess

struct APIKeyView: View {
    
    @FocusState private var isEditingAPIKey: Bool
    @State private var apiKey: String = ""
    @State private var showingChangePasswordAlert = false
    @State private var showVerifyingOverlay = false
    @State private var showAPIKeyInputAlert = false
    
    @State private var apiKeyFieldAlert: String = ""
    @State private var isPresentWebView = false
    
    
    let apiService = APIService()
    let keychainService = KeychainService()
    
    var body: some View {
        NavigationStack {
            if apiKey.isEmpty {
                contentUnavailableField
                    .alert("Add Key", isPresented: $showAPIKeyInputAlert) {
                        TextField("Enter your name", text: $apiKeyFieldAlert)
                        Button("Add", action: {
                            if apiService.verifyAPIKey() {
                                apiKey = "YAY"
                            }
                        })
                    } message: {
                        Text("Please enter your API Key")
                    }
            } else {
                Form {
                    Section("API Key") {
                        apiKeyDisplayField
                    }
                }
                .navigationTitle("API Config")
                .toolbar {
                    saveToolbarItem
                }
                .alert(isPresented: $showingChangePasswordAlert) {
                    changePasswordAlert
                }
                .onAppear(perform: {
                    apiKey = keychainService.loadAPIKey()
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
                            LottieView(animationName: Constants.Lottie.checkMarkSuccess, loopMode: .loop)
                                .frame(width: 20, height: 20)
                        }
                        .padding(50)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 20.0))
                    }
                }
            }
        }
    }
    var contentUnavailableField: some View {
        VStack {
            LottieView(animationName: "key")
            

            Text("Add your WallHaven API Key")
            HStack {
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
                .sheet(isPresented: $isPresentWebView) {
                    NavigationStack {
                        WebView(url: URL(string: "https://wallhaven.cc/settings/account")!)

                            .ignoresSafeArea()
                            .navigationTitle("Sarunw")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
        }
    }
    
//    var contentUnavailableField: some View {
//        ContentUnavailableView(label: {
//            Label("No API Key", systemImage: "key.slash.fill")
//        }, description: {
//            Text("Add your WallHaven API Key")
//                .textContentType(.password)
//                .autocorrectionDisabled()
//        }, actions: {
//            Button(action: {
//                withAnimation {
//                    showAPIKeyInputAlert.toggle()
//                }
//            }) {
//                Text("Add")
//                    .padding(.horizontal)
//                    .bold()
//                    .font(.headline)
//                
//            }
//            .buttonStyle(.borderedProminent)
//        })
//    }
    
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
    
    var saveToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("save") {
#warning("FIX THIS")
                keychainService.saveAPIKey(apiKey)
            }
            //            .foregroundStyle(isEditingAPIKey && !apiKeyField.isEmpty ? .blue : .gray)
            //            .disabled(isEditingAPIKey && !apiKeyField.isEmpty ? false : true)
            
        }
    }
    
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
