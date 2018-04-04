import Foundation

class StorageService {
    
    var languages = ["Nederlands", "English"]
    let defaultUserDefaultValue : [String:Any] = ["TwitterClient.language" : "English"]
    let defaultUserKey = "TwitterClient.language"
    
    init() {
        UserDefaults.standard.register(defaults: defaultUserDefaultValue)
    }
    
    func setLanguage(newLanguage: String) {
        UserDefaults().set(newLanguage, forKey: defaultUserKey)
    }
    
    func getLanguage() -> String {
        return UserDefaults.standard.string(forKey: defaultUserKey)!
    }
}
