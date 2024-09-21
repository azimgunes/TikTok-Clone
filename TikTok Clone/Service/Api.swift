//
//  Api.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.08.2024.
//


import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct Api {
    static var Post = PostApi()
    static var User = UserApi()
}
