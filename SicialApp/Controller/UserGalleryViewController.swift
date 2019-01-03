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
  private func getUserGalleryImages(id:Int,imageView:UIImageView){
    let urlString = "https://picsum.photos/200/300?image=\(id)"
    ImageHelper.fetchImage(urlString: urlString) { (error, image) in
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
    guard let cell = userGallaryCollectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as? GalleryCollectionViewCell else {fatalError("No Cell Found")}
    getUserGalleryImages(id: galleryImages[indexPath.row].id, imageView: cell.galleryCell)
    return cell
  }
  
  
}
