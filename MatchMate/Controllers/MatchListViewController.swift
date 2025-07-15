//
//  MatchListViewController.swift
//  MatchMate
//
//  Created by Jaynesh Patel on 15/07/25.
//

import UIKit
import CoreData
import Kingfisher

final class MatchListViewController: UITableViewController {
    private var users: [UserProfile] = []
    private var seenIDs: Set<String>   = []
    private let api = APIService()
    private var pageSize = 10
    
    private let context = PersistenceController.shared.container.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReset),
            name: .didResetAppCache,
            object: nil)
        title = "MatchMate"
        tableView.register(MatchCardCell.self,
                           forCellReuseIdentifier: "Card")
        tableView.separatorStyle = .none
        fetch()
    }
    
    @objc private func handleReset() {
        users.removeAll()
        seenIDs.removeAll()
        tableView.reloadData()
        fetch()
    }
    
    private func fetch() {
        api.fetch(results: pageSize) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    
                    let fresh = list.filter { [weak self] user in
                        guard let self = self else { return false }
                        let id = user.id.uuidString
                        guard !self.seenIDs.contains(id) else { return false }
                        self.seenIDs.insert(id)
                        return true
                    }
                    
                    // prefetch images for the truly new users
                    let urls = fresh.compactMap { URL(string: $0.picture.large) }
                    ImagePrefetcher(urls: urls).start()
                    
                    // append to data-source & update cache
                    self?.users += fresh
                    self?.cache(self?.users ?? [])
                    
                    self?.tableView.reloadData()
                case .failure:
                    self?.loadCached()
                }
            }
        }
    }
    
    // MARK: - Core Data cache
    private func cache(_ list: [UserProfile]) {
        let fetch: NSFetchRequest<NSFetchRequestResult> =
        MatchEntity.fetchRequest()
        
        list.forEach { user in
            let e = MatchEntity(context: context)
            e.uuid = user.id.uuidString
            e.firstName = user.name.first
            e.lastName  = user.name.last
            e.email     = user.email
            e.imageUrl  = user.picture.large
            e.thumbUrl  = user.picture.thumbnail
            e.age       = Int16(user.dob.age)
            e.status    = "Pending"
        }
        try? context.save()
    }
    
    private func loadCached() {
        if let entities = try? context.fetch(MatchEntity.fetchRequest()) {
            self.users = entities.map {
                UserProfile(
                    name: .init(first: $0.firstName ?? "",
                                last:  $0.lastName  ?? ""),
                    email: $0.email ?? "",
                    picture: .init(large: $0.imageUrl ?? "",
                                   thumbnail: $0.thumbUrl ?? $0.imageUrl ?? ""),
                    dob: .init(age: Int($0.age))
                )
            }
            tableView.reloadData()
        }
    }
    
    private func updateStatus(for user: UserProfile, to status: String) {
        let req: NSFetchRequest<MatchEntity> = MatchEntity.fetchRequest()
        req.predicate = NSPredicate(format: "uuid == %@", user.id.uuidString)
        
        if let match = try? context.fetch(req).first {
            match.status = status
            try? context.save()
        }
        if let idx = users.firstIndex(where: { $0.id == user.id }) {
            tableView.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .automatic)
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tv: UITableView,
                            numberOfRowsInSection s: Int) -> Int { users.count }
    
    override func tableView(_ tv: UITableView,
                            cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "Card",
                                          for: indexPath) as! MatchCardCell
        let user = users[indexPath.row]
        let status = (try? context.fetch(MatchEntity.fetchRequest())
            .first(where: { $0.uuid == user.id.uuidString })?.status) ?? "Pending"
        
        cell.configure(with: user,
                       status: status,
                       accept: { self.updateStatus(for: user, to: "Accepted") },
                       decline:{ self.updateStatus(for: user, to: "Declined") })
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat { 5 }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
    
    // MARK: - Pagination trigger
    override func scrollViewDidEndDragging(_ scroll: UIScrollView,
                                           willDecelerate decel: Bool) {
        let bottom = scroll.contentOffset.y + scroll.frame.size.height
        if bottom > scroll.contentSize.height - 150 {
            pageSize += 10
            fetch()
        }
    }
}
