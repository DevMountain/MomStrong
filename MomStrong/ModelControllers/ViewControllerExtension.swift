//
//  ViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/28/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import AVKit

extension UIViewController{
    
    func presentSimpleAlert(title: String, message: String, style: UIAlertController.Style){
        let alertController = constructSimpleAlert(title: title, message: message, cancelText: "Okay", style: .alert)
        self.present(alertController, animated: true)
    }
    
    func presentAreYouSureAlert(title: String, message: String, actionHandler: @escaping () -> Void){
        
        let alertController = constructSimpleAlert(title: title, message: message, cancelText: "cancel", style: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            actionHandler()
        }
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
    
    func constructSimpleAlert(title: String, message: String, cancelText: String, style: UIAlertController.Style) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func presentMainInterface(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = MomStrongTabBarController()
    }
    
    func presentWelcomeVC(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let welcomeVC = UIStoryboard(name: "Welcome", bundle: .main).instantiateViewController(withIdentifier: "welcomeNav")
        appDelegate?.window?.rootViewController = welcomeVC
    }
    
    func presentAVPlayerVCWith(videoUrlString: String){
        guard let videoUrl = URL(string: videoUrlString) else {return}
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: videoUrl)
        self.present(controller, animated: true, completion: {
            controller.player?.play()
        })
    }
    
    func presentAVPlayerVC(with player: AVPlayer){
        let controller = AVPlayerViewController()
        controller.player = player
        self.present(controller, animated: true, completion: {
            controller.player?.play()
        })
    }
    
    func setNavHeaderView(){
        self.navigationController?.navigationBar.tintColor = .powerMomRed
        let headerImageView = UIImageView(image: #imageLiteral(resourceName: "momstrongmove"))
        headerImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = headerImageView
    }
    
    func setUpRootViewNavBar(){
        setNavHeaderView()
        let rightImage = #imageLiteral(resourceName: "MegsMessageIcon").withRenderingMode(.alwaysOriginal)
        let leftImage = #imageLiteral(resourceName: "Group 15").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(pushMegsMessage))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(pushInfoStack))
    }
    
    @objc func pushMegsMessage(){
        guard let megsMessageVC = UIStoryboard(name: "MegsMessage", bundle: .main).instantiateInitialViewController() else {return}
        self.navigationController?.pushViewController(megsMessageVC, animated: true)
    }
    
    @objc func pushInfoStack(){
        guard let infoNav = UIStoryboard(name: "Info", bundle: .main).instantiateInitialViewController() else { return }
        self.present(infoNav, animated: true, completion: nil)
    }
    
    func customizeBackButton(){
        let backImage = #imageLiteral(resourceName: "BackButton").withRenderingMode(.alwaysOriginal)
        let backItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(popViewController))
        backItem.title = ""
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //    func presentMomStrongModalAlert(title: String, messageOne: String, messageTwo: String = "") -> MomStrongModalMessageView{
    //        let vc = UIStoryboard(name: "ModalPresentations", bundle: nil).instantiateInitialViewController()
    //        let popUpViewController = vc as?
    //    }
    
    func presentMomStrongModalVC(title: String, messageOne: String, messageTwo: String?){
        let vc = UIStoryboard(name: "ModalPresentations", bundle: nil).instantiateInitialViewController()
        guard let popUpVC = vc as? ModalPopUpViewController else { return }
        popUpVC.popUptitle = title
        popUpVC.messageOne = messageOne
        
        if let messageTwo = messageTwo{
            popUpVC.messageTwo = messageTwo
        }else {
            popUpVC.messageTwoLabel.isHidden = true
        }
        
        self.definesPresentationContext = true
        popUpVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true)
    }
    
}

extension UIView{
    
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .white)
        activityIndicator.startAnimating()
        activityIndicator.center = onView.center
        
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
}
