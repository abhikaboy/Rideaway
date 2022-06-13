//
//  WeatherManager.swift
//  StudentUber
//
//  Created by Chiraag Nadig on 6/12/22.
//

import Foundation

struct WeatherManager {
    let weatherURL = "http://18.189.194.54:5000/"
    
    func fetchWeather(cityName: String) {
        let urlString = weatherURL + cityName
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            task.resume()
        }
        
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
        
    }
}
