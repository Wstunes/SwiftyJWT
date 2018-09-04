//
//  JWTPayloadTests.swift
//  SwiftyJWTTests
//
//  Created by Shuo Wang on 2018/3/7.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import XCTest

class JWTPayloadTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testDecodeAndCheck() {

        /*
         {
             "height": 121.5,
             "age": 125,
             "sub": "shuo",
             "isAdmin": true,
             "exp": 1520391048,
             "name": "wang",
             "iss": "yufu",
             "nbf": 551520391048,
             "aud": "office"
         }
        */
        let encodedPayload = "eyJoZWlnaHQiOjEyMS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6MTUyMDM5MTA0OCwibmFtZSI6IndhbmciLCJpc3MiOiJ5dWZ1IiwibmJmIjo1NTE1MjAzOTEwNDgsImF1ZCI6Im9mZmljZSJ9"
        let payload = try? CompactJSONDecoder.shared.decode(JWTPayload.self, from: encodedPayload)
        XCTAssertNotNil(payload)

        XCTAssertThrowsError(try payload?.checkExpiration(allowNil: false))
        XCTAssertNoThrow(try payload?.checkExpiration(allowNil: true))

        XCTAssertThrowsError(try payload?.checkIssueAt(allowNil: false))
        XCTAssertNoThrow(try payload?.checkIssueAt(allowNil: true))

        XCTAssertThrowsError(try payload?.checkNotBefore(allowNil: false))
        XCTAssertThrowsError(try payload?.checkNotBefore(allowNil: true))

        XCTAssertThrowsError(try payload?.checkSubject(expected: "here"))
        XCTAssertNoThrow(try payload?.checkSubject(expected: "shuo"))

        XCTAssertThrowsError(try payload?.checkIssuer(expected: "who"))
        XCTAssertNoThrow(try payload?.checkIssuer(expected: "yufu"))
        
        XCTAssertThrowsError(try payload?.checkAudience(expected: "whom"))
        XCTAssertNoThrow(try payload?.checkAudience(expected: "office"))

    }
}
