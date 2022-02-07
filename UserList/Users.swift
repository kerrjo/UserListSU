//
//  Users.swift
//  UserList
//
//  Created by JOSEPH KERR on 2/7/22.
//

import Foundation

enum WebServiceError: Error {
    case err
    case error(Error)
}
typealias ServiceResult = (Result<Users,WebServiceError>) -> Void

protocol WebService {
    func fetch(completion: @escaping ServiceResult)
}

// https://jsonplaceholder.typicode.com/users

struct UserService: WebService {
    func fetch(completion: @escaping ServiceResult) {
        DispatchQueue.global().async {
            self.fetchUsers(completion: completion)
        }
    }
    private func fetchUsers(completion: @escaping ServiceResult) {
        let decoder = JSONDecoder()
        guard let jsonData = try? Data(contentsOf: URL(string: "https://jsonplaceholder.typicode.com/users")!),
              let users = try? decoder.decode(Users.self, from: jsonData) else {
                  return completion(.failure(WebServiceError.err))
              }
        completion(.success(users))
    }
}

struct UserWebService {
    static func fetchUsers() async -> Result<Users,WebServiceError> {
        let decoder = JSONDecoder()
        guard let jsonData = try? Data(contentsOf: URL(string: "https://jsonplaceholder.typicode.com/users")!),
              let users = try? decoder.decode(Users.self, from: jsonData) else {
                  return .failure(WebServiceError.err)
              }
        return .success(users)
    }
}



// This file was generated from JSON Schema using quicktype, do not modify it directly.
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - UserElement
struct UserElement: Codable, Identifiable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}

typealias Users = [UserElement]
