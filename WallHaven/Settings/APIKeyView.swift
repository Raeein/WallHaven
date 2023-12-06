//
//  APIKeyView.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-12-05.
//

import SwiftUI

struct APIKeyView: View {
    
    func saveAPIKey(password: String) -> Bool {
        
        guard let data = password.data(using: .utf8) else { return false }
        
        return KeychainHelper.storeData(data: data, forService: KeychainHelper.service, account: KeychainHelper.account)
    }

    @State private var password: String = ""
    @State private var currentPassword: String = ""
    @FocusState private var isEditingAPIKeyFocused: Bool
    
    
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
            .onAppear(perform: {
                password = ""
            })
            .toolbar(content: {
                Button {
                    if currentPassword == "" {
                        print("Current password cant be empty")
                        return
                    }
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
                    
                } label: {
                    Text(isEditingAPIKeyFocused ? "Save" : "Edit")
                }
            })
            .navigationTitle("API Config")
        }
    }
}

#Preview {
    APIKeyView()
}
