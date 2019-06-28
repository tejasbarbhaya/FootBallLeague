//
//  ViewController.swift
//  ArrkDemoApp
//
//  Created by Tejash on 27/06/19.
//  Copyright © 2019 Arrk. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class LeagueViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    let imageCache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var btnTryAgain: UIButton!
    
    
    var objLeagueModel : LeagueModel?
    
    //MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        // make Network call to get data
        self.makeNetworkCall()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.objLeagueModel?.arrayLeagues.count {
            return count;
        }else {
            return 0;
        }
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaguecellId", for: indexPath) as! LeagueCell
        
        let leagueObj = self.objLeagueModel?.arrayLeagues[indexPath.row]
        
        cell.tag = indexPath.row
        
        cell.imgLogo.image = UIImage.init(named: "iconPlaceholder")
        
        if let cachedImage = self.imageCache.object(forKey: (leagueObj?.logo)! as NSString) {
            if cell.tag == indexPath.row {
                cell.imgLogo.image = cachedImage
            }
        }
        else {
            Alamofire.request((leagueObj?.logo)!).responseImage { response in
                if let image = response.result.value {
                    if cell.tag == indexPath.row {
                        cell.imgLogo.image = image
                        self.imageCache.setObject(image, forKey: (leagueObj?.logo)! as NSString)
                    }
                } else {
                    cell.imgLogo.image = UIImage.init(named: "iconPlaceholder")
                }
            }
        }
    
        cell.lblLeagueName.text = leagueObj?.name
        cell.lblCountry.text = leagueObj?.country
        cell.lblStartDate.text = leagueObj?.season_start
        cell.lblEnddate.text = leagueObj?.season_end
        
        
        if indexPath.row % 2 == 0 {
            //cell.backgroundColor = UIColor.init(red: 17/255, green: 93/255, blue: 255/255, alpha: 1.0)
            cell.backgroundColor = UIColor.init(red: 66/255, green: 34/255, blue: 110/255, alpha: 1.0)
            
        }else {
            //cell.backgroundColor = UIColor.init(red: 34/255, green: 215/255, blue: 255/255, alpha: 1.0)
            cell.backgroundColor = UIColor.init(red: 253/255, green: 167/255, blue: 255/255, alpha: 1.0)
        }
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTeamVC"{
            if let indexPath = self.tblView.indexPathForSelectedRow {
                let vc = segue.destination as! TeamViewController
                let leagueObj = self.objLeagueModel?.arrayLeagues[indexPath.row]
                vc.leagueId = leagueObj?.league_id
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction Methods
    @IBAction func tryAgainClicked(_ sender: Any) {
        // do make network call again
        self.makeNetworkCall()
    }
    
    //MARK: Network call
    
    func makeNetworkCall() {
        
        NetworkController.getNetworkController().showProgressView(forView: self.view)
        NetworkController.getNetworkController().getLeagues(url:"leagues", complition: { response, error in
            if error != nil {
                print(error?.description)
                DispatchQueue.main.async {
                    NetworkController.getNetworkController().hideProgressView()
                    self.btnTryAgain.isHidden = false
                    self.tblView.isHidden = true
                }
            }else {
                self.objLeagueModel = response as? LeagueModel
                
                DispatchQueue.main.async {
                    self.btnTryAgain.isHidden = true
                    self.tblView.isHidden = false
                    NetworkController.getNetworkController().hideProgressView()
                    self.tblView.reloadData()
                }
            }
        })
    }
}

// MARK: ScanListCell Class Defination

class LeagueCell : UITableViewCell {
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblEnddate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblLeagueName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
}

