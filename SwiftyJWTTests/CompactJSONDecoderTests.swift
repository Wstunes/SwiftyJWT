//
//  CompactJSONDecoderTests.swift
//  SwiftyJWTTests
//
//  Created by Shuo Wang on 2018/2/28.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import XCTest

class CompactJSONDecoderTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testDecodeJWTHeader() throws {
        /*
          {
             "alg": "HS256",
             "typ": "JWT",
             "kid": "testId"
          }
        */
        let encodedHeader = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InRlc3RJZCJ9"
        let res = try CompactJSONDecoder.shared.decode(JWTHeader.self, from: encodedHeader)
        XCTAssert("HS256" == res.algorithm)
        XCTAssert("testId" == res.keyId)
    }

    func testDecodeJWTPayload() throws {
        /*
          {
             "exp": 1516187993,
             "iss": "yufu",
             "height": 130.55,
             "earCount": 2,
             "sub": "shuo",
             "isAdmin": true,
             "iat": 1516187922 ,
             "jti": "random",
             "location": "BJ",
             "aud": "nazha&tongliya",
             "nbf": 1516188900
          }
         */
        let encodedPayload = "eyJleHAiOjE1MTYxODc5OTMsImlzcyI6Inl1ZnUiLCJoZWlnaHQiOjEzMC41NSwiZWFyQ291bnQiOjIsInN1YiI6InNodW8iLCJpc0FkbWluIjp0cnVlLCJpYXQiOjE1MTYxODc5MjIsImp0aSI6InJhbmRvbSIsImxvY2F0aW9uIjoiQkoiLCJhdWQiOiJuYXpoYSZ0b25nbGl5YSIsIm5iZiI6MTUxNjE4ODkwMH0"
        let payload = try CompactJSONDecoder.shared.decode(JWTPayload.self, from: encodedPayload)
        XCTAssert(payload.expiration == 1516187993)
        XCTAssert(payload.issuer == "yufu")
        XCTAssert(payload.subject == "shuo")
        XCTAssert(payload.issueAt == 1516187922)
        XCTAssert(payload.jwtId == "random")
        XCTAssert(payload.audience == "nazha&tongliya")
        XCTAssert(payload.notBefore == 1516188900)
        XCTAssert(payload.customFields?["height"]?.value as? Double ==  130.55)
        XCTAssert(payload.customFields?["earCount"]?.value as? Int == 2)
        XCTAssert(Bool.init(exactly: payload.customFields?["isAdmin"]?.value as! NSNumber) ==  true)
        XCTAssert(payload.customFields?["location"]?.value as? String == "BJ")
    }

}
