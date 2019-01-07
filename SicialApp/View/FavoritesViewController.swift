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
      favoriteItemsCollectionView.dataSource = self
    }
  
  @IBAction func backButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  

}
extension FavoritesViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row % 2 == 0 {
      let cell = favoriteItemsCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath)
      return cell
    } else {
      let cell = favoriteItemsCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
      return cell
    }
  }
  
  
}
