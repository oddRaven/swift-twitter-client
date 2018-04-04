import UIKit

class OverviewViewController: UIViewController, LanguageChangedDelegate {
  
    @IBOutlet weak var settingsButton: UIButton!
    
    var storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
}
