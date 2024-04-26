////
////  File.swift
////  
////
////  Created by Sachin on 24/04/24.
////
//
//import Alamofire
//import Foundation
//class DataManager {
//    func fetchData(completion: @escaping (Result<UserDataResponse, Error>) -> Void, pageNo: Int) {
//        let url = "https://reqres.in/api/users?page=\(pageNo)"
//        
//        AF.request(url).validate().responseDecodable(of: UserDataResponse.self) { response in
//            switch response.result {
//            case .success(let userDataResponse):
//                completion(.success(userDataResponse))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
