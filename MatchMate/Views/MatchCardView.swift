//
//  MatchCardView.swift
//  MatchMate
//
//  Created by Jaynesh Patel on 15/07/25.
//

import SwiftUI
import Kingfisher

struct MatchCardView: View {
    let user: UserProfile
    @Binding var status: String
    let onTapAccept: () -> Void
    let onTapDecline: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // hero image -------------------------------------------------
            ZStack(alignment: .bottomLeading) {
                
                KFImage(URL(string: user.picture.large))
                    .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 300)))
                    .placeholder {
                        // show cached thumbnail immediately
                        KFImage(URL(string: user.picture.thumbnail))
                            .resizable()
                            .scaledToFill()
                    }
                    .cacheOriginalImage()
                    .loadDiskFileSynchronously()
                    .onlyFromCache()
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 260)
                    .clipped()
                    .cornerRadius(20)

                LinearGradient(colors: [.black.opacity(0.6), .clear],
                               startPoint: .bottom, endPoint: .center)
                    .frame(height: 80)
                    .cornerRadius(20)

                VStack(alignment: .leading) {
                    Text("\(user.name.first) \(user.name.last), \(user.dob.age)")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text(user.email)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding()
            }
            // ------------------------------------------------------------

            if status == "Pending" {
                HStack(spacing: 12) {
                    Button(action: onTapDecline) {
                        Label("Decline", systemImage: "xmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button(action: onTapAccept) {
                        Label("Accept", systemImage: "checkmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            } else {
                Text("Member \(status)")
                    .font(.subheadline.bold())
                    .foregroundColor(status == "Accepted" ? .green : .red)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 8)
        .padding(.horizontal)
        .transition(.scale.combined(with: .opacity))
        .animation(.easeInOut, value: status)
    }
}
