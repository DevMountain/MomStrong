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
        self.isCompleted = false
    }
    
    func toggleIsCompleted(){
        self.isCompleted = !self.isCompleted
        CoreDataStack.save()
    }
}
