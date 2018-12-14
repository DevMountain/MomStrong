//
//  UserService.swift
//  MomStrong
//
//  Created by DevMountain on 11/27/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

struct UserService: Codable{
    
    let id: Int
    let subscription: String
    let email: String
    let name: String
    let age: Int?
    let state: String
    let moonclerk_id: String
    let active: Bool
    let accountCreationDate: Date?
}
