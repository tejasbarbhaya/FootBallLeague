//
//  TeamMobel.swift
//  ArrkDemoApp
//
//  Created by Tejash on 27/06/19.
//  Copyright © 2019 Arrk. All rights reserved.
//

import Foundation

class TeamModel {
    var teamDictionary : NSDictionary
    var results: Int!
    var arrayTeams: [Team]!
    
    required init(teamDictionary : NSDictionary) {
        self.teamDictionary = teamDictionary
        self.results = self.teamDictionary["results"] as! Int
        var objTeam : Team!
        self.arrayTeams = [Team]()
        if let arrayobj = self.teamDictionary["teams"] {
            for obj in arrayobj as! [[String : Any]] {
                objTeam = Team(teamIndividualDictionary: obj as NSDictionary)
                self.arrayTeams.append(objTeam)
            }
        }
    }
}

class Team {
/*{11 items
    "team_id":33
    "name":"Manchester United"
    "code":"MUN"
    "logo":"https://www.api-football.com/public/teams/33.png"
    "country":"England"
    "founded":1878
    "venue_name":"Old Trafford"
    "venue_surface":"grass"
    "venue_address":"Sir Matt Busby Way"
    "venue_city":"Manchester"
    "venue_capacity":76212
    }*/
    
    let team_id : Int!
    let name : String!
    let country : String!
    let logo : String?
    
    required init(teamIndividualDictionary : NSDictionary) {
        self.team_id = teamIndividualDictionary ["team_id"] as! Int
        self.name = teamIndividualDictionary ["name"] as! String
        self.country = teamIndividualDictionary ["country"] as! String
        self.logo = teamIndividualDictionary ["logo"] as? String
    }
}
