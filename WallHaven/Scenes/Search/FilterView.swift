import SwiftUI

struct FilterData: Identifiable {
    var id = UUID()
    var title: String
    var isSelected: Bool = false
}


struct FilterView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                GroupBox(
                    label: Label("Purity", systemImage: "18.circle.fill")
                        .foregroundColor(.red)
                        .bold()
                        .font(.title)
                ) {
                    HStack(spacing: 44) {
                        Button("SFW", action: {})
                            .fontWeight(.bold)
                            .padding(.vertical, 16)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .overlay(
                                Capsule()
                                    .stroke(Color.gray, lineWidth: 5)
                            )
                            .fixedSize(horizontal: false, vertical: false)
                        
                        Button("SKETCHY", action: {})
                            .fontWeight(.bold)
                            .padding(.vertical, 16)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .overlay(
                                Capsule()
                                    .stroke(Color.blue, lineWidth: 5)
                            )
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                
                Divider()
                
                GroupBox("Purity", content: { Text("Hi") })
                    .background(.clear)
                    .padding()
                Divider()
                
                GroupBox("Boo", content: { Text("Hi") })
                    .background(.clear)
                    .padding()
                
                Text("Content")
                HStack {
                    Button("SFW", action: {})
                    Button("NSFW", action: {})
                }
                Spacer()
                Button("Clear All") {
                    print("Clearing all")
                }
                .buttonStyle(.borderedProminent)
                .bold()
            
                
                Button(action: {}, label: {
                    HStack {
                        Text("Advanced Search")
                        Image(systemName: "chevron.down")
                        
                    }
                })
                .buttonStyle(.borderedProminent)
                .bold()

                
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FilterView()
}
