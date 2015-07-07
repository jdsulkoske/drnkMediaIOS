//
//  Parser.swift
//  drnk
//
//  Created by faris shatat on 6/9/15.
//  Copyright (c) 2015 Sulk. All rights reserved.
//

import Foundation

class Parser{
    var jsonFile:NSArray!
    var bar : BarsTableInfo!
    var special : BarInfo!
    var barSpecialArray = [String]()
    var barInfoArray = [String]()
    var address = " "
    var name = ""
    
    var lsjsonFile:NSArray!
    var lsSpecialArray = [String]()
    var lsAddress = " "
    var lsName = ""
    
    var dayOfTheWeek : Day = Day()
    
    var deals : NSDictionary!
    init(jsonFile:NSArray){
        self.jsonFile = jsonFile
        let date = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        let day = formatter.stringFromDate(date)
        dayOfTheWeek.findDay(day)
        dayOfTheWeek.intValueToDayString(dayOfTheWeek.getIntValueOfDay())
      
       
    }
    var lsDeals : NSDictionary!
    init(lsjsonFile:NSArray){
        self.lsjsonFile = lsjsonFile
        let date = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        let day = formatter.stringFromDate(date)
        dayOfTheWeek.findDay(day)
        dayOfTheWeek.intValueToDayString(dayOfTheWeek.getIntValueOfDay())
        
        
    }
    
    
    
    func parseBarInfo(type:String){
   
        for posts in jsonFile{
            address = posts["company_street"] as! String
            name = posts["company_name"] as! String
            deals = (posts["deals"] as? NSDictionary)!
            if type == "barView"{
                self.parseForSpecial()
            }
            else{
            println("get it")
            parseSpecialForWeek()
            }
            
            
            
        }
        
    }
    
    func parseSpecialForWeek(){
        if let file = jsonFile[detailViewIndex!]["deals"] as? NSDictionary{
    
    for(var i = 0; i<daysOfWeek.count; i++){
        var days = file[daysOfWeek[i].lowercaseString] as! NSArray
        for deal in days{
            var specialForDay = deal["deal_name"] as! String
            barInfoArray.append(specialForDay)
            if barInfoArray.count >= 5{
                special = BarInfo(special1: barInfoArray[0], special2:barInfoArray[1], special3: barInfoArray[2], special4: barInfoArray[3], special5: barInfoArray[4])
            }
          
            }
            detailTableViewArray.append(special)
            barInfoArray.removeAll(keepCapacity: true)
        }
            
            
          
        
        }

        }
    
    func parseLSInfo(){
        for posts in jsonFile {
            lsAddress = posts["company_street"] as! String
            lsName = posts["company_name"] as! String
            lsDeals = (posts["deals"] as? NSDictionary)!
            self.parseForLSSpecial()
            
        }
        
    }
    
    func parseForSpecial(){
        var days = deals[dayOfTheWeek.getDayAsString().lowercaseString] as! NSArray

        for posts in days{
                var barspecial = posts["deal_name"] as! String
                barSpecialArray.append(barspecial)

            }
        bar = BarsTableInfo(name: name, address: address,barImage:"VCImage.png",special1: barSpecialArray[0], special2:barSpecialArray[1],special3: barSpecialArray[2])
        
        arrayOfBars.append(bar)
        barSpecialArray.removeAll(keepCapacity: true)
        

                }
        
    func parseForLSSpecial(){
        var days = lsDeals["everyday"] as! NSArray
        for posts in days{
            var lsSpecial = posts["deal_name"] as! String
            lsSpecialArray.append(lsSpecial)
        }
        liquorStore = LiquorStoresInformation(lsName: lsName, address: lsAddress, lsImage: "VCImage.png", special1: lsSpecialArray[0], special2: lsSpecialArray[1], special3: lsSpecialArray[2])
        arrayOfLiquorStores.append(liquorStore)
    }
    
  
    

}