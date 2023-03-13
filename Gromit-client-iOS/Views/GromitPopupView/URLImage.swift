//
//  URLImage.swift
//  Gromit-client-iOS
//
//  Created by 김태성 on 2023/03/11.
//

import SwiftUI

// test "https://avatars.githubusercontent.com/u/94947?v=4"
struct UR22LImage: View {
    
    @State private var image: UIImage?
    let urlString: String

    var body: some View {
        content
            .onAppear {
                NetworkingClinet.shared.requestURLImage(imageURL: urlString, completion: { urlImage in
                    if let urlImage = urlImage {
                        image = urlImage
                    }
                })
            }
    }

    private var content: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)

            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))            }
        }
    }
}


struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(urlString: "https://avatars.githubusercontent.com/u/94947?v=4")
    }
}
