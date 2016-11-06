//
//  ViewController.swift
//  SleepRank
//
//  Created by Walter Wei on 11/5/16.
//  Copyright © 2016 SleepRank. All rights reserved.
//

import UIKit
import HealthKit
import FBSDKLoginKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let healthStore = HKHealthStore()
    var imageView:UIImageView!
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var headerView: UIView!
    var sleepers:[Sleeper]!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initiate HealthKit
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            }
        }
        
        // Get sleepers data
        getSleepers()
        
        // Initiate imageView:
        imageView = UIImageView()
        imageView.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width * 0.562)
        
        // Initiate tableView:
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        headerView = UIView(frame: frame)
        tableView.sectionHeaderHeight = imageView.frame.height
        tableView.tableHeaderView = headerView
        headerView.addSubview(imageView)
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        
    }
    
    // Functions getting Data:
    func getSleepers() {
        
        for index in 1...10 {
            sleepers[index].name = "lalalalala"
            sleepers[index].sleepingTime = Double(index)
        }
        
    }
    
    // Functions supporting tableView:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count:Int?
        
        count = 0
        
        if tableView == self.tableView {
            if sleepers != nil {
                count = sleepers.count
            }
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleeperCell", for: indexPath) as! SleeperCell
        
        cell.sleeper = sleepers[indexPath.row]
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        dismiss(animated: true, completion: {});
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

