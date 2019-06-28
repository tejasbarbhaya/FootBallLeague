//
//  LeaguesService.swift
//  ArrkDemoApp
//
//  Created by Tejash on 27/06/19.
//  Copyright © 2019 Arrk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JGProgressHUD

class NetworkController {
    static var networkObject : NetworkController?
    var hud : JGProgressHUD?
    
    static func getNetworkController() -> NetworkController {
        if self.networkObject == nil {
            self.networkObject = NetworkController()
        }
        return self.networkObject!
    }
    
    func doNetworkCall(url: String, complition: @escaping (_ response:AnyObject?,_ error: NSError?) -> Void) {
        
        //MARK: Local Calls
        
        /*var file:String?
        if url.contains("teams/") {
            file = Bundle.main.path(forResource: "teamData", ofType: "json")
        }else {
            file = Bundle.main.path(forResource: "leagueData", ofType: "json")
        }
        
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
        
        do {
            let object: NSDictionary = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
            complition(object,nil)
        } catch let error as NSError {
            complition(nil,error)
        }*/
        
        
        //MARK: Internet Calls
        
         let finalUrl = BaseURL.production + url
         let headers : HTTPHeaders = ["X-RapidAPI-Host": KEY.RapidAPIHost, "X-RapidAPI-Key": KEY.RapidAPIKey]
         
         Alamofire.request(finalUrl,method: .get, parameters: nil, encoding: JSONEncoding.default ,headers:headers).responseJSON { (responseData) -> Void in
            switch responseData.result {
                
            case .success(_) :
                if((responseData.result.value) != nil) {
                    do {
                         let object: NSDictionary = try JSONSerialization.jsonObject(with: responseData.data!, options:.allowFragments) as! NSDictionary
                        complition(object,nil)
                    } catch let error as NSError {
                        print(error)
                        complition(nil,error)
                    }
                }
                
            case .failure(let err) :
                let error = err as! NSError
                print("Network call error code : \(error.description)")
                complition(nil,err as NSError)
            }
        }
    }
    
    //MARK: GET API Data
    
    func getLeagues(url: String, complition: @escaping (_ response: Any?, _ error: NSError?) -> Void) {
        self.doNetworkCall(url: url,complition: { response, error in
            if error != nil {
                complition(nil, error)
            }else {
                let objLeagueModel = LeagueModel(leagueDictionary: response?["api"] as! NSDictionary)
                complition(objLeagueModel,nil)
            }
        })
    }
    
    func getTeamsForLeague(url: String, complition: @escaping (_ response: Any?, _ error: NSError?) -> Void) {
        self.doNetworkCall(url: url,complition: { response, error in
            if error != nil {
                complition(nil, error)
            }else {
                let objTeamModel = TeamModel(teamDictionary: response?["api"] as! NSDictionary)
                complition(objTeamModel,nil)
            }
        })
    }
    
    //MARK: Utility Methods
    
    func showProgressView(forView view: UIView) {
        if self.hud == nil {
            hud = JGProgressHUD(style: .dark)
        }
        self.hud?.textLabel.text = MESSAGES.pleaseWaitMessage
        self.hud?.show(in: view)
    }
    
    func hideProgressView() {
        self.hud?.dismiss(afterDelay: 1.0, animated: true)
    }
}
