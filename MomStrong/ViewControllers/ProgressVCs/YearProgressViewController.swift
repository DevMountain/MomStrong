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

extension YearProgressViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Calendar.current.monthSymbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = yearlyProgressCollectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as? MonthCollectionViewCell
        let month = indexPath.row
        let percentageComplete = ProgressController.shared.completionRateFor(month: month)
        cell?.monthLabel.text = Calendar.current.monthSymbols[month]
        cell?.percentCompleteLabel.text = percentageComplete.asPercentString
        
        return cell ?? UICollectionViewCell()
    }
}

