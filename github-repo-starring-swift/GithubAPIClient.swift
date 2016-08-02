//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.secret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)user/starred/\(fullName)?access_token=\(Secrets.token)"
        print(urlString)
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let githubRequest = NSMutableURLRequest(URL: unwrappedURL)
        
        let task = session.dataTaskWithRequest(githubRequest) { (data, response, error) in
            githubRequest.HTTPMethod = "GET"
          //  if let data = data {githubRequest.HTTPBody = NSData(data: data)}
            let httpResponse = response as! NSHTTPURLResponse
            if httpResponse.statusCode == 204 {
                print("Checking...Repo is starred!")
                completion(true)
            } else  {
                print("Checking...Repo is not starred!")
                completion(false)
            }
        }
        task.resume()
    }
    
    class func starRepository(fullName: String, completion: () -> ()) {
        let urlString = "\(Secrets.githubAPIURL)user/starred/\(fullName)?access_token=\(Secrets.token)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let githubRequest = NSMutableURLRequest(URL: unwrappedURL)
        githubRequest.HTTPMethod = "PUT"
        let task = session.dataTaskWithRequest(githubRequest) { (data, response, error) in
            
            if let data = data {githubRequest.HTTPBody = NSData(data: data)}
            guard let httpResponse = response as? NSHTTPURLResponse else {fatalError("Couldn't get response for starRepository!!!!")}
                print("Repository Starred: Status code \(httpResponse.statusCode)")
                completion()
        }
        task.resume()
    }
    
    class func unstarRepository(fullName: String, completion: () -> ()) {
        let urlString = "\(Secrets.githubAPIURL)user/starred/\(fullName)?access_token=\(Secrets.token)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let githubRequest = NSMutableURLRequest(URL: unwrappedURL)
        githubRequest.HTTPMethod = "DELETE"
        let task = session.dataTaskWithRequest(githubRequest) { (data, response, error) in
            
           // if let data = data {githubRequest.HTTPBody = NSData(data: data)}
            guard let httpResponse = response as? NSHTTPURLResponse else {fatalError("Couldn't get response for unstarRepository!!!!")}
                print("Repository Unstarred: Status code \(httpResponse.statusCode)")
                completion()
        }
        task.resume()
    }
}