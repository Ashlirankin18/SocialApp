//
//  ImageHelper.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/27/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import UIKit
final class ImageHelper {
    static func fetchImage(urlString: String, completionHandler: @escaping (AppError?, UIImage?) -> Void) {
        NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data, response) in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completionHandler(nil, image)
                }
            }
        }
    }
}
