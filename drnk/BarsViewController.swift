//
//  FirstViewController.swift
//  drnk
//
//  Created by drnk LLC on 5/25/15.
//  Copyright (c) 2015 drnk LLC. All rights reserved.
//

import UIKit

var arrayOfBars: [BarsTableInfo] = [BarsTableInfo]()
var activePlace = 1
var index : Int?


class BarsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var locationIndicator: UIBarButtonItem!
    @IBOutlet weak var networkMessage: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!

    var timer = NSTimer()
    var refresher : UIRefreshControl!
    var selected:[Bool] = Array(count: 100, repeatedValue: false)
    var data = DataConnection(typeOfBusiness: "bar=true")
    var barNameToPass : String?
    var barAddressToPass: String?
    var cellIndex : Int?
    var barImageToPass : String?
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName: UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)])
        refresher.backgroundColor = UIColor(red: 75/255, green: 75/255, blue: 75/255
            , alpha: 1)
        refresher.addTarget(self, action: #selector(BarsViewController.updateData), forControlEvents: UIControlEvents.ValueChanged)
        
        self.myTableView.addSubview(refresher)
        self.navigationController?.toolbar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        self.navigationController?.toolbar.tintColor = UIColor(red: 0/255, green: 178/255, blue: 255/255, alpha: 0.7)
        self.navigationController?.toolbar.translucent = true
        self.navigationController?.navigationBarHidden = true
        self.updateData()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func updateData(){
        self.networkMessage.hidden = true
        data.getData { (responseObject, error) -> Void in
            
            if  responseObject == nil{
                
                self.networkMessage.hidden = false
                self.networkMessage.text = "Network Unavailable"
                self.refresher.endRefreshing()

                
            } else {
                
                self.networkMessage.hidden = true
                let parser = Parser(jsonFile: responseObject!)
                arrayOfBars.removeAll(keepCapacity: true)
                
                dispatch_async(dispatch_get_main_queue()){
                    
                parser.parseBarInfo("barView")
                    
                self.myTableView.reloadData()
                
                    
                }
                
                if arrayOfBars.count == 0{
                    self.networkMessage.text = "Sorry, there doesn't seem to be any businesses in your area that utilize drnk! You can check out specials in other cities by changing your preferred location below!"
                    self.networkMessage.hidden = false
                    
                }
            
            }
            
            self.refresher.endRefreshing()
            return
            
        }
    
    }
    
    override func viewDidAppear(animated: Bool) {
        segue = "barViewController"
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        } else {

        }
        
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfBars.count
        
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell: CustomBarTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomBarTableViewCell
        cellIndex = indexPath.row
        let bar = arrayOfBars[indexPath.row]
        index = cell.tag
        cell.addressOfBar.tag = indexPath.row
        
        cell.setCell(bar.name, addressOfBarText: bar.address, image: bar.barImage,special1: bar.special1,special2: bar.special2,special3: bar.special3)
        cell.detailTextLabel?.text = bar.name
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
        barNameToPass = arrayOfBars[indexPath.row].name
        barImageToPass = arrayOfBars[indexPath.row].barImage
        barAddressToPass = arrayOfBars[indexPath.row].address
        performSegueWithIdentifier("showBarInformationSegue", sender: self)
       
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        detailViewIndex = indexPath.row
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showBarInformationSegue"{
            
            let barInformationViewController = segue.destinationViewController as! BarInformationViewController
            barInformationViewController.barPassedValue = barNameToPass
            barInformationViewController.imagePassedValue = barImageToPass
            barInformationViewController.addressPassedValie = barAddressToPass
           
        }
        
        if segue.identifier == "newPlace" {
            
            activePlace = -1
            
        }
        
    }
    
    @IBAction func assignRowIndexToButton(sender: UIButton) {
        
        let row = sender.tag
        selected[row] = true
        index = sender.tag
        
    }
    
}

