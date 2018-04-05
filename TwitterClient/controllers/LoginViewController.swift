import UIKit

extension String{
    func matches(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
}

class LoginViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let consumerKey: String = "jmsKXfZ7qHjxsdqTRtEwLiKy2"
    let consumerSecret: String = "a56aLS53qu4G3zVrP9xBFI3rQnyy1RO8sBfdspXMm2SD71MxgT"
    let callback = "oob"
    var accessToken: String = ""
    var accessTokenSecret: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum LocalError: Error {
        case unknown
    }
    
    @IBAction func attemptSignIn(_ sender: UIButton) {
        let host = "api.twitter.com"
        let path = "oauth/request_token"
        let url: URL = URL(string: "https://\(host)/\(path)")!
        let method = "POST"
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = method
        /*guard let nonce = try? generateNonce(64) else{
            return
        }*/
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
        
        print()
        print(req.value(forHTTPHeaderField: "Authorization")!)
       
        let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            let result: String = String(data: data!, encoding: String.Encoding.utf8) as String!
            print(result)
            let matches = result.matches(regex: "(.*?)(?:=)(.*?)(?:[&|$])")
            guard matches.count >= 2 || matches[0].count == 3 || matches[1].count == 3 else {
                return
            }
            self.accessToken = matches[0][2]
            self.accessTokenSecret = matches[1][2]
            
            
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
        }
        task.resume()
        
        guard txtUsername.text! == "username" && txtPassword.text! == "password" else{
            self.showToast("login mislukt")
            return
        }
        
        performSegue(withIdentifier: "signInSuccess", sender: nil)
    }
}
