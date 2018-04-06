import UIKit

class OverviewViewController: UIViewController, UITableViewDataSource, LanguageChangedDelegate {
    
    @IBOutlet weak var settingsButton: UIButton!
    
    var storageService = StorageService()
    
    var valueToPass:Tweet!
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tweets += [Tweet(text: "Tweet text",createdAt: "12-12-1992"),Tweet(text: "Tweet text 2",createdAt: "01-01-1900")]
        
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

            viewController.valuePassed = valueToPass
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: send selected tweet to detail
        let indexPath = tableView.indexPathForSelectedRow!
        
        valueToPass = tweets[indexPath.row]
        performSegue(withIdentifier: "showDetailViewController", sender: self)
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
