//
//  ApiService.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/09.
//

import UIKit

class ApiService: NSObject {

    static let sharedInstance = ApiService()
    
    func fetchVideos(completion: @escaping([Video]) -> ()) {
        let url: URL? = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            do {
                /* Mutable Containers -> 바뀔 수 있는 데이터를 암시함. */
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                var videos = [Video]()
                //dictionary 형식으로 가져온다. 마치 SwiftyJson과 비슷함.
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImagename = channelDictionary["profile_image_name"] as? String
                    video.channel = channel
                    videos.append(video)
                }
                
                DispatchQueue.main.async {
                    completion(videos)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            

            
            //String 형식으로 서버 response 받아오는 방법
//            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(str)
        }.resume()
    }
    
}
