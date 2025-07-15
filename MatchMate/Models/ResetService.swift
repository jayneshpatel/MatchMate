//
//  ResetService.swift
//  MatchMate
//
//  Created by Jaynesh Patel on 15/07/25.
//

import CoreData
import Kingfisher

struct ResetService {
    
    static func purgeAll() {
        
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
        
        NotificationCenter.default.post(name: .didResetAppCache, object: nil)
    }
}


extension Notification.Name {
    static let didResetAppCache = Notification.Name("didResetAppCache")
}
