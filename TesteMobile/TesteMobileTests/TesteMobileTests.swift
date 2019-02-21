//
//  TesteMobileTests.swift
//  TesteMobileTests
//
//  Created by Jaber Shamali on 15/02/19.
//  Copyright © 2019 Jaber Shamali. All rights reserved.
//

import XCTest
@testable import TesteMobile

class TesteMobileTests: XCTestCase {
    
    var viewController: ViewController!

    override func setUp() {
        super.setUp()
        
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Controller") as? ViewController
        
        _ = viewController.preload
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
