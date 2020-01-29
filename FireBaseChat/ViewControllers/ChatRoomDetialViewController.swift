//
//  ChatRoomDetialViewController.swift
//  FireBaseChat
//
//  Created by Lambda_School_Loaner_218 on 1/28/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatRoomDetialViewController: MessagesViewController {
    
    var room: ChatRoom?
    var chatRoomController: ChatRoomController?
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.dataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        chatRoomController?.fetchRooms {
            guard let room = self.room ,let index = self.chatRoomController?.rooms.firstIndex(of: room) else { return }
            self.messages = self.chatRoomController?.rooms[index].messages ?? []
            self.messagesCollectionView.reloadData()
        }
    }
    
}


extension ChatRoomDetialViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatRoomController = chatRoomController, let room = room else { return }
        let message = Message(text: text, displayName: "User", messageId: UUID().uuidString, sentDate: Date())
        self.messages.append(message)
        chatRoomController.addMessageToRoom(room, message: message) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
            
        }
       
    }
}

extension ChatRoomDetialViewController: MessagesLayoutDelegate, MessagesDataSource, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return Sender(id: UUID().uuidString, displayName: "User")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
         let message = messages[indexPath.item]
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
}



