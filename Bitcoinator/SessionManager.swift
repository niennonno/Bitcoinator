////
////  SessionManager.swift
////  Bitcoinator
////
////  Created by Aditya Vikram Godawat on 04/07/18.
////  Copyright © 2018 Aditya Vikram Godawat. All rights reserved.
////
//
//import Foundation
//import SocketIO
//import SwiftyJSON
//
//protocol SocketConnectionHandler: class {
//    func socketDidConnect(socket: SessionManager)
//    func socketDidDisconnect(socket: SessionManager)
//}
//
//class SessionManager {
//    
//    static let shared = SessionManager()
//    fileprivate var socket: SocketIOClient?
//    weak var delegate: SocketConnectionHandler?
//
//    func connect() {
//        let manager = SocketManager(socketURL: url, config: [.log(true), .forcePolling(true)])
//        socket = manager.defaultSocket
//        
//        self.socket?.once("connect") { _,_ in
//            self.self.socketDidConnect(socket: self.socket)
//        }
//        
//        self.socket?.once("disconnect") { (_,_) in
//            self.socketDidDisconnect(socket: self.socket, error: nil)
//        }
//    }
//
//    func disconnect() {
//        socket?.disconnect()
//    }
//    
//    func socketDidConnect(socket: SocketIOClient?) {
//        
//        DispatchQueue.main.async { [weak self] in
//            guard let weakSelf = self else { return }
//            
//            weakSelf.delegate?.socketDidConnect(socket: weakSelf)
//        }
//        
//    }
//    
//    func socketDidDisconnect(socket: SocketIOClient?, error: NSError?) {
//        delegate?.socketDidDisconnect(socket: self)
//    }
//
//
//}
//
