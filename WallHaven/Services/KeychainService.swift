import Foundation
import KeychainAccess


struct KeychainService {
    let keychain = Keychain(service: Constants.KeyChain.Service)
    
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
    
    func saveAPIKey(_ apiKey: String) {
        guard !apiKey.isEmpty else { return }
        performKeychainOperation {
            try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                .authenticationPrompt("Authenticate to save your API Key")
                .set(apiKey, key: Constants.KeyChain.Key)
            
            _ = loadAPIKey()
        }
    }
    
    func clearAPIKey() {
        performKeychainOperation {
            try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                .authenticationPrompt("Authenticate to delete your API Key")
                .remove(Constants.KeyChain.Key)
        }
    }
    
    func loadAPIKey() -> String {
        var key = ""
        performKeychainOperation {
            let storedApiKey = try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                .authenticationPrompt("Authenticate to retrieve your API Key")
                .get(Constants.KeyChain.Key)
            key = storedApiKey ?? ""

        }
        return key
    }
    
}



