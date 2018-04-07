import Foundation
import UIKit

class ApiService{
    private let callback = "oob"
    private let consumerKey = "jmsKXfZ7qHjxsdqTRtEwLiKy2"
    private let consumerSecret = "a56aLS53qu4G3zVrP9xBFI3rQnyy1RO8sBfdspXMm2SD71MxgT"
    private let host = "api.twitter.com"
    private let oauthVersion = "1.0"
    private let oauthSignatureMethod = "HMAC-SHA1"
    
    private var accessToken: String = ""
    private var accessTokenSecret: String = ""
    private var oauthToken: String = ""
    private var oauthTokenSecret: String = ""
    
    public static let shared = ApiService()
    
    private init(){
        initAccessTokens()
    }
    
    private func initAccessTokens(){
        accessToken = StorageService.shared.getAccessToken()
        accessTokenSecret = StorageService.shared.getAccessTokenSecret()
    }
    
    private func safeAccessTokens(){
        StorageService.shared.setAccessToken(accessToken)
        StorageService.shared.setAccessTokenSecret(accessTokenSecret)
    }
    
    private func getDefaultParameters() -> [String:String]{
        var parameters: [String:String] = [:]
        parameters["oauth_callback"] = callback
        parameters["oauth_consumer_key"] = consumerKey
        parameters["oauth_nonce"] = String(UUID().uuidString.prefix(8))
        parameters["oauth_signature_method"] = oauthSignatureMethod
        parameters["oauth_timestamp"] = String(Int64(Date().timeIntervalSince1970))
        parameters["oauth_version"] = oauthVersion
        return parameters
    }
    
    private func getSignature(method: String, url: URL, parameters: [String:String]) -> String{
        let signingKey = consumerSecret + "&" + accessTokenSecret
        
        let sortedParameters = parameters.sorted { (aDic, bDic) -> Bool in
            return aDic.key < bDic.key
        }
       
        var signatureBase: String = ""
        var nr: Int = 0
        for (key, value) in sortedParameters {
            nr += 1
            signatureBase += "\(key)%3D\(value)" + (nr != sortedParameters.count ? "%26" : "") // '&'' = %26, '=' = %3D
        }
        
        signatureBase = "\(method)&\(url)&\(signatureBase)"
        signatureBase = signatureBase.replacingOccurrences(of: ":", with: "%3A")
        signatureBase = signatureBase.replacingOccurrences(of: "/", with: "%2F")
        
        let signature: String = signatureBase.hmac(algorithm: .SHA1, key: signingKey).addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        return signature
    }
    
    private func getAuthorizationHeader(parameters: [String:String]) -> String{
        var authorizationHeader: String = "OAuth "
        let sortedParameters = parameters.sorted { (aDic, bDic) -> Bool in
            return aDic.key < bDic.key
        }
        var nr: Int = 0
        for(key, value) in sortedParameters{
            nr += 1
            authorizationHeader += "\(key)=\"\(value)\"" + (nr != sortedParameters.count ? ", " : "")
        }
        
        return authorizationHeader
    }
    
    public func requestToken() -> Void {
        let path = "oauth/request_token"
        let url = URL(string: "https://\(host)/\(path)")!
        let method = "POST"
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = method
        
        var parameters: [String:String] = getDefaultParameters()
        parameters["oauth_signature"] = self.getSignature(method: method, url: url, parameters: parameters)
        
        let authorizationHeader: String = self.getAuthorizationHeader(parameters: parameters)
        req.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            let result: String = (String(data: data!, encoding: String.Encoding.utf8) as String?)!
            let matches = result.matches(regex: "(.*?)(?:=)(.*?)(?:[&|$])")
            guard matches.count >= 2 && matches[0].count == 3 && matches[1].count == 3 else {
                print(response!)
                return
            }
            self.oauthToken = matches[0][2]
            self.oauthTokenSecret = matches[1][2]
            
            self.authorize()
        }
        task.resume()
    }
    
    public func authorize() -> Void {
        let path = "oauth/authorize?oauth_token=\(oauthToken)"
        let url: URL = URL(string: "https://\(host)/\(path)")!
        let method = "GET"
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = method
        
        DispatchQueue.main.async {
            UIApplication.shared.open(url, completionHandler: { (success) -> Void in
                print("authorization was successful: \(success)")
            })
        }
    }
    
    public func getAccessToken(pinCode: String, completion: @escaping (_ success: Bool) -> Void) {
        let path = "oauth/access_token"
        let url: URL = URL(string: "https://\(host)/\(path)")!
        let method = "POST"
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = method

        var parameters: [String:String] = getDefaultParameters()
        parameters["oauth_token"] = oauthToken
        parameters["oauth_verifier"] = pinCode
        parameters["oauth_signature"] = getSignature(method: method, url: url, parameters: parameters)
        
        let authorizationHeader: String = getAuthorizationHeader(parameters: parameters)
        req.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            let result: String = (String(data: data!, encoding: String.Encoding.utf8) as String?)!
            let matches = result.matches(regex: "(.*?)(?:=)(.*?)(?:[&|$])")
            guard matches.count >= 2 && matches[0].count == 3 && matches[1].count == 3 else {
                return
            }
            self.accessToken = matches[0][2]
            self.accessTokenSecret = matches[1][2]
            
            self.safeAccessTokens()
            
            completion(true)
        }
        task.resume()
    }
    
    public func url(method: String, path: String, completion: @escaping (_ status: Int, _ jsonObject: Any) -> Void) -> Void{
        let url: URL = URL(string: "https://\(host)/\(path)")!
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = method
        
        var parameters: [String:String] = getDefaultParameters()
        parameters["oauth_token"] = accessToken
        parameters["oauth_signature"] = self.getSignature(method: method, url: url, parameters: parameters)
        
        let authorizationHeader: String = self.getAuthorizationHeader(parameters: parameters)
        req.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            let status: Int = (response as! HTTPURLResponse).statusCode
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let jsonObject = json as? [String: Any] {
                    // json is a dictionary
                    completion(status, jsonObject)
                } else if let jsonObject = json as? [Any] {
                    // json is an array
                    completion(status, jsonObject)
                } else {
                    print("JSON is invalid")
                    completion(status, [:])
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    public func get(path: String, completion: @escaping (_ status: Int, _ jsonObject: Any) -> Void) -> Void{
        self.url(method: "GET", path: path, completion: completion)
    }
    
    public func post(path: String, completion: @escaping (_ status: Int, _ jsonObject: Any) -> Void) -> Void{
        self.url(method: "POST", path: path, completion: completion)
    }
}
