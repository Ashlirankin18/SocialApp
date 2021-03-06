//
//  NewsFeedViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/27/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//
import UIKit
class NewsFeedViewController: UIViewController {
  @IBOutlet weak var newsFeedTableView: UITableView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userImage: UIImageView!
 
  var postIsLiked = false
  
  private var allUsers = [User]() {
    didSet{
      DispatchQueue.main.async {
        self.newsFeedTableView.reloadData()
      }
    }
  }
  var slicedArray = [User]()
  private var currentAppUser: User?
  private var posts = [PostInfo]() {
    didSet {
      DispatchQueue.main.async {
        self.newsFeedTableView.reloadData()
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    getPost()
    newsFeedTableView.delegate = self
    newsFeedTableView.dataSource = self
    
  }
  
  
  @IBAction func likeButtonPressed(_ sender: UIButton) {
    setLike(button: sender)
    
    }
  @IBAction func saveButtonPressed(_ sender: UIButton) {
    sender.setImage(#imageLiteral(resourceName: "icons8-bookmark-filled-25.png"), for: .normal)
    getCell()
  }
  
  @IBAction func commentButtonPressed(_ sender: UIButton) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let vc =  storyBoard.instantiateViewController(withIdentifier: "commentController")
    self.present(vc, animated: true, completion: nil)
  }
  
  func getCell(){
  guard let indexPath = newsFeedTableView.indexPathForSelectedRow,
    let cell = newsFeedTableView.cellForRow(at: indexPath) as? NewsFeedTableViewCell else {return}
    let user = allUsers[indexPath.row]
    let userName = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
 guard let post:String  = cell.userPost.text,
  let date:String = cell.postPublishedData.text else {return}
    let favorite = FavoritePost.init(like: userName, publish_date: date, story_text: post, userImage: user.picture.large.absoluteString)
    do{
      let data = try JSONEncoder().encode(favorite)
      UsersApiClient.sendFavLike(data: data) { (error, sucess) in
        if let error = error{
          self.setUpAlertControl(title: "Error!", message: error.errorMessage())
        }
        else if sucess{
          self.setUpAlertControl(title: "Sucess!", message: "Sucessfully Saved")
        } else {
          self.setUpAlertControl(title: "No Go", message: "Post was not saved")
        }
      }
    } catch{
       print("Encoding Error: \(error)")
    }
   
  }
  
  private func makeList(_ n: Int) -> [Int]{
    return (0..<n).map{_ in Int.random( in: 1...2000) }
  }
  private func setImages(url:URL, imageView:UIImageView){
    ImageHelper.shared.fetchImage(urlString: url.absoluteString) { (error, image) in
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
  private func setUpAlertControl(title:String,message:String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  func setLike(button:UIButton){
    if !postIsLiked {
      button.setImage(#imageLiteral(resourceName: "icons8-heart-outline-filled-25.png"), for: .normal)
      guard let like = button.currentTitle?.components(separatedBy: " " ) else {return}
      if let likeUnwrapped = like.first {
        guard let likeInt = Int(likeUnwrapped) else {return}
        let increasedLike = likeInt + 1
        button.setTitle("\(increasedLike) Likes", for: .normal)
        postIsLiked = true
      }
    } else {
      button.setImage(#imageLiteral(resourceName: "icons8-heart-outline-25.png"), for: .normal)
      guard let like = button.currentTitle?.components(separatedBy: " " ) else {return}
      if let likeUnwrapped = like.first {
        guard let likeInt = Int(likeUnwrapped) else {return}
        let decreasedLike = likeInt - 1
        button.setTitle("\(decreasedLike) Likes", for: .normal)
        postIsLiked = false
      }
    }
  }
  private func getPost(){
    UsersApiClient.getUserPost(numberOfResults: 20) { (error, posts) in
      if let error = error {
        print(error.errorMessage())
      }
      if let posts = posts {
        self.posts = posts
        self.getUsers()
        
      }
    }
  }
 
  private func getUsers(){
    UsersApiClient.getUserInfo(numberOfResults: 20) { (error, users) in
      if let error = error {
        print(error.errorMessage())
      }
      if var  users = users {
        self.currentAppUser = users[0]
        if let user = users.first {
          UserSession.setUser(user: user)
        }
        
        let _ = users.removeFirst()
        
        self.allUsers = users
        DispatchQueue.main.async{
        self.setsUpUserCredentials()
        }
      }
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let indexPath = newsFeedTableView.indexPathForSelectedRow,
      let destination = segue.destination as? GeneralProfileViewController else {fatalError()}
    destination.user = allUsers[indexPath.row]
    
  }
  
  private func setsUpUserCredentials(){
  self.setImages(url: (currentAppUser?.picture.large)!, imageView: self.userImage)
      self.userName.text = "\(self.currentAppUser!.name.first.capitalized) \(self.currentAppUser!.name.last.capitalized)"
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
extension NewsFeedViewController:UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allUsers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let post = posts[indexPath.row]
    let numberOfLikes = makeList(posts.count)
    guard let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: "newsFeedCell", for: indexPath) as? NewsFeedTableViewCell,
      allUsers.count > 0 else { return UITableViewCell()
    }
    let oneUser = allUsers[indexPath.row]
    cell.userName.text = "\(oneUser.name.first.capitalized) \(oneUser.name.last.capitalized)"
    setImages(url: oneUser.picture.thumbnail, imageView: cell.userImage)
    cell.userPost.text = post.attributes.story_text
    cell.likeButton.setTitle("\(numberOfLikes[indexPath.row]) Likes", for: .normal)
    cell.commentButton.setTitle("Comments", for: .normal)
    cell.postPublishedData.text = convertTheDate(timeInterval: Double(post.attributes.publish_date)!)
   
    return cell
  }
}
extension NewsFeedViewController:UITableViewDelegate{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
}

