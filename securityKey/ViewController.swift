//
//  ViewController.swift
//  securityKey
//
//  Created by praveenkumar on 18/11/19.
//  Copyright © 2019 praveenkumar. All rights reserved.
//

import UIKit
import CommonCrypto
import Security

class ViewController: UIViewController, UITextFieldDelegate {
    private let utility = Util()
    var receivedData: [String: Any]?
    
    @IBOutlet weak var email: UITextField!
    @IBAction func generateKeys(_ sender: Any) {
        guard let emailText = email.text, emailText.isValidEmail else {
           showAlert(message: "Invalid Email")
           return
        }
        
        utility.generateKeys { (status) in
            if status == errSecSuccess {
                self.sendKeyToServerAndGetData(email: emailText) { (responseModel, statusMsg) in
                    let resp = responseModel["encrypted"]
                    if  (resp != nil) {
                        self.receivedData = resp as! [String : Any]
                        self.decryptAndDisplay()
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: statusMsg)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to generate keys")
                }
            }
        }
    }
    
    func sendKeyToServerAndGetData(email txt: String, onCompletion handler: @escaping completionHandler) {
        let requestModel = RequestModel(emailId: txt, seckey: utility.fetchPublicKeyAsString()!)
        APIManager.fetchEncryptedData(url: "http://localhost:3000/appsecrets", data: requestModel, onComplete: handler)
    }
    
    func decryptAndDisplay() {
        if let privKey = utility.fetchPrivateKey(), let data = receivedData, let encrStr = data["data"] {
           // print(encrStr)
           // let array: [UInt8] = Array(encrStr.utf8)
            //print(SecKeyGetBlockSize(privKey))
            var error: Unmanaged<CFError>?
//            if let cfdata = SecKeyCopyExternalRepresentation(privKey, &error) {
//                let data:Data = cfdata as Data
//                print(data.base64EncodedString())
//            }
            
        
           // let blockSize = SecKeyGetBlockSize(utility.pubKey!)
           // var messageDecrypted = [UInt8](repeating: 0, count: blockSize)
           // var messageDecryptedSize = blockSize
           // let status = SecKeyDecrypt(privKey, SecPadding.PKCS1, array, blockSize, &messageDecrypted, &messageDecryptedSize)
            print(utility.pubKey)
            let result = SecKeyCreateEncryptedData(utility.pubKey!, SecKeyAlgorithm.rsaEncryptionPKCS1, "praveen".data(using: String.Encoding.utf8)! as CFData, &error)!
           // let i16bufptr = UnsafeBufferPointer(start: ((encrStr as! ).assumingMemoryBound(to: UInt16.self), count: (encrStr as! Array).count)
///         if let decodedData = Data(base64Encoded: encrStr, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {///         if let decodedData = Data(base64Encoded: encrStr, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
//           if let decodedData = Data(base64Encoded: encrStr, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
//                // ...
//                print("base64")
//                print(decodedData)
//            } else {
//                print("Not Base64")
//            }
//            let serverData = encrStr as! CFData
//            print(serverData)
            //  let bytes = NSKeyedArchiver.archivedData(withRootObject: encrStr)let data1 = Data(base64Encoded: data, options:.ignoreUnknownCharacters)
            
            let originalText = SecKeyCreateDecryptedData(privKey, SecKeyAlgorithm.rsaEncryptionPKCS1, data as! CFData, &error)
            if error == nil, let origText = originalText {
                let origData = origText as Data
                let backToString = String(data: origText as Data, encoding: String.Encoding.utf8) as? String
                DispatchQueue.main.async {
                    self.showAlert(title: "Received Data", message: backToString!)
                }
            } else {
                print(error!)
            }
            
        } else {
            showAlert(message: "Error in decrypting")
        }
    }
}
