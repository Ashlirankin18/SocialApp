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
      NetworkHelper.shared.performDataTask(endpointURLString: urlString, httpMethod: "GET", httpBody: nil) { (error, data, response) in
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
      NetworkHelper.shared.performDataTask(endpointURLString: urlString, httpMethod: "GET", httpBody: nil) { (error, data, response) in
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
      NetworkHelper.shared.performDataTask(endpointURLString: urlString, httpMethod: "GET", httpBody: nil) { (error, data, response) in
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
  static func postComment(data:Data,completionHandler: @escaping (AppError?,Bool) -> Void){
    let urlString = "http://5c328826fe034a001404dcff.mockapi.io/comments"
    NetworkHelper.shared.performUploadTask(endpointURLString: urlString, httpMethod: "POST", httpBody: data) { (error, data, httpResponse) in
      if let error = error{
        completionHandler(error,false)
      }
      guard let response = httpResponse, (200...299).contains(response.statusCode) else {
        let statusCode = httpResponse?.statusCode ?? -999
        completionHandler(AppError.badStatusCode(String(statusCode)), false)
        return
        
      }
      if let _ = data {
        completionHandler(nil,true)
      }
    }
  }
  static func fetchComments(completionHandler: @escaping (AppError?,[Comments]?) -> Void){
    let urlString = "http://5c328826fe034a001404dcff.mockapi.io/comments"
    NetworkHelper.shared.performDataTask(endpointURLString: urlString, httpMethod: "GET", httpBody: nil) { (error, comments, httpResponse) in
      if let error = error {
        completionHandler(AppError.badURL(error.errorMessage()),nil)
      }
      if let comments = comments{
        do {
          let comments = try JSONDecoder().decode([Comments].self, from: comments)
          completionHandler(nil,comments)
        } catch {
          completionHandler(AppError.decodingError(error),nil)
        }
        
      }
    }
  }
}

