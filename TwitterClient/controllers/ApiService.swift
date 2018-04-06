import Foundation
import UIKit

class ApiService{
    private let callback = "oob"
    private let consumerKey = "jmsKXfZ7qHjxsdqTRtEwLiKy2"
    private let consumerSecret = "a56aLS53qu4G3zVrP9xBFI3rQnyy1RO8sBfdspXMm2SD71MxgT"
    private let host = "api.twitter.com"
    
    private var accessToken: String = ""
    private var accessTokenSecret: String = ""
    private var oauthToken: String = ""
    private var oauthTokenSecret: String = ""
    
    public static let shared: ApiService = ApiService()
    
    private init(){
    }
    
    public func requestToken() -> Void {
        let path = "oauth/request_token"
        let url: URL = URL(string: "https://\(host)/\(path)")!
        let method = "POST"
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = method
        let nonce = String(UUID().uuidString.prefix(8))
        let signingKey = consumerSecret + "&" //+ accessTokenSecret
        let timestamp = String(Int64(Date().timeIntervalSince1970))
        
        var signatureBase: String = "oauth_callback=\(callback)&oauth_consumer_key=\(consumerKey)&oauth_nonce=\(nonce)&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\(timestamp)&oauth_version=1.0"
        
        signatureBase = signatureBase.replacingOccurrences(of: "&", with: "%26")
        signatureBase = signatureBase.replacingOccurrences(of: "=", with: "%3D")
        
        signatureBase = "\(method)&\(url)&\(signatureBase)"
        
        signatureBase = signatureBase.replacingOccurrences(of: ":", with: "%3A")
        signatureBase = signatureBase.replacingOccurrences(of: "/", with: "%2F")
        
        let signature: String = signatureBase.hmac(algorithm: .SHA1, key: signingKey).addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let authorizationHeader : String = "OAuth oauth_version=\"1.0\", oauth_nonce=\"\(nonce)\", oauth_timestamp=\"\(timestamp)\", oauth_consumer_key=\"\(consumerKey)\", oauth_callback=\"\(callback)\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"\(signature)\""
        
        req.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            let result: String = String(data: data!, encoding: String.Encoding.utf8) as String!
            let matches = result.matches(regex: "(.*?)(?:=)(.*?)(?:[&|$])")
            guard matches.count >= 2 || matches[0].count == 3 || matches[1].count == 3 else {
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
    
    //print(String(data: data!, encoding: String.Encoding.utf8) as String!)
    /*if let json = data {
     do {
     //print()
     //print(json)
     //print(response!)
     if let content = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] {
     //print()
     //print(content.keys)
     print(content["access_token"]!)
     }
     } catch {
     print("Error info: \(error)")
     }
     }*/
    
    public func getAccessToken(pinCode: String, completion: @escaping (_ success: Bool) -> Void) {
        let path = "oauth/access_token"
        let url: URL = URL(string: "https://\(host)/\(path)")!
        let method = "POST"
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = method
        let nonce = String(UUID().uuidString.prefix(8))
        let signingKey = "\(consumerSecret)&\(oauthTokenSecret)"
        let timestamp = String(Int64(Date().timeIntervalSince1970))
        
        var signatureBase: String = "oauth_callback=\(callback)&oauth_consumer_key=\(consumerKey)&oauth_nonce=\(nonce)&oauth_verifier=\"\(pinCode)\"oauth_signature_method=HMAC-SHA1&oauth_timestamp=\(timestamp)&oauth_token=\(oauthToken)&oauth_version=1.0"
        
        signatureBase = signatureBase.replacingOccurrences(of: "&", with: "%26")
        signatureBase = signatureBase.replacingOccurrences(of: "=", with: "%3D")
        
        signatureBase = "\(method)&\(url)&\(signatureBase)"
        
        signatureBase = signatureBase.replacingOccurrences(of: ":", with: "%3A")
        signatureBase = signatureBase.replacingOccurrences(of: "/", with: "%2F")
        
        let signature: String = signatureBase.hmac(algorithm: .SHA1, key: signingKey).addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let authorizationHeader : String = "OAuth oauth_version=\"1.0\", oauth_nonce=\"\(nonce)\", oauth_timestamp=\"\(timestamp)\", oauth_consumer_key=\"\(consumerKey)\", oauth_callback=\"\(callback)\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"\(signature)\", oauth_token=\"\(oauthToken)\", oauth_verifier=\"\(pinCode)\""
        
        req.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            let result: String = String(data: data!, encoding: String.Encoding.utf8) as String!
            let matches = result.matches(regex: "(.*?)(?:=)(.*?)(?:[&|$])")
            guard matches.count >= 2 && matches[0].count == 3 && matches[1].count == 3 else {
                return
            }
            self.accessToken = matches[0][2]
            self.accessTokenSecret = matches[1][2]
            
            completion(true)
        }
        task.resume()
    }
    
    public func verifyCredentials() -> Void {
        
    }
    
    public func url(method: String, path: String) -> Void{
        let url: URL = URL(string: "https://\(host)/\(path)")!
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = method
        let nonce = String(UUID().uuidString.prefix(8))
        let signingKey = "\(consumerSecret)&\(accessTokenSecret)"
        let timestamp = String(Int64(Date().timeIntervalSince1970))
        
        var signatureBase: String = "oauth_callback=\(callback)&oauth_consumer_key=\(consumerKey)&oauth_nonce=\(nonce)&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\(timestamp)&oauth_token=\(accessToken)&oauth_version=1.0"
        
        signatureBase = signatureBase.replacingOccurrences(of: "&", with: "%26")
        signatureBase = signatureBase.replacingOccurrences(of: "=", with: "%3D")
        
        signatureBase = "\(method)&\(url)&\(signatureBase)"
        
        signatureBase = signatureBase.replacingOccurrences(of: ":", with: "%3A")
        signatureBase = signatureBase.replacingOccurrences(of: "/", with: "%2F")
        
        print()
        print(signingKey)
        print()
        print(signatureBase)
        
        let signature: String = signatureBase.hmac(algorithm: .SHA1, key: signingKey).addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let authorizationHeader : String = "OAuth oauth_version=\"1.0\", oauth_nonce=\"\(nonce)\", oauth_timestamp=\"\(timestamp)\", oauth_consumer_key=\"\(consumerKey)\", oauth_callback=\"\(callback)\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"\(signature)\", oauth_token=\"\(accessToken)\""
        
        print()
        print(authorizationHeader)
        
        req.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            print()
            print(response!)
            let result: String = String(data: data!, encoding: String.Encoding.utf8) as String!
            print(result)
            print(result)
        }
        task.resume()
    }
}
