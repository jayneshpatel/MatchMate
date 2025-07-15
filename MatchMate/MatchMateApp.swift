//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Jaynesh Patel on 15/07/25.
//

import SwiftUI

@main
struct MatchMateApp: App {
    private let persistence = PersistenceController.shared
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            UIKitContainer() // embeds UIKit VC in SwiftUI
                .environment(\.managedObjectContext,
                              persistence.container.viewContext)
                .onAppear {
                    ResetService.purgeAll()
                }
                .onChange(of: phase) { newPhase in
                    if newPhase == .active {
                        // Reset when app enters foreground
                        ResetService.purgeAll()
                }
            }
        }
    }
}

private struct UIKitContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: MatchListViewController())
    }
    func updateUIViewController(_ uiViewController: UINavigationController,
                                context: Context) { }
}
