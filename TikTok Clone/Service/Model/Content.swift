//
//  Content.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 21.09.2024.
//

import Foundation

class Content {
    var uid: String?
    var postId: String?
    var imageUrl: String?
    var videoUrl: String?
    var description: String?
    var creationDate: Date?
    var likes: Int?
    var views: Int?
    var commentCount: Int?
    
    
    static func transformPostVideo(dict: Dictionary <String, Any>, key: String) -> Content {
        let content = Content()
        content.postId = key
        
        content.uid = dict["uid"] as? String
        content.imageUrl = dict["imageUrl"] as? String
        content.videoUrl = dict["videoUrl"] as? String
        content.description = dict["description"] as? String
        content.likes = dict["likes"] as? Int
        content.views = dict["views"] as? Int
        content.commentCount = dict["commentCount"] as? Int
        
        let creationDouble = dict["creationDate"] as? Double ?? 0
        
        content.creationDate = Date(timeIntervalSince1970: creationDouble)
        return content



        
    }
    
}
