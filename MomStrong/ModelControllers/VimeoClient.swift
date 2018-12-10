//
//  VimeoClient.swift
//  MomStrong
//
//  Created by DevMountain on 12/3/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class VimeoClient{
    
    static let baseUrl = "https://api.vimeo.com/videos"
    
    static func vimeoRequest(from url: URL, fields: [String]) -> URLRequest?{
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "fields", value: fields.joined(separator: ","))]
        guard let queryUrl = components?.url else {return nil}
        var request = URLRequest(url: queryUrl)
        request.addValue("Bearer ffe267747aa51d25cfa32eb972ee8927", forHTTPHeaderField: "Authorization")
        print(request.url ?? "No Url from response")
        return request
    }
    
    static func fetchVideoInformation(vimeoID: Int, completion: @escaping (VimeoInfoObject?) -> ()){
        guard let url = URL(string: baseUrl)?.appendingPathComponent("\(vimeoID)"),
            let request = vimeoRequest(from: url, fields: ["name","description","pictures", "files", "duration"]) else { completion(nil) ; return }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            
            guard let data = data else {completion(nil) ; return}
            
            do{
                let decoder = JSONDecoder()
                let videoInfo = try decoder.decode(VimeoInfoObject.self, from: data)
                completion(videoInfo)
            }catch {
                print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
                completion(nil)
            }
            }.resume()
    }
    
    static func fetchThumbnail(url: String, completion: @escaping (UIImage?) -> ()){
        guard let url = URL(string: url) else { completion(nil) ; return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            
            guard let data = data else {completion(nil) ; return}
            let image = UIImage(data: data)
            completion(image)
            }.resume()
    }
}
