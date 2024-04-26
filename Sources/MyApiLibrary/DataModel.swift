
////
////  DataModel.swift

////  Created by Sachin on 24/04/24.
////
//
//
//// Define a struct to represent the user data
struct User: Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}

struct UserDataResponse: Codable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    var data: [User]
    let support: support
}

struct support: Codable {
    let url: String
    let text: String
}



