import UIKit

class TweetController: UIViewController {
    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var createdAtText: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var valuePassed: Tweet?
    
    var storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createdAtLabel.text = valuePassed?.tweeTcreatedAt
        textView.text = valuePassed?.tweetText
        
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
            textLabel.text = "Bericht"
        } else {
            createdAtLabel.text = "Posted on"
            textLabel.text = "Message"
        }
    }
}
