//
//  ArrkDemoAppTests.swift
//  ArrkDemoAppTests
//
//  Created by Tejash on 28/06/19.
//  Copyright © 2019 Arrk. All rights reserved.
//

import XCTest
@testable import ArrkDemoApp

class ArrkDemoAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: Network call for getting Leagua Data
    func testCheckLeagueAPI() {
        NetworkController.getNetworkController().getLeagues(url:"leagues", complition: { response, error in
            if error != nil {
                XCTAssert(true,"Got error while fetching Leagues data");
            }else {
                let objLeague = response as? LeagueModel
                XCTAssertNotNil(objLeague,"something wrong with League data!")
            }
        })
    }
    
    
    //MARK: Network call for getting Team Data
    func testCheckTeamAPI() {
        let callUrl = "teams/league/2"
        NetworkController.getNetworkController().getTeamsForLeague(url:callUrl, complition: { response, error in
            if error != nil {
                XCTAssert(true,"Got error while fetching Leagues data");
            }else {
                let objTeam = response as? TeamModel
                XCTAssertNotNil(objTeam,"something wrong with Team data!")
            }
        })
    }
    
    
    
}
