//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func toggleStarStatusForRepository(repository: GithubRepository,completion: (Bool) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(Secrets.clientID)/\(Secrets.secret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let githubRequest = NSMutableURLRequest(URL: unwrappedURL)
        
        let task = session.dataTaskWithRequest(githubRequest) { (data, response, error) in
            githubRequest.addValue(Secrets.token, forHTTPHeaderField: "Authorization")
            githubRequest.HTTPMethod = "PUT"
            if let data = data {githubRequest.HTTPBody = NSData(data: data)}
            let httpResponse = response as! NSHTTPURLResponse
            if httpResponse.statusCode == 204 {
                completion(true)
            } else {
               // completion(GithubAPIClient.unstarRepository())
            }
        }
        task.resume()
    }
}