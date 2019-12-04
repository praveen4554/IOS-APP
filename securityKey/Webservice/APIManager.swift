//
//  APIManager.swift
//  securityKey
//
//  Created by praveenkumar on 26/11/19.
//  Copyright © 2019 praveenkumar. All rights reserved.
//

import Foundation
import Alamofire

typealias completionHandler = (_ received: [String:Any], _ status: String) -> Void
class APIManager {
    static func fetchEncryptedData(url: String, data: RequestModel, onComplete: @escaping completionHandler)  {
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(data)
        guard let urlToHit = URL(string: url) else {
            onComplete([:], "Improper URL")
            return
        }
        var request = URLRequest(url: urlToHit)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseData { (receivedData) in
            switch receivedData.result {
            case .success:
                do {
                    //Use Swift4 Codable to decode JSON object into model
                    if let data = receivedData.data {
                        let jsonDecoder = JSONDecoder()
                        let json = try JSONSerialization.jsonObject(with: data)
                        if let jsonArray = json as? [[String:Any]] {
                            print("json is array", jsonArray)
                        } else if let jsonDictionary = json as? [String:Any] {
                            print("json is dictionary", jsonDictionary)
                            onComplete(jsonDictionary, "Successfully downloaded the data")
                        } else {
                            print("This should never be displayed")
                        };
                        //let response = try jsonDecoder.decode(ResponseModel.self, from: data)
                    } else {
                        print("Failed to receive data")
                        onComplete([:], "Failed to receive data")
                    }
                } catch {
                    print("Failed to decode to json: \(error.localizedDescription)")
                    onComplete([:], error.localizedDescription)
                }
            case .failure(let error):
                print("Error: " + error.localizedDescription)
                onComplete([:], error.localizedDescription)
            }
        }
    }
}
