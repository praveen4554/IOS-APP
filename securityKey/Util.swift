//
//  Util.swift
//  securityKey
//
//  Created by praveenkumar on 26/11/19.
//  Copyright © 2019 praveenkumar. All rights reserved.
//

import Foundation

class Util {
    let appTag = "com.test.securitykey"
    var pubKey: SecKey?
    var privKey: SecKey?
    func generateKeys(onCompletion: @escaping(OSStatus) -> Void) {
//        if fetchPrivateKey() != nil {
//            onCompletion(errSecSuccess)
//            return
//        }
        
        let privateKeyParams = [
            kSecAttrIsPermanent as String: false as AnyObject,
            kSecAttrApplicationTag as String: appTag as AnyObject
        ]
        
        // public key parameters
        let publicKeyParams = [
            kSecAttrIsPermanent as String: false as AnyObject,
            kSecAttrApplicationTag as String: appTag as AnyObject
        ]
        
        // global parameters for our key generation
        let parameters = [
            kSecAttrKeyType as String:          kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String:    512 as AnyObject,
            kSecPublicKeyAttrs as String:       publicKeyParams as AnyObject,
            kSecPrivateKeyAttrs as String:      privateKeyParams as AnyObject,
        ]
        
       // var privKey: SecKey?
        
        let status = SecKeyGeneratePair(parameters as CFDictionary, &pubKey, &privKey);
        if status == errSecSuccess, let pKey = privKey {
            let status = storeInKeyChain(privKey: pKey)
            onCompletion(status)
        }
    }
    
    func storeInKeyChain(privKey: SecKey) -> OSStatus {
        let key =  privKey;
        let tag = appTag.data(using: .utf8)!
        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecValueRef as String: key]
        
        return SecItemAdd(addquery as CFDictionary, nil)
    }
    
    func fetchPrivateKey() -> SecKey? {
        let tag = appTag.data(using: .utf8)!
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                       kSecReturnRef as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        if status == errSecSuccess {
            return (item as! SecKey)
        }
        
        return nil
    }
    
    func fetchPublicKeyAsString() -> String? {
        let string = "praveen"
        let data = string.data(using: String.Encoding.utf8)! as CFData
        var error: Unmanaged<CFError>?
        if let pKey = pubKey {
            var error: Unmanaged<CFError>?
            if let cfdata = SecKeyCopyExternalRepresentation(pKey, &error) {
               let data:Data = cfdata as Data
               return data.base64EncodedString()
            }
        }
        
        return nil
    }
    
}
