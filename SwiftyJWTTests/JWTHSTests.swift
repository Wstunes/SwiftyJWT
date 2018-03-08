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
    }

    func testGenerateJWTSignedWithHS() {
        let alg = JWTAlgorithm.hs256(secret)

        let headerWithKeyId = JWTHeader.init(keyId: "testKeyId")
        var payload = JWTPayload()
        payload.expiration = 515616187993
        payload.issuer = "yufu"
        payload.subject = "shuo"

        /*
            Test Payload content
            {
                "height": 121.5,
                "age": 125,
                "sub": "shuo",
                "isAdmin": true,
                "exp": 515616187993,
                "name": "wang",
                "iss": "yufu"
            }
        */
        payload.customFields = ["name": EncodableValue(value: "wang"),
            "isAdmin": EncodableValue(value: true),
            "age": EncodableValue(value: 125),
            "height": EncodableValue(value: 121.5)]
        guard let jwtWithKeyId = JWT.init(payload: payload, algorithm: alg, header: headerWithKeyId)
            else {
                return XCTFail()
        }

        XCTAssert(jwtWithKeyId.rawString == "eyJhbGciOiJIUzI1NiIsImtpZCI6InRlc3RLZXlJZCIsInR5cCI6IkpXVCJ9.eyJoZWlnaHQiOjEyMS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6NTE1NjE2MTg3OTkzLCJuYW1lIjoid2FuZyIsImlzcyI6Inl1ZnUifQ.ahoJ3T64Vd2DJvQh6ux2CnXplzb1QyIUTTjuYb17Obg")
    }

    func testVerifyTokenSignedWithHS256() {
        let hsAlg = JWTAlgorithm.hs256(secret)

        let jwtString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InRlc3RJZCJ9.eyJoZWlnaHQiOjEyMS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6NTE1NjE2MTg3OTkzLCJuYW1lIjoid2FuZyIsImlzcyI6Inl1ZnUifQ.u_N1jvfBuakTz85_1kebgIRZEqkR72cGzNcHeFrbgkE"
        let jwt = try? JWT.init(algorithm: hsAlg, rawString: jwtString)
        XCTAssertNotNil(jwt)
        XCTAssert(jwt?.payload.subject == "shuo")
        XCTAssert(jwt?.payload.customFields?["height"]?.value as? Double == 121.5)

        let expiredJWTString = "eyJhbGciOiJIUzI1NiIsImtpZCI6InRlc3RLZXlJZCIsInR5cCI6IkpXVCJ9.eyJoZWlnaHQiOjEyMS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6MTUyMDM5MTA0OCwibmFtZSI6IndhbmciLCJpc3MiOiJ5dWZ1IiwibmJmIjo1NTE1MjAzOTEwNDgsImF1ZCI6Im9mZmljZSJ9.0h0-TjwnkzrpjYRyZ49DRHBsKPdLLoV8vlIL3L7mH0Y"
        let expiredJwt = try? JWT.init(algorithm: hsAlg, rawString: expiredJWTString)
        XCTAssertNil(expiredJwt)
    }

}
