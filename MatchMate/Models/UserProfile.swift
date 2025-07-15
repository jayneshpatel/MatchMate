//
//  UserProfile.swift
//  MatchMate
//
//  Created by Jaynesh Patel on 15/07/25.
//

import Foundation

struct APIResponse: Decodable {
    let results: [UserProfile]
}

struct UserProfile: Decodable, Identifiable {
    let id = UUID()
    let name: Name
    let email: String
    let picture: Picture
    let dob: DOB
    
    struct Name: Decodable {
        let first: String;
        let last: String
    }
    
    struct Picture: Decodable {
        let large: String
        let thumbnail: String
    }
    
    struct DOB: Decodable {
        let age: Int
    }
}
