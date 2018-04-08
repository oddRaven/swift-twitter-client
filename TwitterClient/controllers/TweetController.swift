import UIKit
import MessageUI
import Foundation

class TweetController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var createdAtText: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lowerCaseButton: UIButton!
    @IBOutlet weak var upperCaseButton: UIButton!
    
    var valuePassed: Tweet?
    var storageService = StorageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createdAtText.text = valuePassed?.tweetCreatedAt
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
            lowerCaseButton.setTitle("klein", for: .normal)
            upperCaseButton.setTitle("HOOFD", for: .normal)
        } else {
            createdAtLabel.text = "Posted on"
            textLabel.text = "Message"
            lowerCaseButton.setTitle("lower", for: .normal)
            upperCaseButton.setTitle("UPPER", for: .normal)
        }
    }
    
    @IBAction func upperCaseButtonClicked(_ sender: Any) {
        let newText = self.textView.text
        self.textView.text = newText?.uppercased()
    }
    
    @IBAction func lowerCaseButtonClicked(_ sender: UIButton) {
        let newText = self.textView.text
        self.textView.text = newText?.lowercased()
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
         UIPasteboard.general.string = self.textView.text
        
//        if (MFMessageComposeViewController.canSendText()) {
//            let controller = MFMessageComposeViewController()
//            controller.body = valuePassed?.tweetText
//            controller.messageComposeDelegate = self
//            self.present(controller, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(
//                title: "Error",
//                message: "No messaging app found",
//                preferredStyle: .alert
//            )
//
//            alert.addAction(UIAlertAction(title: "ok", style: .default))
//
//            self.present(alert, animated: true)
//        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

