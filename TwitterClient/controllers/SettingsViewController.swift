import UIKit

protocol LanguageChangedDelegate: class {
    func changedLanguage()
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    weak var delegate: LanguageChangedDelegate? = nil
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
    var languages = ["Nederlands", "English"]
    var storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let language = storageService.getLanguage()
        
        self.dropDown.isHidden = true;
        textBox.text = language
        
        translate(language: language)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.textBox.text = self.languages[row]
        translate(language: self.languages[row])
        storageService.setLanguage(newLanguage: self.languages[row])
        
        delegate?.changedLanguage()
        
        self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textBox {
            self.dropDown.isHidden = false
            textField.endEditing(true)
        }
    }
    
    func translate(language: String) {
        if (language == "Nederlands") {
            languageLabel.text = "Taal wijzigen"
            self.title = "Instellingen"
        } else {
            languageLabel.text = "Change language"
            self.title = "Settings"
        }
    }
}
