import Foundation

class StorageService {
    public static let shared = StorageService()
    
    let defaultUserLanguageDefaultValue : [String:Any] = ["TwitterClient.language" : "English"]
    let defaultUserLanguageKey = "TwitterClient.language"
    let defaultUserAccessTokenKey = "TwitterClient.accessToken"
    let defaultUserAccessTokenSecretKey = "TwitterClient.accessTokenSecret"
    
    private init() {
        UserDefaults.standard.register(defaults: defaultUserLanguageDefaultValue)
        
        if !UserDefaults.standard.contains(key: defaultUserAccessTokenKey) {
            let userDefaultEntry: [String:Any] = [defaultUserAccessTokenKey: ""]
            UserDefaults.standard.register(defaults: userDefaultEntry)
        }
        
        if !UserDefaults.standard.contains(key: defaultUserAccessTokenSecretKey) {
            let userDefaultEntry: [String:Any] = [defaultUserAccessTokenSecretKey: ""]
            UserDefaults.standard.register(defaults: userDefaultEntry)
        }
    }
    
    func setLanguage(_ newLanguage: String) {
        UserDefaults().set(newLanguage, forKey: defaultUserLanguageKey)
    }
    
    func getLanguage() -> String {
        return UserDefaults.standard.string(forKey: defaultUserLanguageKey)!
    }
    
    func setAccessToken(_ accessToken: String){
        UserDefaults().set(accessToken, forKey: defaultUserAccessTokenKey)
    }
    
    func getAccessToken() -> String {
        return UserDefaults.standard.string(forKey: defaultUserAccessTokenKey)!
    }
    
    func setAccessTokenSecret(_ accessTokenSecret: String){
        UserDefaults().set(accessTokenSecret, forKey: defaultUserAccessTokenSecretKey)
    }
    
    func getAccessTokenSecret() -> String {
        return UserDefaults.standard.string(forKey: defaultUserAccessTokenSecretKey)!
    }
}
