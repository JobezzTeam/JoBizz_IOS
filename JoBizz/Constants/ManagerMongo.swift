//
//  ManagerMongo.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 11/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import Foundation
import MongoSwift
import StitchCore
import StitchRemoteMongoDBService


class ManagerMongo {
    
    static var client: StitchAppClient? = nil
    static var mongoClient: RemoteMongoClient? = nil
    static var connexionIsValid: Connexion = .Failure
    
    
    static func initMongo(block: @escaping (_ validation: Connexion) -> Void) -> Void {
        do {
            client = try Stitch.initializeDefaultAppClient(withClientAppID: "ios-app-gnwcl")
            
            mongoClient = try client!.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        } catch {
            print("Failed to initialize MongoDB Stitch iOS SDK: \(error)")
            block(.Failure)
            return
        }
        
        let credential = UserAPIKeyCredential.init(withKey: "SavGEcF7jFJ4kZ3EeUZkSCKFN57rDSJBTAUGJls27GVQpdIVX7EqrpombdBEMMPp")
        
        client!.auth.login(withCredential: credential) { [block] result in
            switch result {
            case .success( _):
                print("connexion successfull")
                connexionIsValid = .Success
                block(.Success)
            case .failure(let error):
                print("Error in login: \(error)")
                connexionIsValid = .Failure
                block(.Failure)
                
            }
        }
    }
}
