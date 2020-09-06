//
//  NHLApiServices.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-01.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct NHLApiServices {
    
    //API call to get the next game for a specified teamID
    func fetchNextGame(teamID: Int64, completion: @escaping (OuterTeam_Next?, Error?) -> Void) {
        let params = ["expand":"team.schedule.next"]
        let url = "https://statsapi.web.nhl.com/api/v1/teams/" + String(teamID)
        
        var components = URLComponents(string: url)!
        components.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //Make sure there is data
            guard let data = data,
                let response = response as? HTTPURLResponse,
                //Make sure the status code is OK
                (200 ..< 300) ~= response.statusCode,
                //Make sure there is no error
                error == nil else {
                    completion(nil, error)
                    return
            }

            let responseObject = (try? JSONDecoder().decode(OuterTeam_Next.self, from: data))
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    //API call to get the previous game for a specified teamID
    func fetchPreviousGame(teamID: Int64, completion: @escaping (OuterTeam_Previous?, Error?) -> Void) {
        let params = ["expand":"team.schedule.previous"]
        let url = "https://statsapi.web.nhl.com/api/v1/teams/" + String(teamID)
        
        var components = URLComponents(string: url)!
        components.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //Make sure there is data
            guard let data = data,
                let response = response as? HTTPURLResponse,
                //Make sure the status code is OK
                (200 ..< 300) ~= response.statusCode,
                //Make sure there is no error
                error == nil else {
                    completion(nil, error)
                    return
            }

            let responseObject = (try? JSONDecoder().decode(OuterTeam_Previous.self, from: data))
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    //API call to get the linescore for a game with the given teamPD
    func fetchLineScore(teamPK: Int, completion: @escaping (LineScore?, Error?) -> Void) {
        let urlString = "https://statsapi.web.nhl.com/api/v1/game/" + String(teamPK) + "/linescore"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //Make sure there is data
            guard let data = data,
                let response = response as? HTTPURLResponse,
                //Make sure the status code is OK
                (200 ..< 300) ~= response.statusCode,
                //Make sure there is no error
                error == nil else {
                    completion(nil, error)
                    return
            }
            let responseObject = (try? JSONDecoder().decode(LineScore.self, from: data))
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    //API call to get information about the current season
    func fetchCurrentSeason(completion: @escaping (SeasonResponse?, Error?) -> Void) {
        let url = URL(string: "https://statsapi.web.nhl.com/api/v1/seasons/current")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //Make sure there is data
            guard let data = data,
                let response = response as? HTTPURLResponse,
                //Make sure the status code is OK
                (200 ..< 300) ~= response.statusCode,
                //Make sure there is no error
                error == nil else {
                    completion(nil, error)
                    return
            }
            let responseObject = (try? JSONDecoder().decode(SeasonResponse.self, from: data))
            completion(responseObject, nil)
        }
        task.resume()
    }
}
