//
//  Post.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 23.09.2024.
//

import Foundation

class Post {
    var uid: String?
    var postId: String?
    var videoUrl: String?
    var imageUrl: String?
    var description: String?
    var creationDate: Date?
    var likes :Int?
    var views: Int?
    var commentCount: Int?
    
    static func transformPostVideo(dict: Dictionary<String, Any>, key: String) -> Post {
        let post = Post()
        post.postId = key
        post.uid = dict["uid"] as? String
        post.imageUrl = dict["imageUrl"] as? String
        post.videoUrl = dict["videoUrl"] as? String
        post.description = dict["description"] as? String
        post.likes = dict["likes"] as? Int
        post.views = dict["views"] as? Int
        post.commentCount = dict["commentCount"] as? Int
        
        let creationDouble = dict["creationDate"] as? Double ?? 0
        post.creationDate = Date(timeIntervalSince1970: creationDouble)
        
        return post
    }
}
