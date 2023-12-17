import SwiftUI

struct PannableImageView: View {
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero

    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: "https://w.wallhaven.cc/full/7p/wallhaven-7pmj9o.jpg")!) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .offset(x: offset.width, y: offset.height)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = CGSize(
                                    width: lastOffset.width + gesture.translation.width,
                                    height: lastOffset.height + gesture.translation.height
                                )
                            }
                            .onEnded { _ in
                                let uiImage = ImageRenderer(content: image).uiImage
                                guard let uiImage = uiImage else { return }

                                // Calculate the bounds and restrict the offset
                                let imageWidth = uiImage.size.width
                                let imageHeight = uiImage.size.height
                                let screenSize = geometry.size

                                // Calculate the scale of the image
                                let scaleX = screenSize.width / imageWidth
                                let scaleY = screenSize.height / imageHeight
                                let scale = max(scaleX, scaleY)

                                // Calculate the bounds
                                let boundWidth = (imageWidth * scale - screenSize.width) / 2
                                let boundHeight = (imageHeight * scale - screenSize.height) / 2

                                // Restrict the offset
                                let newOffset = CGSize(
                                    width: min(boundWidth, max(-boundWidth, offset.width)),
                                    height: min(boundHeight, max(-boundHeight, offset.height))
                                )

                                offset = newOffset
                                lastOffset = newOffset
                            }
                    )
            } placeholder: {
                ProgressView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// Preview code

#Preview {
    PannableImageView()
}
