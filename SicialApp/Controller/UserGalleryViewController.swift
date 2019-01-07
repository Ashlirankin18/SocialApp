//
//  UserGalleryViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/31/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import UIKit

class UserGalleryViewController: UIViewController {
  @IBOutlet weak var userGallaryCollectionView: UICollectionView!
  
  private var galleryImages = [ImageQualities]() {
    didSet {
      DispatchQueue.main.async {
        self.userGallaryCollectionView.reloadData()
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    getUserGalleryImageData()
    userGallaryCollectionView.dataSource = self
  }
  private func getUserGalleryImageData(){
    UsersApiClient.getRelatedImages { (error, images) in
      if let error = error {
        print(error.errorMessage())
      }
      if let images = images {
        self.galleryImages = images.filter{$0.id % 2 == 0 && $0.id < 100}
      }
    }
  }
  private func makeList(_ n: Int) -> [Int]{
    return (0..<n).map{_ in Int.random( in: 1...2000) }
  }
  
  @IBAction func likeButtonPressed(_ sender: UIButton) {
    sender.setImage(#imageLiteral(resourceName: "icons8-heart-outline-filled-50 (3).png"), for: .normal)
    guard let like = sender.currentTitle?.components(separatedBy: " " ) else {return}
    if let likeUnwrapped = like.first {
      guard let likeInt = Int(likeUnwrapped) else {return}
      let increasedLike = likeInt + 1
      sender.setTitle("\(increasedLike) Likes", for: .normal)
    }
  }
  
  private func getUserGalleryImages(id:Int,imageView:UIImageView){
    let urlString = "https://picsum.photos/200/300?image=\(id)"
    ImageHelper.shared.fetchImage(urlString: urlString) { (error, image) in
      if let error = error {
        print(error.errorMessage())
      }
      if let image = image {
        imageView.image = image
      }
    }
  }
}
extension UserGalleryViewController:UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return galleryImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let numberOfLikes = makeList(galleryImages.count)
    guard let cell = userGallaryCollectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as? GalleryCollectionViewCell else {fatalError("No Cell Found")}
    getUserGalleryImages(id: galleryImages[indexPath.row].id, imageView: cell.galleryCell)
    cell.likeButton.setTitle("\(numberOfLikes[indexPath.row]) Likes", for: .normal)
    return cell
  }
}
