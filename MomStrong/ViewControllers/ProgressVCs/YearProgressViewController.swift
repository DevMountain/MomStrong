//
//  YearProgressViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class YearProgressViewController: UIViewController {
    
    @IBOutlet weak var yearlyProgressCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearlyProgressCollectionView.dataSource = self
        yearlyProgressCollectionView.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension YearProgressViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Calendar.current.monthSymbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = yearlyProgressCollectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as? MonthCollectionViewCell
        let month = indexPath.row
        let percentageComplete = ProgressController.shared.completionRateFor(month: month + 1)
        cell?.monthLabel.text = Calendar.current.monthSymbols[month]
        cell?.percentCompleteLabel.text = percentageComplete.asPercentString
        cell?.addShadow()
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.size.width
        let spacing = CGFloat(8*5)
        let cellWidth = (collectionViewWidth - spacing)/4
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

