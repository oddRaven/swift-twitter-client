import Foundation
import UIKit

class OverviewViewController: UIViewController, UITableViewDataSource, LanguageChangedDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var storageService = StorageService()
    
    var valueToPass:Tweet!
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ApiService.shared.url(method: "GET", path: "1.1/statuses/home_timeline.json"){ status, jsonObject in
            if let tweetObjects = jsonObject as? [Any]{
                for case let tweet as [String:Any] in tweetObjects {
                    do{
                        let id = try tweet["id"]
                        let text = tweet["text"] as! String
                        let createdAt = tweet["created_at"] as! String
                        var username: String = ""
                        if case let user as [String:Any] = tweet["user"]{
                            username = user["name"] as! String
                        }
                        self.tweets += [Tweet(text: text, createdAt: createdAt)]
                    }catch{
                        print(error)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        //tweets += [Tweet(text: "Tweet text",createdAt: "12-12-1992"),Tweet(text: "Tweet text 2",createdAt: "01-01-1900")]
        
        self.tableView.tableFooterView = UIView()
        
        let language = storageService.getLanguage();
        translate(language: language)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        } else {
            self.title = "Overview"
            settingsButton.setTitle("Settings", for: .normal)
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
}
