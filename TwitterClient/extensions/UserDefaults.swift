import Foundation

extension UserDefaults {
    func contains(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
