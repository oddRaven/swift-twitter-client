import UIKit

class TweetController: UIViewController {
    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var createdAtText: UITextField!
    @IBOutlet weak var hashtagTableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let language = storageService.getLanguage()
        translate(language: language)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func translate(language: String) {
        if (language == "Nederlands") {
            createdAtLabel.text = "Geplaatst op"
            hashtagLabel.text = "Gebruikte hashtags"
            textLabel.text = "Bericht"
        } else {
            createdAtLabel.text = "Posted on"
            hashtagLabel.text = "Used hashtags"
            textLabel.text = "Message"
        }
    }
}
