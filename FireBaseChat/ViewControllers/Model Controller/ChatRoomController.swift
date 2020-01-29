//
//  ChatRoomController.swift
//  FireBaseChat
//
//  Created by Lambda_School_Loaner_218 on 1/28/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//
import CodableFirebase
import Firebase
import Foundation
import MessageKit

class ChatRoomController {
    
    var rooms = [ChatRoom]()
    // this let below gives us the root
    let chatRoomRef = Database.database().reference().child("chatRooms")
    
    
    func fetchRooms(completion: @escaping () -> Void) {
        chatRoomRef.observe(.value) { (snapshot) in
          let decoder = FirebaseDecoder()
            let rooms = try! decoder.decode(Rooms.self, from: snapshot.value)
            self.rooms = rooms.rooms
            completion()
        }
    }
    
    func addRoom(with name: String, completion: @escaping () -> Void) {
        let room = ChatRoom(id: UUID().uuidString, messages: [], name: name)
        self.rooms.append(room)
        
        updateDataBase()
        completion()
    }
    
    func deleteRoom(_ room: ChatRoom, completion: @escaping () -> Void) {
        guard let index = rooms.firstIndex(of: room) else { return }
        rooms.remove(at: index)
        
        
        updateDataBase()
        completion()
    }
    
    func addMessageToRoom(_ room: ChatRoom,message: Message, completion: @escaping () -> Void) {
        
        guard let index = rooms.firstIndex(of: room) else { return }
        
        
        var messageArray = [Message]()
        
        if let messages = self.rooms[index].messages {
            messageArray = messages
            messageArray.append(message)
        } else {
            messageArray = [message]
        }
        
        rooms[index].messages = messageArray
        
        
        
        updateDataBase()
        completion()
    }
    
    private func updateDataBase() {
        
        let rooms = Rooms(rooms: self.rooms)
        let encoder = FirebaseEncoder()
        let roomsData = try? encoder.encode(rooms)
        chatRoomRef.setValue(roomsData)
        
    }
}
