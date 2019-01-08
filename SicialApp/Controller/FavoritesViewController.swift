//
//  FavoritesViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 1/7/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
class FavoritesViewController: UIViewController {
  @IBOutlet weak var favoriteItemsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
      getfavPost()
      favoriteItemsCollectionView.dataSource = self
    }
  var favoritePost = [FavoritePost](){
    didSet{
      DispatchQueue.main.async {
        self.favoriteItemsCollectionView.reloadData()
      }
    }
  }
  
  @IBAction func backButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  private func getfavPost(){
    UsersApiClient.getFavPosts { (error, favoritePost) in
      if let error = error{
        print(error.errorMessage())
      }
      if let favoritePost = favoritePost{
        self.favoritePost = favoritePost
      }
    }
  }
  private func setImages(url:String, imageView:UIImageView){
    ImageHelper.shared.fetchImage(urlString: url) { (error, image) in
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

}
extension FavoritesViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return favoritePost.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let fav = favoritePost[indexPath.row]
      guard let cell = favoriteItemsCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? FavoritePostCollectionViewCell else {fatalError()}
    setImages(url: fav.userImage, imageView: cell.userImage)
      cell.userName.text = fav.like
      cell.pubilshedDate.text = fav.publish_date
      cell.userPost.text = fav.story_text
      return cell
    }
  }

