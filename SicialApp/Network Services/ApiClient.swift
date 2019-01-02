//
//  ApiClient.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/27/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import Foundation
final class UsersApiClient {
    static func getUserInfo(numberOfResults:Int,completionHandler: @escaping (AppError?,[User]?) -> Void){
    let urlString = "https://randomuser.me/api/?results=\(numberOfResults)"
        NetworkHelper.performDataTask(urlString: urlString, httpMethod: "Get") { (error, data, response) in
            if let error = error {
                completionHandler(error,nil)
            }
            if let data = data {
                do{
                    let userData = try JSONDecoder().decode(AllUsers.self, from:data).results
                    completionHandler(nil,userData)
                } catch{
                    completionHandler(AppError.decodingError(error),nil)
                }
            }
        }
    }
    static func getUserPost(numberOfResults:Int, completionHandler: @escaping (AppError?,[PostInfo]?) -> Void){
        let urlString = "https://manystoriesoneheart.gr/api/stories?range=\(numberOfResults)"
        NetworkHelper.performDataTask(urlString: urlString, httpMethod: "Get") { (error, data, response) in
            if let error = error {
                completionHandler(error,nil)
            }
            if let data = data {
                do{
                    let postData =  try JSONDecoder().decode(Posts.self, from: data).data
                    completionHandler(nil,postData)
                }catch{
                    completionHandler(AppError.decodingError(error),nil)
                }
            }
        }
    }
    static func getRelatedImages(completionHandler: @escaping (AppError?,[ImageQualities]?) -> Void) {
        let urlString = "https://picsum.photos/list"
        NetworkHelper.performDataTask(urlString: urlString, httpMethod: "Get") { (error, data, response) in
            if let error = error {
                completionHandler(error,nil)
            }
            if let data = data {
                do {
              let relatedImages = try JSONDecoder().decode([ImageQualities].self, from: data)
                    completionHandler(nil,relatedImages)
                } catch{
                    completionHandler(AppError.decodingError(error),nil)
                }
            }
        }
    }
}

