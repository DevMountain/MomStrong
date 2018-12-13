//
//  WorkoutController.swift
//  MomStrong
//
//  Created by DevMountain on 11/26/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

class WorkoutController{
    
    static let shared = WorkoutController()
    
    let workouts: [Workout] = []
    let baseUrlString = "http://138.197.192.102:3691/api/routines"
    
    //Mark: - Fetch Functions
    func fetchWorkouts(type: WorkoutType, completion: @escaping (([Workout]?) -> Void)){
        guard let request = workoutUrlRequest(for: type) else { return }
        URLSession.shared.dataTask(with: request) { (data, resoponse, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }else {
                guard let data = data else {completion(nil) ; return}
                do{
                    let decoder = JSONDecoder()
                    let workoutServies = try decoder.decode([WorkoutService].self, from: data)
                    let workouts = workoutServies.compactMap{ Workout(workoutService: $0)}
                    completion(workouts)
                }catch {
                    print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func workoutUrlRequest(for type: WorkoutType) -> URLRequest?{
        guard let url = URL(string: baseUrlString) else {return nil}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "type", value: type.rawValue)]
        guard let completeURL = components?.url else { return nil }
        return URLRequest(url: completeURL)
    }
    
    func fetchVimeoData(for workout: Workout, compeltion: @escaping (Workout?) -> ()){
        VimeoClient.fetchVideoInformation(vimeoID: workout.vimeoId) { (videoInfo) in
            guard let videoInfo = videoInfo else { compeltion(nil) ; return }
            workout.setVideoProperties(videoInfo: videoInfo, completion: {
                compeltion(workout)
            })
        }
    }
    
    func fetchVideoInfo(for exercise: Exercise, completion: @escaping (Exercise?) -> ()){
        guard let vimeoId = exercise.vimeoId else { print("NO VIMEO ID ON EXERCISE : \(exercise.title) \(exercise.id)") ; completion(nil) ; return }
        VimeoClient.fetchVideoInformation(vimeoID: vimeoId) { (videoInfo) in
            var exercise = exercise
            exercise.videoUrl = videoInfo?.files[1].link
            exercise.thumbnailUrl = videoInfo?.pictures.sizes.first?.linkWithPlayButton
            completion(exercise)
        }
    }
    
    func pullVimeoIdFrom(vimeoUrl: String) -> Int?{
        let range = vimeoUrl.range(of: ".com/")
        guard let endOfBase = range?.upperBound,
            let lastPathComponentStart = vimeoUrl.lastIndex(of: "/") else { return nil }
        
        let idRange = Range<String.Index>.init(uncheckedBounds: (endOfBase, lastPathComponentStart))
        let idString  = vimeoUrl[idRange]
        return Int(idString)
    }
}
