

import Foundation
import Alamofire

class DataConnection {

    var post : NSArray!
    var error : ErrorType?
    var typeOfBusiness : String!
    var barsTrue : String!
    var liquorTrue : String!
    
    init(typeOfBusiness:String){
        
        self.typeOfBusiness = typeOfBusiness
        
    }
    
    func requestData(completionHandler: (responseObject: NSArray?, error: ErrorType?) -> ()){
      
//        let requestString = "http://drnkmedia.com/api/api.php/?company_city=Muncie&" + typeOfBusiness
        let requestString = "http://drnkmedia.com/api/api.php/?company_city=Muncie&" + typeOfBusiness
        
        Alamofire.request(.GET, requestString).responseJSON() {
            response in
            if response.result.isSuccess {
                let data = response.result.value
                self.post = data as! NSArray
//                debugPrint(self.post[1])
                    
            } else {
                let error = self.error
                print("Request failed with error: \(error)")
            }
                completionHandler(responseObject: self.post , error: self.error)
        }
        
    }
    
    
    
    func getData(completionHandler: (responseObject: NSArray?, error: ErrorType?) -> ()){
        
       requestData(completionHandler)
        
    }

}
    

