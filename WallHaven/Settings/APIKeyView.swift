import SwiftUI
import KeychainAccess

struct APIKeyView: View {
    @FocusState private var isEditingAPIKey: Bool
    @State private var apiKey: String = ""
    @State private var apiKeyField: String = ""
    @State private var showingChangePasswordAlert = false
    
    let keychain = Keychain(service: Constants.KeyChain.Service)
    
    var body: some View {
        NavigationStack {
            Form {
                Section("API Key") {
                    if apiKey.isEmpty {
                        apiKeyEntryField
                    } else {
                        apiKeyDisplayField
                        
                    }
                }
            }
            .navigationTitle("API Config")
            .toolbar {
                saveToolbarItem
            }
            .alert(isPresented: $showingChangePasswordAlert) {
                changePasswordAlert
            }
            .onAppear(perform: loadAPIKey)
        }
    }
    
    var apiKeyEntryField: some View {
        HStack {
            Text("Enter your Key")
            Spacer()
            TextField("Placeholder", text: $apiKeyField)
                .focused($isEditingAPIKey)
                .multilineTextAlignment(.trailing)
                .textContentType(.password)
                .autocorrectionDisabled()
                .truncationMode(.head)
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
    
    var saveToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("save") {
                saveAPIKey()
            }
            .foregroundStyle(isEditingAPIKey && !apiKeyField.isEmpty ? .blue : .gray)
            .disabled(isEditingAPIKey && !apiKeyField.isEmpty ? false : true)
            
        }
    }
    
    var changePasswordAlert: Alert {
        Alert(
            title: Text("Change API Key"),
            message: Text("Would you like to change your API Key?"),
            primaryButton: .default(Text("Yes")) {
                clearAPIKey()
                apiKey = ""
            },
            secondaryButton: .cancel()
        )
    }
    
    private func saveAPIKey() {
        guard !apiKeyField.isEmpty else { return }
        performKeychainOperation {
            try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                .authenticationPrompt("Authenticate to save your API Key")
                .set(apiKeyField, key: Constants.KeyChain.Key)
            
            loadAPIKey()
        }
    }
    
    private func clearAPIKey() {
        performKeychainOperation {
            try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                .authenticationPrompt("Authenticate to delete your API Key")
                .remove(Constants.KeyChain.Key)
        }
    }
    
    private func loadAPIKey() {
        performKeychainOperation {
            let storedApiKey = try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                .authenticationPrompt("Authenticate to retrieve your API Key")
                .get(Constants.KeyChain.Key)
            DispatchQueue.main.async {
                apiKey = storedApiKey ?? ""
            }
        }
    }
    
    private func performKeychainOperation(operation: @escaping () throws -> Void) {
        DispatchQueue.global().async {
            do {
                try operation()
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    APIKeyView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
}
