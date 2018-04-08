import Foundation

class Tweet {
    var tweetId: Int
    var tweetUsername: String
    var tweetText: String
    var tweetCreatedAt: String
    
    init(id: Int, username: String, text: String, createdAt: String) {
        self.tweetId = id
        self.tweetUsername = username
        self.tweetText = text
        self.tweetCreatedAt = createdAt
    }
}
