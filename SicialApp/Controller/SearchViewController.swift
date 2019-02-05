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
  var isLiked = false
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
    searchBar.delegate = self
    userImagesCollectionView.dataSource = self
  }
  private func setUpAlertControl(title:String,message:String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  @IBAction func saveButtonPressed(_ sender: UIButton) {
    
    let image = allPlatformImages[sender.tag]
    let favoriteImage = FavoritePost.init(like: "Ashli Rankin", publish_date: "", story_text: image.filename, userImage: "\(image.id)")
    do {
      let data = try JSONEncoder().encode(favoriteImage)
      UsersApiClient.sendFavLike(data: data) { (error, sucess) in
        if let error = error{
          self.setUpAlertControl(title: "Error", message: error.errorMessage())
        }
        else if sucess {
          self.setUpAlertControl(title: "Sucess", message: "Sucessfully Faved")
        }
      }
    } catch {
      self.setUpAlertControl(title: "No Go", message: " Error")
    }
    

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
    setLike(button: sender)
  }

    func setLike(button:UIButton){
      if !isLiked {
        button.setImage(#imageLiteral(resourceName: "icons8-heart-outline-filled-50 (4).png"), for: .normal)
        guard let like = button.currentTitle?.components(separatedBy: " " ) else {return}
        if let likeUnwrapped = like.first {
          guard let likeInt = Int(likeUnwrapped) else {return}
          let increasedLike = likeInt + 1
          button.setTitle("\(increasedLike) Likes", for: .normal)
          isLiked = true
        }
      } else {
        button.setImage(nil, for: .normal)
        guard let like = button.currentTitle?.components(separatedBy: " " ) else {return}
        if let likeUnwrapped = like.first {
          guard let likeInt = Int(likeUnwrapped) else {return}
          let decreasedLike = likeInt - 1
          button.setTitle("\(decreasedLike) Likes", for: .normal)
          isLiked = false
        }
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
    cell.saveButton.tag = indexPath.row
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


