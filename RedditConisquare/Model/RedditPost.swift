//
//  RedditPost.swift
//  RedditConisquare
//
//  Created by Yaroslava Girilishena on 2018-02-03.
//  Copyright © 2018 YG. All rights reserved.
//

import Foundation

public struct RedditPost {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    var postTitle: String?
    
    //-----------------
    // MARK: - Initializer
    //-----------------
    
    public init (_ json: [String: Any]) {
        if let data = json["data"] as? [String: Any], let title = data["title"] as? String {
            self.postTitle = title
        }
    }
}
