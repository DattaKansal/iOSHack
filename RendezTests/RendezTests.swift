//
//  iOSHackTests.swift
//  iOSHackTests
//
//  Created by Datta Kansal on 10/18/24.
//

import XCTest
import Firebase
@testable import Rendez

final class RendezTests: XCTestCase {

    var db: Firestore!
    var vm: UserViewModel!

    override func setUpWithError() throws {
        super.setUp()
        // Initialize Firestore or mock if needed
        db = Firestore.firestore() // Assuming a real Firestore instance
        vm = UserViewModel()
    }

    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        db = nil
        super.tearDown()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetEvents() async throws {
        let userID = "testUser"
        let events =  try await vm.getEvents()
        print(events[0].orgName)
        print(events[0].tiers.count)
        print("Hi this is \(events[0].tiers[0].numTickets)")
//        print(events[0].)
//        print(events[1].title)
        print(events.count)
        // Assert
        XCTAssertEqual(events.count, 3, "Expected 3 events, but got \(events.count)")
    }
    
    

}
