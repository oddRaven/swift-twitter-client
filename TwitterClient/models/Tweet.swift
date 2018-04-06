import Foundation

class Tweet {
    var tweetText: String
    var tweeTcreatedAt: String
    
    init(text: String, createdAt: String) {
        self.tweetText = text
        self.tweeTcreatedAt = createdAt
    }
}
