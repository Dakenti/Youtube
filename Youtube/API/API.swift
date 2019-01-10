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
            if error != nil{
                print(error ?? "")
                return
            }
            
            do{
                guard let data = data else {return}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let videos = try decoder.decode([Video].self, from: data)
                
                DispatchQueue.main.async {
                    completion(videos)
                }
                
            } catch let err {
                print(err)
            }
        }.resume()
    }
}
