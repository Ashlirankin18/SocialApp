//
//  SearchViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/28/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var userImagesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var allPlatformImages = [ImageQualities](){
        didSet{
            DispatchQueue.main.async{
                self.userImagesCollectionView.reloadData()
            }
        }
    }
    private var allUsers = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
       getUsers()
        userImagesCollectionView.dataSource = self
    }
    private func getUsers(){
        UsersApiClient.getUserInfo(numberOfResults: allPlatformImages.count) { (error, users) in
            if let error = error {
                print(error.errorMessage())
            }
            if let users = users {
                self.allUsers = users
            }
        }
    }
}
extension SearchViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return  allPlatformImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = userImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "userImageCell", for: indexPath) as? RelatedImagesCollectionViewCell else {fatalError("No cell found")}
        return cell
    }
    
    
}
extension SearchViewController: UISearchBarDelegate {
    
}
