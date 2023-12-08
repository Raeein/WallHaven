import SwiftUI
import KeychainAccess

struct APIKeyView: View {
    
    func saveAPIKey(password: String) -> Bool {
        guard let data = password.data(using: .utf8) else { return false }
        return true
    }
    
    func loadAPIKey() -> String {
        return "123"
    }
    
    func saveButtonPressed() {
        print("Current password cant be empty")
        
        if isEditingAPIKeyFocused {
            if saveAPIKey(password: currentPassword) {
                print("Save to keychain")
                currentPassword = password
            } else {
                print("Failed to save to key chain")
            }
        } else {
            isEditingAPIKeyFocused.toggle()
        }
    }
    
    @State private var password: String = ""
    @State private var currentPassword: String = ""
    @FocusState private var isEditingAPIKeyFocused: Bool
    
    let keychain = Keychain(service: Constants.KeyChain.Service)
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("API Key") {
                    HStack {
                        if !password.isEmpty {
                            Text("Your Key")
                            Spacer()
                            SecureField("Field", text: $password)
                                .multilineTextAlignment(.trailing)
                                .textContentType(.password)
                                .disabled(true)
                        } else {
                            Text("Enter your Key")
                            Spacer()
                            TextField("Placeholder", text: $currentPassword, axis: .horizontal)
                                .focused($isEditingAPIKeyFocused)
                                .multilineTextAlignment(.trailing)
                                .textContentType(.password)
                                .autocorrectionDisabled()
                                .truncationMode(.tail)
                        }
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("save", action: saveButtonPressed)
                        .foregroundStyle(isEditingAPIKeyFocused && currentPassword != "" ? .blue : .gray)
                        .disabled(isEditingAPIKeyFocused && currentPassword != "" ? false : true)
                    
                })
                
            })
            .navigationTitle("API Config")
        }
        .onAppear(perform: {
            password = loadAPIKey()
//            keychain.get(<#T##key: String##String#>)
        })
    }
}

#Preview {
    APIKeyView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
}
