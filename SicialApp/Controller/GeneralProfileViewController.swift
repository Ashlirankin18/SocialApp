//
//  GeneralProfileViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 1/1/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class GeneralProfileViewController: UIViewController {
  @IBOutlet weak var generalUserTableView: UITableView!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userProfileImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userGender: UILabel!
  @IBOutlet weak var userAddress: UILabel!
  var user: User?
  var posts = [PostInfo](){
    didSet {
      DispatchQueue.main.async {
        self.generalUserTableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUi()
     getPost()
    generalUserTableView.dataSource = self
    generalUserTableView.delegate = self
  }
  
  private func getUserImage(url:String,imageView:UIImageView){
    ImageHelper.shared.fetchImage(urlString: url) { (error, image) in
      if let error = error {
        print(error.errorMessage())
      }
      if let image = image {
        imageView.image = image
      }
    }
  }
  private func getPost(){
    UsersApiClient.getUserPost(numberOfResults: 20) { (error, posts) in
      if let error = error{
        print(error.errorMessage())
      }
      if let posts = posts{
        self.posts = posts
      }
    }
  }
  private func setUi(){
    userName.text = "\(user!.name.first.capitalized) \(user!.name.last.capitalized)"
    userGender.text = user?.gender.capitalized
    userAddress.text = "\(user!.location.city.capitalized) \(user!.location.state.capitalized) \(user!.location.street.capitalized)"
    getUserImage(url: (user?.picture.large.absoluteString)!, imageView: userProfileImage)
    getUserImage(url: "https://picsum.photos/400/300/?random", imageView: userImage)
  }
  @IBAction func backButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  private func makeList(_ n: Int) -> [Int]{
    return (0..<n).map{_ in Int.random( in: 1...2000) }
  }
  @IBAction func likeButton(_ sender: UIButton) {
    sender.setImage(#imageLiteral(resourceName: "icons8-heart-outline-filled-25.png"), for: .normal)
    guard let like = sender.currentTitle?.components(separatedBy: " " ) else {return}
    if let likeUnwrapped = like.first {
      guard let likeInt = Int(likeUnwrapped) else {return}
      let increasedLike = likeInt + 1
      sender.setTitle("\(increasedLike) Likes", for: .normal)
    }
  }
  
  @IBAction func commentButton(_ sender: UIButton) {
    sender.setImage(#imageLiteral(resourceName: "icons8-comments-filled-25.png"), for: .normal)
  }
  private func convertTheDate(timeInterval:Double) -> String{
    let timeInterval = timeInterval
    let date = Date(timeIntervalSince1970: timeInterval)
    let dateFormater = DateFormatter()
    dateFormater.timeZone = TimeZone(abbreviation: "GMT")
    dateFormater.locale = NSLocale.current
    dateFormater.dateFormat = "yyyy-MM-dd HH:mm"
    let strDate = dateFormater.string(from: date)
    return strDate
  }
  
}
extension GeneralProfileViewController:UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let numberOfLikes = makeList(posts.count)
    guard let cell = generalUserTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? GeneralUserTableViewCell else {fatalError()}
    let post = posts[indexPath.row].attributes
    getUserImage(url: (user?.picture.large.absoluteString)!, imageView: cell.userImage)
    cell.userPost.text = post.story_text
    cell.userName.text = "\(user!.name.first.capitalized) \(user!.name.last.capitalized)"
    cell.likeButton.setTitle("\(numberOfLikes[indexPath.row]) Likes", for: .normal)
    cell.commentButton.setTitle("Comments", for: .normal)
    cell.publishedDate.text = convertTheDate(timeInterval: Double(post.publish_date)!)
    return cell
  }
  
}
extension GeneralProfileViewController:UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }

}
