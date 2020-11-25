//
//  ViewController.swift
//  Test
//
//  Created by Андрей Пептюк on 23.11.2020.
//  Copyright © 2020 Андрей Пептюк. All rights reserved.
//

import UIKit
import CommonCrypto
import Foundation

import SwCrypt

extension String {
    func md5Hex() -> String {
        let data = Data(self.utf8) as NSData
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(data.bytes, CC_LONG(data.length), &hash)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func md5() -> [UInt8] {
        let data = Data(self.utf8) as NSData
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(data.bytes, CC_LONG(data.length), &hash)
        return hash
    }
    
    

}


extension StringProtocol {
    var data: Data { .init(utf8) }
    var bytes: [UInt8] { .init(utf8) }
}


extension SecKey {
  func asBase64() throws -> String {
    var dataPtr: CFTypeRef?
    let query: [String:Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrApplicationTag as String: "...", // Same unique tag here
      kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
      kSecReturnData as String: kCFBooleanTrue
    ]
    let result = SecItemCopyMatching(query as CFDictionary, &dataPtr)

    switch (result, dataPtr) {
    case (errSecSuccess, .some(let data)):

      // convert to X509 encoded key
        let convertedData = RSAKeyEncoding().convertToX509EncodedKey(data as! Data)

      // convert to Base64 string
      let base64PublicKey = convertedData.base64EncodedString(options: [])
      return base64PublicKey
    default:
      return ""
    }
  }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("publicKeyBase64: \(publicKey.base64EncodedString())")
//        let parivateKeyBase64 = privateKey.base64EncodedString()
        
        
        
        let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(1024)
        let x509EncodedKeyData = RSAPublicKeyExporter().toSubjectPublicKeyInfo(publicKey)
        
        let x509PublicKeyStr = x509EncodedKeyData.base64EncodedString()
        
         let testMessage = "test".data(using: .utf8)!
        
        print("publicKeyBase64: \(x509PublicKeyStr)")
        let sign = try? CC.RSA.sign(testMessage, derKey: privateKey, padding: .pkcs15,
        digest: .sha1, saltLen: 0)
        printAsHexString(x509EncodedKeyData);
        
       
        
        
    
        let sign = try? CC.RSA.sign(testMessage, derKey: privateKey, padding: .pkcs15,
        digest: .sha1, saltLen: 0)
        print("sign \(String(describing: sign.base64EncodedString()))");
        let verified = try? CC.RSA.verify(testMessage, derKey: publicKey, padding: .pkcs15,
        digest: .sha256, saltLen: 0, signedData: sign!)
        
        
        print("verified \(String(describing: verified))");
        
        
        //To get public key.
//        let myPublicKey = RSAKeyManager.shared.getMyPublicKey()
//        //To get public key string that can share with others.
//        let myPublicKeyString = RSAKeyManager.shared.getMyPublicKeyString()
//
//        CC.RSA.sign(<#T##message: Data##Data#>, derKey: <#T##Data#>, padding: <#T##CC.RSA.AsymmetricSAPadding#>, digest: <#T##CC.DigestAlgorithm#>, saltLen: <#T##Int#>)
//        //To get PublicKey from string that shared by others
////        let otherPublicKeyString: String
////        let otherPublicKey = RSAKeyManager.shared.getMyPublicKeyString(pemEncoded: otherPublicKeyString)
//        //Encrypt Message (Using other's public key)
//
        
//        let privateKeyStr = try? RSAKeyManager.shared.getMyPrivateKey()?.pemString()
//
//        let privateKey = RSAKeyManager.shared.getMyPrivateKey()
//
//
//        print("messageData: \(messageData)");
    }
    private func printAsHexString(_ data: Data) {
       print(data.map{ String(format: "%02x ", $0) }.joined())
     }
}

