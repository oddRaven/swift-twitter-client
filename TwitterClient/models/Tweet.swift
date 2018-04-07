import Foundation

class Tweet {
    var tweetText: String
    var tweetCreatedAt: String
    
    init(text: String, createdAt: String) {
        self.tweetText = text
        self.tweetCreatedAt = createdAt
    }
}
