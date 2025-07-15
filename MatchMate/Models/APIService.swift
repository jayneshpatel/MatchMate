//
//  APIService.swift
//  MatchMate
//
//  Created by Jaynesh Patel on 15/07/25.
//

import Foundation

final class APIService {
    func fetch(results: Int,
               completion: @escaping (Result<[UserProfile], Error>) -> Void) {
        let url = URL(string: "https://randomuser.me/api/?results=\(results)")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(decoded.results))
            } catch { completion(.failure(error)) }
        }.resume()
    }
}
