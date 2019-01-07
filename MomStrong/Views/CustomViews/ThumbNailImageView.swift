//
//  ThumbNailImageView.swift
//  MomStrong
//
//  Created by DevMountain on 1/6/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class ThumbNailImageView: UIImageView {

    var urlString: String?{
        didSet{
            print(urlString)
            loadAndDisplayImage()
        }
    }
    
    var url: URL?{
        guard let urlString = urlString else { hide() ; return nil}
        return URL(string: urlString)
    }

    func loadAndDisplayImage(){
        guard let url = url else { hide() ; return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                self.hide()
                return
            }
            DispatchQueue.main.async {
                guard let data = data, let image = UIImage(data: data) else { self.hide() ; return }
                self.image = image
                self.isHidden = false
            }
            }.resume()
    }
    
    private func hide(){
        isHidden = true
    }
}
