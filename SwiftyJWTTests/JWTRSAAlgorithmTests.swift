//
//  JWTRSAAlgorithmTests.swift
//  SwiftyJWTTests
//
//  Created by Shuo Wang on 2018/1/18.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import XCTest
import SwiftyCrypto

class JWTRSAAlgorithmTests: XCTestCase {

    let bundle = Bundle(for: JWTRSAAlgorithmTests.self)
    var publicKeyString: String?
    var privateKeyString: String?
    var privateKey: RSAKey!

    override func setUp() {
        super.setUp()

        guard let publicPath = bundle.path(forResource: "public", ofType: "txt"),
            let privatePath = bundle.path(forResource: "private", ofType: "txt")
            else {
                return XCTFail()
        }
        publicKeyString = try? String(contentsOf: URL(fileURLWithPath: publicPath), encoding: .utf8)
        privateKeyString = try? String(contentsOf: URL(fileURLWithPath: privatePath), encoding: .utf8)
        guard let _ = publicKeyString,
            let _ = privateKeyString else {
                return XCTFail()
        }
        privateKey = try! RSAKey.init(base64String: privateKeyString!, keyType: .PRIVATE)
    }

    func testRSA256Alg() {
        let rsaAlg = JWTAlgorithm.rs256(privateKey)

        // {"alg":"RS256","typ":"JWT"}
        // {"sub":"1234567890","name":"shuowang","admin":true}
        let signature = rsaAlg.sign(message: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6InNodW93YW5nIiwiYWRtaW4iOnRydWV9")
        let urlSafeSignature = Base64Utils.stringURISafe(input: signature!)
        XCTAssert("KR7KPmWtY46Bc3tal4CoNSHGVLh7jgJC1+AlRzBxFw0/4HNBa5a4/Gynb2PG9RljvnppM+Uy9TX2WitHIh9zE/OxaP0faQ/Lc2GyIcX0CBrz4IZ0O0Ky/w1g5ugaT+XoKOzZlUso1F5Nr/waYVyWW57wdtf+BXDoOkj33iAPi/lqFpQrdD501MOs0rrttunJWs/X684jJr7aew8cs1JXNn91+krRt/z8VFJkgYClnfdAc6SPSbHQZPQB1kxApHANJYZEUOyiHn4AUhqnJ9IlWHKJl2KUKIqEVyKQWimoGIT2Sj6xBtIu4Zmx81fmyL1K3HksLCgbxYR03PGqN+WH1g==" == signature)
        XCTAssert("KR7KPmWtY46Bc3tal4CoNSHGVLh7jgJC1-AlRzBxFw0_4HNBa5a4_Gynb2PG9RljvnppM-Uy9TX2WitHIh9zE_OxaP0faQ_Lc2GyIcX0CBrz4IZ0O0Ky_w1g5ugaT-XoKOzZlUso1F5Nr_waYVyWW57wdtf-BXDoOkj33iAPi_lqFpQrdD501MOs0rrttunJWs_X684jJr7aew8cs1JXNn91-krRt_z8VFJkgYClnfdAc6SPSbHQZPQB1kxApHANJYZEUOyiHn4AUhqnJ9IlWHKJl2KUKIqEVyKQWimoGIT2Sj6xBtIu4Zmx81fmyL1K3HksLCgbxYR03PGqN-WH1g" == urlSafeSignature)
    }

    func testGenerateJWT() {
        let headerWithKeyId = JWTHeader.init(keyId: "testKeyId")
        var payload = JWTPayload()
        payload.expiration = 1516187993
        payload.issuer = "yufu"
        payload.subject = "shuo"
        
//        Test Payload content
//        {
//            "height": 181.5,
//            "age": 125,
//            "sub": "shuo",
//            "isAdmin": true,
//            "exp": 1516187993,
//            "name": "wang",
//            "iss": "yufu"
//        }
        payload.customFields = ["name": EncodableValue(value: "wang"),
                                "isAdmin": EncodableValue(value: true),
                                "age": EncodableValue(value: 125),
                                "height": EncodableValue(value: 181.5)]
        let alg = JWTAlgorithm.rs256(privateKey)

        guard let jwtWithKeyId = JWT.init(payload: payload, algorithm: alg, header: headerWithKeyId)
            else {
                return XCTFail()
        }
        guard let simpleJwt = JWT.init(payload: payload, algorithm: alg)else {
            return XCTFail()
        }
        
        XCTAssert(nil != jwtWithKeyId.rawString)
        XCTAssert(nil != simpleJwt.rawString)
    }

}
