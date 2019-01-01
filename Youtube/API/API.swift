//
//  API.swift
//  Youtube
//
//  Created by Dake Aga on 12/10/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class API: NSObject {
    static let sharedInstance = API()
    
    let baseURL = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video])->()){
        fetchVideosForURL(stringURL: "\(baseURL)/home.json", completion: completion)
    }
    
    func fetchSubscriptionVideos(completion: @escaping ([Video])->()){
        fetchVideosForURL(stringURL: "\(baseURL)/subscriptions.json", completion: completion)
    }
    
    func fetchTrendingVideos(completion: @escaping ([Video])->()){
        fetchVideosForURL(stringURL: "\(baseURL)/trending.json", completion: completion)
    }
    
    func fetchVideosForURL(stringURL: String, completion: @escaping ([Video])->()){
        let url = URL(string: stringURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                
                for dictionary in json as! [[String: AnyObject]] {
                    
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnalImage = dictionary["thumbnail_image_name"] as? String
                    video.numberOfViews = dictionary["number_of_views"] as? NSNumber
                    
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileIamge = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    
                    videos.append(video)
                }
                
                DispatchQueue.main.async {
                    completion(videos)
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
}
