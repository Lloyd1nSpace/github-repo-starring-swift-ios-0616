//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let repoSelected: GithubRepository = self.store.repositories[indexPath.row]
        
        ReposDataStore.toggleStarStatusForRepository(repoSelected) { (starred) in
            
            let alert = UIAlertController.init(title: "", message: "", preferredStyle: .Alert)
            let dismissAlert = UIAlertAction(title: "Ok", style: .Cancel) { (cancel) in
                print("Ok tapped!")
            }
            alert.addAction(dismissAlert)
            
            if starred {
                alert.accessibilityLabel = "You just starred \(repoSelected.fullName)"
                alert.title = "starred \(repoSelected.fullName)"
            } else {
                alert.accessibilityLabel = "You just unstarred \(repoSelected.fullName)"
                alert.title = "unstarred \(repoSelected.fullName)"
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.presentViewController(alert, animated: true, completion: {
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
}
