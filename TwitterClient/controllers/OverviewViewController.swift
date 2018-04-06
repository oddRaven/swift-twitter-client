import Foundation
import UIKit

class OverViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiService.shared.url(method: "GET", path: "1.1/statuses/home_timeline.json")
    }
}
