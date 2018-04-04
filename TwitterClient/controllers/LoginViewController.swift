import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let consumerKey = "jmsKXfZ7qHjxsdqTRtEwLiKy2"
    let consumerSecret = "a56aLS53qu4G3zVrP9xBFI3rQnyy1RO8sBfdspXMm2SD71MxgT"
    let accessToken = "1959289086-d1Z3On8y9WF7x1bl3iNub5JtJH2nkkNdVxvsUHJ"
    let accessTokenSecret = "Oj3uCKUe7Guf5nzxeI8HYhvOAs5Q4BH6LmHp6mQzoW1iZ"
    
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
    
    func generateNonce(_ lenght: Int) throws -> String {
        let data = NSMutableData(length: lenght)
        let result = SecRandomCopyBytes(kSecRandomDefault, data!.length, data!.mutableBytes)
        if result == errSecSuccess {
            return String(describing: data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))) // String(describing: nonce! as Data)
        } else {
            throw LocalError.unknown
        }
    }
    
    @IBAction func attemptSignIn(_ sender: UIButton) {
        let urlString = "https://api.twitter.com/oauth/request_token"
        if let tokenUrl = NSURL(string: urlString) {
            let req = NSMutableURLRequest(url: tokenUrl as URL)
            req.httpMethod = "POST"
            /*guard let nonce = try? generateNonce(64) else{
                return
            }*/
            let nonce = String(UUID().uuidString.prefix(8))
            let message = consumerSecret + "&" + accessTokenSecret
            let signature: String = message.hmac(algorithm: .SHA1, key: consumerKey)
            let timestamp = String(Int64(Date().timeIntervalSince1970))
            let authorizationHeader = "OAuth oauth_nonce=\"\(nonce)\", oauth_callback=\"oob\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"\(timestamp)\", oauth_consumer_key=\"\(consumerKey)\", oauth_signature=\"\(signature)\", oauth_version=\"1.0\""
            print(authorizationHeader)
            req.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
           
            let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
                if let json = data {
                    do {
                        print(response!)
                        if let content = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject] {
                            print(content.keys)
                            /*if let accessToken = content["access_token"] as? String {
                                print(accessToken)
                            }*/
                        }
                    } catch {}
                }
            }
            task.resume()
        }
        
        guard txtUsername.text! == "username" && txtPassword.text! == "password" else{
            self.showToast("login mislukt")
            return
        }
        
        performSegue(withIdentifier: "signInSuccess", sender: nil)
    }
}
