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
import FBSDKCoreKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let healthStore = HKHealthStore()
    var window = UIWindow()
    var imageView:UIImageView!
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var headerView: UIView!
    var sleepers:[Sleeper]!
    var user:Sleeper!
    var sleepTime:Double!

    @IBOutlet weak var tableView: UITableView!
    @IBAction func logout(_ sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        performSegue(withIdentifier: "logout", sender: sender)
    }
    
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
        sleepers = []
        getUserInfo()
        retrieveSleepAnalysis()
        
        // Initiate imageView:
        imageView = UIImageView()
        imageView.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width)
        
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
    
    // Functions getting user info:
    func getUserInfo()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, picture, friends"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("Result: \(result)")
                let userInfo:NSDictionary = result as! NSDictionary
                let userID = userInfo["id"] as! String
                let userName = userInfo["name"] as! String
                let userImageUrl = userInfo["picture"]["data"]["url"] as? URL
                self.user.id = userID
                self.user.name = userName
                self.user.profileImageUrl = userImageUrl
            }
        })
        
        let graphRequest2 : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "cover", parameters: nil)
        graphRequest2.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil){
                print("Error: \(error)")
            } else {
                print("Result 2: \(result)")
            }
        })

    }
    
    // Functions getting health data:
    func retrieveSleepAnalysis() {
        
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 5, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    print("Error: \(error)")
                    return
                }
                
                if let result = tmpResult {
                    
                    // do something with my data
                    for item in result{
                        if let sample = item as? HKCategorySample {
                            if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue{
                                print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(sample.value)")
                                self.sleepTime = sample.endDate.timeIntervalSince(sample.startDate) / 3600
                                self.user.sleepTime = self.sleepTime
                                self.tableView.reloadData()
                                print("user updated")
                                break
                            }
                        }
                    }
                    
                    /* no need for printing all the data
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "inBed" : "Asleep"
                            print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                        }
                    }
                    */
                }
            }
            
            // finally, we execute our query
            healthStore.execute(query)
            
            // Functions getting Data:
            // getSleepers() in heaven
            print("sleepers initialized")
            self.user = Sleeper(r: "", s: "", t: 0.0, u:nil)
            self.sleepers.append(self.user)
            for index in 1...10 {
                let sleeper = Sleeper(r: "\(index)", s: "lalala", t: Double(index), u:nil)
                self.sleepers.append(sleeper)
            }
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
        
        if(indexPath.row == 0) {
            cell.sleeper = user
        } else {
            cell.sleeper = sleepers[indexPath.row]
        }
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

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? SleeperCell{
            
            cell.isSelected = false
            
            let indexPath = tableView.indexPath(for: cell)
            let sleeper = sleepers[indexPath!.row]
            
            let detailViewController = segue.destination as! SleeperDetailViewController
            
            detailViewController.sleeper = sleeper
        }
    }

}

