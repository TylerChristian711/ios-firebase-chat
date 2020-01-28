//
//  Message.swift
//  FireBaseChat
//
//  Created by Lambda_School_Loaner_218 on 1/28/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, MessageType {
    
    var text: String
    var displayName: String
    var senderID: String { return UUID().uuidString }
    var sender: SenderType { return Sender(id: senderID, displayName: displayName)}
    var messageId: String
    var sentDate: Date
    var kind: MessageKind { return .text(text) }
    
}
