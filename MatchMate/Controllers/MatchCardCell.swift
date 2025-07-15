//
//  MatchCardCell.swift
//  MatchMate
//
//  Created by Jaynesh Patel on 15/07/25.
//

import UIKit
import SwiftUI

final class MatchCardCell: UITableViewCell {
    private var host: UIHostingController<AnyView>?
    
    func configure(with user: UserProfile,
                   status: String,
                   accept: @escaping () -> Void,
                   decline: @escaping () -> Void) {
        
        let card = MatchCardView(user: user,
                                 status: .constant(status),
                                 onTapAccept: accept,
                                 onTapDecline: decline)
            .padding(.vertical, 12)
        
        let any = AnyView(card)
        
        if let host {
            host.rootView = any
        } else {
            let hostVC = UIHostingController(rootView: any)
            hostVC.view.backgroundColor = .clear
            host = hostVC
            contentView.addSubview(hostVC.view)
            hostVC.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostVC.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }
}
