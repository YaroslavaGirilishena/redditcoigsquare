//
//  RedditAPI.swift
//  RedditConisquare
//
//  Created by Yaroslava Girilishena on 2018-02-03.
//  Copyright © 2018 YG. All rights reserved.
//

import Foundation
import Alamofire

class RedditAPI {
    
    //-----------------
    // MARK: - Constants
    //-----------------
    
    struct Constants {
        static let url: String = "https://www.reddit.com/.json"
    }
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    public static let shared = RedditAPI()
    
    //-----------------
    // MARK: - Methods
    //-----------------
    
    func fetchRedditData(_ success: @escaping ([[String: Any]]) -> (), _ failure: @escaping () -> ()) {
        Alamofire.request(Constants.url).responseJSON { response in
            if let json = response.result.value as? [String: Any], let data = json["data"] as? [String: Any], let posts = data["children"] as? [[String: Any]] {
                success(posts)
            } else {
                failure()
            }
        }
    }
    
}
