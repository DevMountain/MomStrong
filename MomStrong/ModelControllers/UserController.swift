//
//  UserController.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation
import UIKit

class UserController{
    
    var currentUser: User?
    lazy var trialUser: User = {
        return User(name: "Trial Account", state: nil, age: nil, subscription: .Both, id: 0)
    }()
    
    static let shared = UserController()
    
    let baseUrl = "http://138.197.192.102:3691"
    
    func createUser(from userService: UserService) -> User{
        let progress = ProgressController.shared.fetchProgress(for: userService.id)
        let user = User(userService: userService, progress: progress)
        return user
    }
    
    func constructRequest(url: URL, method: String, bodyJson: [String: String]) -> URLRequest{
        var request = URLRequest(url: url)
        let json = bodyJson
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = try? JSONEncoder().encode(json)
        request.httpBody = bodyData
        return request
    }
    
    func fetchCurrentUser(completion: @escaping (User?, NetworkError?) -> Void){
        
        if let userInfo = self.fetchUserDefaultData(){
            self.loginUserWith(email: userInfo.email, password: userInfo.password) { (user) in
                if let user = user{
                    self.currentUser = user
                    completion(user, nil)
                }else{
                    completion(nil, .UserNotFound)
                    print("No User Retrieved")
                }
            }
        }else{
            completion(nil, .LocalUserDataNotFound)
        }
    }
    
    func loginUserWith(email: String, password: String, completion: @escaping (User?) -> Void){
        
        guard let url = URL(string: baseUrl)?.appendingPathComponent("auth").appendingPathComponent("login") else {completion(nil) ; return}
        
        let request = self.constructRequest(url: url, method: "POST", bodyJson: [
            "email" : email,
            "password": password
        ])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil) ; return}
            let decoder = JSONDecoder()
            do{
                let userService = try decoder.decode(UserService.self, from: data)
                let user = self.createUser(from: userService)
                if let progress = ProgressController.shared.fetchProgress(for: user.id){
                    user.progress = progress
                }
                self.currentUser = user
                self.saveUserDataLocally(email: email, password: password)
//                self.addSomeProgress()
                completion(user)
            }catch {
                print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func updateUser(name: String, email: String, age: String, state: String, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: baseUrl)?.appendingPathComponent("api").appendingPathComponent("userInfo") else { completion(false) ; return }
        let json = [
            "name" : name,
            "email" : email,
            "age" : age,
            "state" : state
        ]
        let request = constructRequest(url: url, method: "PUT", bodyJson: json)
        print(request.url?.absoluteString ?? "NO String value")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            
            print(response ?? "No Response")
            completion(true)
            }.resume()
    }
    
//    func addSomeProgress(){
//        let progressPoints = [
//            WorkoutProgressPoint(dateCompleted: Date(timeIntervalSinceNow: -24*60*60 * 3), workoutId: 13, progress: UserController.shared.currentUser?.progress),
//            WorkoutProgressPoint(dateCompleted: Date(timeIntervalSinceNow: -24*60*60 * 7), workoutId: 13, progress: UserController.shared.currentUser?.progress),
//            WorkoutProgressPoint(dateCompleted: Date(timeIntervalSinceNow: -24*60*60 * 20), workoutId: 13, progress: UserController.shared.currentUser?.progress)
//            ]
//        currentUser?.progress.progressPoints = progressPoints
//    }
    
    func logoutCurrentUser(completion: @escaping (Bool) -> Void){
        
        guard let url = URL(string: self.baseUrl)?.appendingPathComponent("auth").appendingPathComponent("logout") else { completion(false) ; return }
        
        self.forgetCurrentUserLocally()
        URLSession.shared.dataTask(with: url) { (_, _, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }else {
                completion(true)
            }
        }
    }
    
    func forgetCurrentUserLocally(){
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "password")
    }
    
    func saveUserDataLocally(email: String, password: String){
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    func fetchUserDefaultData() -> (email: String, password: String)?{
        guard let email = UserDefaults.standard.string(forKey: "email"),
            let password = UserDefaults.standard.string(forKey: "password") else { return nil }
        return (email, password)
    }
    
    func sendResetPasswordRequestFor(email: String, completion: @escaping (Bool) -> ()){
        //TODO: - get reset password link from cody
        guard let url = URL(string: baseUrl)?.appendingPathComponent("api").appendingPathComponent("forgotpassword") else { completion(false) ; return }
        let request = self.constructRequest(url: url, method: "PUT", bodyJson: ["email" : email])
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            
            print(response ?? "No Response")
            completion(true)
            
            }.resume()
    }
    
    func checkForTwoWeekTrial() -> (valid: Bool, daysLeft: Int)?{
        let trialId = UIDevice.current.identifierForVendor?.uuidString
        if let date = UserDefaults.standard.value(forKey: trialId ?? "currentUser") as? Date{
            let daysExpired = Calendar.current.dateComponents([.day], from: date, to: Date()).day!
            let daysLeft = 14 - daysExpired
            return (daysLeft > 0, daysLeft)
        } else{
            return nil
        }
    }
    
    @discardableResult
    func createTwoWeekTrial() -> User{
        let trialUser = self.trialUser
        let trialId = UIDevice.current.identifierForVendor?.uuidString
        UserDefaults.standard.set(Date(), forKey: trialId ?? "currentUser")
        currentUser = trialUser
        return trialUser
    }
    
    func fetchTrialUserData(){
        self.currentUser = self.trialUser
        if let progress = ProgressController.shared.fetchProgress(for: trialUser.id){
            self.currentUser?.progress = progress
        }
    }
}

enum NetworkError{
    case UserNotFound
    case LocalUserDataNotFound
    
    
    func description() -> String{
        switch self{
        case .LocalUserDataNotFound:
            return "No Local User Data found in this phones UserDefaults"
        case .UserNotFound:
            return "No User Found in the database for this email and password"
        }
    }
    
}
