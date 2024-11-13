//
//  ChatMessage.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 12.11.2024.
//

import Foundation
import UIKit
import FirebaseFirestore

struct ChatMessage {
    var text: String
    var timestamp: Timestamp
    var senderId: String
    var receiverId: String
}

