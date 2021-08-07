//
//  Data_Base.swift
//  Chat_Up
//
//  Created by Yifan Du on 8/5/21.
//

import Foundation
import UIKit

class Model_DB : NSObject {
    var date : String?
    var user_name : String?
    var message : String?
    override init() {
        
    }
    init(date : String, user_name : String, message : String) {
        self.date = date
        self.user_name = user_name
        self.message = message
    }
    override var description: String {
        return "date \(String(describing: date)), user_name \(String(describing: user_name)), message \(String(describing: message))"
    }
}


class FeedModel : NSObject, URLSessionDataDelegate {
    weak var delegate : Model_Protocol!
    let url_path = "http://www.uccainc.com/myiosapp/chat_read_json.php"
    func downloadItems () {
        let url = URL(string: url_path)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, res, err) in
            if err != nil {
                print(err?.localizedDescription)
                return
            }else{
                print("information downloaded")
                self.parseJson(data!)
            }
        }
        task.resume()
    }
    func parseJson(_ data : Data) {
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch{
            print(error.localizedDescription)
        }
        var jsonElement = NSDictionary()
        let items = NSMutableArray()
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let item = Model_DB()
            let date_formatter = DateFormatter()
            
            if let date = jsonElement["date"] as? String,
               let user_name = jsonElement["user_name"] as? String,
               let message = jsonElement["message"] as? String{
              
                item.date = date
                item.user_name = user_name
                item.message = message
            }
            items.add(item)
        }
        DispatchQueue.main.async {
            self.delegate.didDownloaded(items: items)
            
        }
    }
    
}

class FeedModel_Update : NSObject, URLSessionDataDelegate {
    weak var delegate : Model_Protocol!
    let url_path = "http://www.uccainc.com/myiosapp/chat_read_json.php"
    func downloadItems () {
        let url = URL(string: url_path)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, res, err) in
            if err != nil {
                print(err?.localizedDescription)
                return
            }else{
                print("information downloaded")
                self.parseJson(data!)
            }
        }
        task.resume()
    }
    func parseJson(_ data : Data) {
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch{
            print(error.localizedDescription)
        }
        var jsonElement = NSDictionary()
        let items = NSMutableArray()
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let item = Model_DB()
            let date_formatter = DateFormatter()
            
            if let date = jsonElement["date"] as? String,
               let user_name = jsonElement["user_name"] as? String,
               let message = jsonElement["message"] as? String{
              
                item.date = date
                item.user_name = user_name
                item.message = message
            }
            items.add(item)
        }
        DispatchQueue.main.async {
            self.delegate.didDownloaded(items: items)
            
        }
    }
    
}



func php_request(url : String) {
    let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
    request.httpMethod = "POST"
    let post_string = "a=\(user_name)&b=\(message)"
    request.httpBody = post_string.data(using: String.Encoding.utf8)
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        (data, response, err) in
        if err != nil {
            print(err?.localizedDescription as Any)
            return
        }
      //  print("response \(String(describing: response))")
        
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
     //   print("\(responseString ?? "ok")")
    }
    task.resume()
}
