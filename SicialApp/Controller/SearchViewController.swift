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
  private var allUsers = [User]() {
    didSet {
      DispatchQueue.main.async {
        self.userImagesCollectionView.reloadData()
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    getUsers()
    getImageData()
    searchBar.delegate = self
    userImagesCollectionView.dataSource = self
  }
  
  private func getUsers(){
    UsersApiClient.getUserInfo(numberOfResults: 993) { (error, users) in
      if let error = error {
        print(error.errorMessage())
      }
      if let users = users {
        self.allUsers = users
        self.getImageData()
      }
    }
  }
  @IBAction func likeButton(_ sender: UIButton) {
    sender.setImage(#imageLiteral(resourceName: "icons8-heart-outline-filled-50 (3).png"), for: .normal)
    guard let like = sender.currentTitle?.components(separatedBy: " " ) else {return}
    if let likeUnwrapped = like.first {
      guard let likeInt = Int(likeUnwrapped) else {return}
      let increasedLike = likeInt + 1
      sender.setTitle("\(increasedLike) Likes", for: .normal)
  }
  }
  private func getImageData(){
    UsersApiClient.getRelatedImages { (error, imageQualities) in
      if let error = error {
        print(error.errorMessage())
      }
      if let imageQualities = imageQualities {
        self.allPlatformImages = imageQualities
      }
    }
  }
  func searchImages(id:Int,imageView:UIImageView){
    let urlString = "https://picsum.photos/200/300?image=\(id)"
    ImageHelper.shared.fetchImage(urlString: urlString) { (error, image) in
      if let error = error {
        print(error.errorMessage())
      }
      if let image = image {
        DispatchQueue.main.async {
          imageView.image = image
        }
      }
    }
  }
  private func makeList(_ n: Int) -> [Int]{
    return (0..<n).map{_ in Int.random( in: 1...2000) }
  }
}
extension SearchViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return  allPlatformImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let numberOfLikes = makeList(allPlatformImages.count)
    guard let cell = userImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "userImageCell", for: indexPath) as? RelatedImagesCollectionViewCell else {fatalError("No cell found")}
    cell.likeButton.setTitle("\(numberOfLikes[indexPath.row]) Likes", for: .normal)
    searchImages(id: allPlatformImages[indexPath.row].id, imageView: cell.userImage)
    
    return cell
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if let searchText = searchBar.text {
      let filteredUserArray = allUsers.filter{$0.name.first.capitalized.contains(searchText.capitalized)}
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let vc = storyboard.instantiateViewController(withIdentifier: "searchStroyboard") as? SearchResultsViewController else {fatalError()}
      vc.users = filteredUserArray
      self.present(vc, animated: true, completion: nil)
      
    }
  }
}


