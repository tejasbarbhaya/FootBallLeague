//
//  LeagueModel.swift
//  ArrkDemoApp
//
//  Created by Tejash on 27/06/19.
//  Copyright © 2019 Arrk. All rights reserved.
//

import Foundation

class LeagueModel {
    var leagueDictionary : NSDictionary
    var results: Int!
    var arrayLeagues: [League]!
    
    required init(leagueDictionary : NSDictionary) {
        self.leagueDictionary = leagueDictionary
        self.results = self.leagueDictionary["results"] as! Int
        var objLeagues : League!
        self.arrayLeagues = [League]()
        if let arrayobj = self.leagueDictionary["leagues"] {
            for obj in arrayobj as! [[String : Any]] {
                objLeagues = League(leagueIndividualDictionary: obj as NSDictionary)
                self.arrayLeagues.append(objLeagues)
            }
        }
    }
}

class League {
    /*{"league_id":1,"name":"World Cup","country":"World","country_code":null,"season":2018,"season_start":"2018-06-14","season_end":"2018-07-15","logo":"https:\/\/www.api-football.com\/public\/leagues\/1.png","flag":null,"standings":0,"is_current":1}*/
    
    let league_id : Int!
    let name : String!
    let country : String!
    let season_start : String!
    let season_end : String!
    let logo : String?
    
    required init(leagueIndividualDictionary : NSDictionary) {
        self.league_id = leagueIndividualDictionary ["league_id"] as! Int
        self.name = leagueIndividualDictionary ["name"] as! String
        self.country = leagueIndividualDictionary ["country"] as! String
        self.season_start = leagueIndividualDictionary ["season_start"] as! String
        self.season_end = leagueIndividualDictionary ["season_end"] as! String
        self.logo = leagueIndividualDictionary ["logo"] as? String
    }
}
