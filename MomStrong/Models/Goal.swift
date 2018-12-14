//
//  Goal.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

extension Goal{

    convenience init(title: String){
        self.init(context: CoreDataStack.context)
        self.title = title
        self.timeStamp = Date()
        self.progress = UserController.shared.currentUser?.progress
        self.isCompleted = false
    }
    
    func toggleIsCompleted(){
        isCompleted.toggle()
        CoreDataStack.save()
    }
}
