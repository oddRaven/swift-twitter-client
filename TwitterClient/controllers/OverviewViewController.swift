import Foundation
import UIKit

class OverviewViewController: UIViewController, UITableViewDataSource, LanguageChangedDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var outsideMenuView: UIView!
    
    var storageService = StorageService.shared
    
    var valueToPass:Tweet!
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.outsideMenuViewgTabbed))
        self.outsideMenuView.addGestureRecognizer(gesture)

        ApiService.shared.get(path: "1.1/statuses/home_timeline.json"){ status, jsonObject in
            if let tweetObjects = jsonObject as? [Any]{
                for case let tweet as [String:Any] in tweetObjects {
                    let id = tweet["id"] as! Int
                    let text = tweet["text"] as! String
                    let createdAt = tweet["created_at"] as! String
                    var username: String = ""
                    if case let user as [String:Any] = tweet["user"]{
                        username = user["name"] as! String
                    }
                    self.tweets += [Tweet(id: id, username: username, text: text, createdAt: createdAt)]
                }
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
        
        self.tableView.tableFooterView = UIView()
        
        let language = storageService.getLanguage();
        translate(language: language)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        menuView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettingsViewController" {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.delegate = self
        }
        
        if (segue.identifier == "showDetailViewController") {
            let viewController = segue.destination as! TweetController
            viewController.valuePassed = tweets[self.tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func translate(language: String) {
        if (language == "Nederlands") {
            self.title = "Overzicht"
            settingsButton.setTitle("Instellingen", for: .normal)
            signOutButton.setTitle("Uitloggen", for: .normal)
        } else {
            self.title = "Overview"
            settingsButton.setTitle("Settings", for: .normal)
            signOutButton.setTitle("Sign out", for: .normal)
        }
    }
    
    func changedLanguage() {
        let language = storageService.getLanguage();
        translate(language: language)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath)
        
        cell.textLabel?.text = tweets[indexPath.row].tweetText
        
        return cell
    }
    
    @IBAction func btnMenuPressed(_ sender: Any) {
        if menuView.isHidden{
            menuView.isHidden = false
        }else{
            menuView.isHidden = true
        }
    }
    
    @objc func outsideMenuViewgTabbed(sender : UITapGestureRecognizer) {
        menuView.isHidden = true
    }
    
    @IBAction func btnSignOutPressed(_ sender: Any) {
        StorageService.shared.setAccessToken("")
        StorageService.shared.setAccessTokenSecret("")
        
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
    }
}
