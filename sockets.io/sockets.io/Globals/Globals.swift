//
//  Globals.swift
//  sockets.io
//
//  Created by Muhand Jumah on 3/1/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import Foundation
import SocketIO

////////////////////////////////
//Structures
////////////////////////////////
struct TableViewCellIDS {
    static let TextMessage = "TextMessageID"
    static let ImageMessage = "ImageMessageID"
    static let RoomName = "RoomNameID"
}

////////////////////////////////
//Models
////////////////////////////////
class TextMessage {
    var senderName: String
    var isMe: Bool
    
    init(senderName: String, isMe: Bool){
        self.senderName = senderName
        self.isMe = isMe
    }
}

class StringTextMessage : TextMessage{
    var message: String
    
    init(message: String, senderName: String, isMe: Bool){
        self.message = message
        
        super.init(senderName: senderName, isMe: isMe)
    }
}

class ImageTextMessage : TextMessage{
    var image: UIImage
    
    init(image: UIImage, senderName: String, isMe: Bool){
        self.image = image
        
        super.init(senderName: senderName, isMe: isMe)
    }
}

class Room: NSObject {
    var roomID: String
    var roomName: String
    var roomMembers: [String]
    
    init(roomID: String, roomName: String, roomMembers: [String]) {
        self.roomID = roomID
        self.roomName = roomName
        self.roomMembers = roomMembers
    }
    
    override var description: String {
        return("ROOM ID:\(roomID)\nROOM NAME:\(roomName)\nROOM MEMBERS\(roomMembers)")
    }
}

///////////////////////////////
//Global variables
////////////////////////////////
var manager: SocketManager!
var socket: SocketIOClient!
var currentUserName: String!
