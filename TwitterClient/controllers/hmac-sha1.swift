import Foundation
import CommonCrypto

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let stringData = self.data(using: String.Encoding.utf8)
        let keyData = key.data(using: String.Encoding.utf8)
        
        let result = hmacGenerate(from: stringData!, withKey: keyData!, using: algorithm)
        
        /*var hash: String = ""
        for i in 0..<algorithm.digestLength {
            hash += String(format: "%02x", result[i])
        }
        
        print("signature bytes: \(hash)")*/
        
        return result.base64EncodedString()
    }
    
    private func hmacGenerate(from data: Data, withKey key: Data, using algorithm: CryptoAlgorithm) -> Data {
        // Get data pointers
        var result = Data(count: Int(algorithm.digestLength))

        data.withUnsafeBytes{(dataBytesPointer: UnsafePointer<UInt8>) -> Void in
            key.withUnsafeBytes{(keyBytesPointer: UnsafePointer<UInt8>) -> Void in
                result.withUnsafeMutableBytes{(resultBytesPointer: UnsafeMutablePointer<UInt8>) -> Void in
                    CCHmac(algorithm.HMACAlgorithm, keyBytesPointer, key.count, dataBytesPointer, data.count, resultBytesPointer)
                }
            }
        }
        
        return result
    }
}
