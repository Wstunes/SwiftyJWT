//
//  JWTHSTests.swift
//  SwiftyJWTTests
//
//  Created by Shuo Wang on 2018/2/27.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import XCTest

class JWTHSTests: XCTestCase {

    fileprivate let secret = "wangshuowq"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testGenerateJWTSignedWithHS() {
        let alg = JWTAlgorithm.hs256(secret)

        let headerWithKeyId = JWTHeader.init(keyId: "testKeyId")
        var payload = JWTPayload()
        payload.expiration = 1516187993
        payload.issuer = "yufu"
        payload.subject = "shuo"

//                Test Payload content
//                {
//                    "height": 181.5,
//                    "age": 125,
//                    "sub": "shuo",
//                    "isAdmin": true,
//                    "exp": 1516187993,
//                    "name": "wang",
//                    "iss": "yufu"
//                }
        payload.customFields = ["name": EncodableValue(value: "wang"),
            "isAdmin": EncodableValue(value: true),
            "age": EncodableValue(value: 125),
            "height": EncodableValue(value: 161.5)]
        guard let jwtWithKeyId = JWT.init(payload: payload, algorithm: alg, header: headerWithKeyId)
            else {
                return XCTFail()
        }

        XCTAssert(jwtWithKeyId.rawString == "eyJhbGciOiJIUzI1NiIsImtpZCI6InRlc3RLZXlJZCIsInR5cCI6IkpXVCJ9.eyJoZWlnaHQiOjE2MS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6MTUxNjE4Nzk5MywibmFtZSI6IndhbmciLCJpc3MiOiJ5dWZ1In0.LW5X6bznMoSeCKrVwODllANxogZ3mdniUeSirtswWoU")
    }

}
