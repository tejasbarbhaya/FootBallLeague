//
//  TeamViewController.swift
//  ArrkDemoApp
//
//  Created by Tejash on 28/06/19.
//  Copyright © 2019 Arrk. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

class TeamViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var leagueId:Int! = nil
    var objTeamModel : TeamModel?
    let imageCache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var btnTryAgain: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        //do make Network call
        self.doNetworkCall()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.objTeamModel?.arrayTeams.count {
            return count;
        }else {
            return 0;
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamcellId", for: indexPath) as! TeamCell
        
        let teamObj = self.objTeamModel?.arrayTeams[indexPath.row]
        
        cell.tag = indexPath.row
        cell.imgLogo.image = UIImage.init(named: "iconPlaceholder")
        
        if let cachedImage = self.imageCache.object(forKey: (teamObj?.logo)! as NSString) {
            if cell.tag == indexPath.row {
                cell.imgLogo.image = cachedImage
            }
        }
        else {
            Alamofire.request((teamObj?.logo)!).responseImage { response in
                if let image = response.result.value {
                    if cell.tag == indexPath.row {
                        cell.imgLogo.image = image
                        self.imageCache.setObject(image, forKey: (teamObj?.logo)! as NSString)
                    }
                } else {
                    cell.imgLogo.image = UIImage.init(named: "iconPlaceholder")
                }
            }
        }
        
        cell.lblTeamName.text = teamObj?.name
        cell.lblCountry.text = teamObj?.country
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.init(red: 66/255, green: 34/255, blue: 110/255, alpha: 1.0)
        }else {
            cell.backgroundColor = UIColor.init(red: 253/255, green: 167/255, blue: 255/255, alpha: 1.0)
        }
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction :
    @IBAction func tryAgainClicked(_ sender: Any) {
        
        //do make network call again
        self.doNetworkCall()
    }
    
    //MARK: Network call
    func doNetworkCall() {
        let callUrl = "teams/league/\(leagueId!)"
        
        NetworkController.getNetworkController().showProgressView(forView: self.view)
        NetworkController.getNetworkController().getTeamsForLeague(url:callUrl, complition: { response, error in
            if error != nil {
                print(error?.description)
                DispatchQueue.main.async {
                    NetworkController.getNetworkController().hideProgressView()
                    self.btnTryAgain.isHidden = false
                    self.tblView.isHidden = true
                }
            }else {
                self.objTeamModel = (response as! TeamModel)
                
                DispatchQueue.main.async {
                    NetworkController.getNetworkController().hideProgressView()
                    self.btnTryAgain.isHidden = true
                    self.tblView.isHidden = false
                    self.tblView.reloadData()
                }
            }
        })
    }
}

// MARK: ScanListCell Class Defination

class TeamCell : UITableViewCell {
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
}
