//
//  SocketIOController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 06/07/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOController{

    private var manager:SocketManager!
    private var socket:SocketIOClient?
    
    
    public static let shard:SocketIOController = {
       return SocketIOController()
    }()
    
    private init(){}
    
    
    func connect(){
        manager = SocketManager(socketURL: URL(string:"https://node.almnabr.com/")!)
        let token =  "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        self.manager.config = SocketIOClientConfiguration(
            arrayLiteral: .connectParams(["Authorization": "test"]),.secure(false) )
        
        let dict =  [ "token" : token]
        manager.defaultSocket.connect(withPayload: dict)
        
        socket = self.manager.defaultSocket
        
        self.manager.connectSocket(socket!, withPayload:dict)
        
        socket!.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
    }
    
    func taskHandler(ticketId:String,userID:String,callback:@escaping (_ data:[Any])->Void){
        socket?.on("ticket_\(ticketId)_tasks_\(userID)") {data, ack in
            callback(data)
        }
    }
    
    func isConnected()->Bool{
        print("socket connected",socket?.status.active ?? false)
        return socket?.status.active ?? false
    }
    
    func disconnect(){
        if let socket = socket {
            socket.disconnect()
        }
    }
    
    
}
