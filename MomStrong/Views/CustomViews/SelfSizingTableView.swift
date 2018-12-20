//
//  SelfSizingTableView.swift
//  MomStrong
//
//  Created by DevMountain on 11/24/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class SelfSizingTableView: UITableView {
    
    weak var parentTableView: SelfSizingTableView?
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return CGSize(width: contentSize.width, height: contentSize.height )
    }
    
    func updateContentSize(){
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
        parentTableView?.updateContentSize()
    }
}
