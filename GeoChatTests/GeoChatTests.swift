//
//  GeoChatTests.swift
//  GeoChatTests
//
//  Created by Frank Solleveld on 14/04/2020.
//

import XCTest
import CoreLocation
//@testable import GeoChat

class GeoChatTests: XCTestCase {

    func testHelloWorld() {
        var helloWorld: String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "Hello World"
        
        XCTAssertEqual(helloWorld, "Hello World")
    }

}
