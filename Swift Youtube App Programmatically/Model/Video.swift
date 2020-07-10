//
//  Video.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/06.
//

import UIKit

class Video: NSObject {
    
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
//    var uploadDate: NSDate?
    var duration: NSNumber?
    
    var channel: Channel?
    
    
//    var num_likes: NSNumber?
    
    //아래 코드 block은 아 ~ 그냥 이런게 있구나 정도로 보면 된다. 실제로 swift5는 NSObject보다는 Codable, Decodable, Encodable을 사용한다.
    override func setValue(_ value: Any?, forKey key: String) {
       
        //없는 key값이 있으면 진행하지 못하도록 막음.
//        let uppercasedFirstCharacter = String(key.first!).uppercased()
//        let range = key.startIndex...key.startIndex.
//        let selectorString = key.replacingOccurrences(of: <#T##StringProtocol#>, with: <#T##StringProtocol#>)
//        let selector = NSSelectorFromString("setNumber_of_likes:")
//        let responds = self.responds(to: selector)
        
//        if !responds {
//            return
//        }
        
        if key == "channel" {
            //custom channel setup
            let channelDictionary = value as! [String: AnyObject]
            self.channel = Channel()
            self.channel?.setValuesForKeys(channelDictionary)
            
        } else {
            super.setValue(value, forKey: key)
        }
        
    }
    
    override init() {
    
    }
    
    //아래 코드 block은 아 ~ 그냥 이런게 있구나 정도로 보면 된다. 실제로 swift5는 NSObject보다는 Codable, Decodable, Encodable을 사용한다.
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
}

class Channel: NSObject {
    
    var name: String?
    var profile_image_name: String?
    
}
