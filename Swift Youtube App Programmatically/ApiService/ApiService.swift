//
//  ApiService.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/09.
//

import UIKit

class ApiService: NSObject {

    static let sharedInstance = ApiService()
    
    let baseURL = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseURL)/home.json", completion: completion)
    }
    
    func fetchTrendingVideo(completion: @escaping([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseURL)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseURL)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping([Video]) -> ()) {
        let url: URL? = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            print("requesting data to url: \(url!)")
            if error != nil {
                print(error!.localizedDescription)
                return
            }
                        
            do {
             
                if let unwrappedData = data {
                    /* Mutable Containers -> 바뀔 수 있는 데이터를 암시함. */
                    if let jsonDictoinaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: Any]] {
                        var videos = [Video]()
                        //dictionary 형식으로 가져온다. 마치 SwiftyJson과 비슷함.
                        for dictionary in jsonDictoinaries {
                            let video = Video()
                            video.title = dictionary["title"] as? String
                            video.thumbnail_image_name = dictionary["thumbnail_image_name"] as? String
                            video.number_of_views = dictionary["number_of_views"] as? NSNumber

                            /* Use set values, model을 통해서 자동으로 mapping 시켜준다. */
        //                    video.setValuesForKeys(dictionary)
                            
                            print("dictionary: \(dictionary)")

                            let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                            let channel = Channel()
        //                    channel.setValuesForKeys(channelDictionary)
                            channel.name = channelDictionary["name"] as? String
                            channel.profile_image_name = channelDictionary["profile_image_name"] as? String
                            video.channel = channel
                            videos.append(video)
                        }
                        DispatchQueue.main.async {
                            completion(videos)
                        }
                    }
                }
                

            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
}

