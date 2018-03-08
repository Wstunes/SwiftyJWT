//
//  JWTRSAAlgorithmTests.swift
//  SwiftyJWTTests
//
//  Created by Shuo Wang on 2018/1/18.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import XCTest
import SwiftyCrypto

class JWTRSATests: XCTestCase {

    let bundle = Bundle(for: JWTRSATests.self)
    var publicKeyString: String?
    var privateKeyString: String?
    var privateKey: RSAKey!
    var publicKey: RSAKey!

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
        publicKey = try! RSAKey.init(base64String: publicKeyString!, keyType: .PUBLIC)
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

        /*
            Test Payload content
            {
                "height": 181.5,
                "age": 125,
                "sub": "shuo",
                "isAdmin": true,
                "exp": 1516187993,
                "name": "wang",
                "iss": "yufu"
            }
        */
        payload.customFields = ["name": EncodableValue(value: "wang"),
            "isAdmin": EncodableValue(value: true),
            "age": EncodableValue(value: 125),
            "height": EncodableValue(value: 181.5)]
        let alg = JWTAlgorithm.rs256(privateKey)

        guard let jwtWithKeyId = JWT.init(payload: payload, algorithm: alg, header: headerWithKeyId)
            else {
                return XCTFail()
        }
        guard let simpleJwt = JWT.init(payload: payload, algorithm: alg) else {
            return XCTFail()
        }

        XCTAssert(jwtWithKeyId.rawString == "eyJhbGciOiJSUzI1NiIsImtpZCI6InRlc3RLZXlJZCIsInR5cCI6IkpXVCJ9.eyJoZWlnaHQiOjE4MS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6MTUxNjE4Nzk5MywibmFtZSI6IndhbmciLCJpc3MiOiJ5dWZ1In0.3ouyzwI5L5ZrWGg_CjAtzlI2erRtkQq5p40Ejz8fKa7iXkJesIcjUZr7kyyxYP2SMWrjjaiAl6oglc-bWA93ttR3c1s3BwC1aIoiJFEMQOQUixCzWovPPI3r93yVHLYZKNyXGBfxHrmbJvF809S8oU8lmrCDbxPdPyAANvqeEnTsoJgxTLIH1_ucclGYM9KdkzEUfUwXAr_1TKVYPLwsBfUifwX62I2KeBbDXLR9blySUhgugn5MhkLz6_qrwRmHUUQ-HfKuEKDJdzMzP1o5a0WLXSclwMuuAqINP0604uR0rJ1M6kaQKhnMY9o5A2o3Fhg9iPXZMk94qUVm6B_01A")
        XCTAssert(simpleJwt.rawString == "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJoZWlnaHQiOjE4MS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6MTUxNjE4Nzk5MywibmFtZSI6IndhbmciLCJpc3MiOiJ5dWZ1In0.bJ-kTBt9jI_vsIXJsJi3YGcr1swD41UTwSRRfHouM1-aaF5v9zEUQ4uGT2WYY0CUI5aEocfogo9P-1UKMlWfZ0orMEk6m5eaiI4yrQfffuOwZ6Kalhm0b1SkVmjfJp1xMcf_gtJgilXAN8s4ubs_5n_IS3rjiLojJcGc2Y17AhccXgLOPZp95UMPd1ulbLT5fNhlfw672jHSzIGmtYLa00Vh6oZJfpRrcSq_H_skLueJ3Jv_JvzcjppWsT6Zm-ObL3gaEKxWlmGYeZORFfmUXs4loFTwemJ1vWNGV7koNZVj6ZZTgrur61h92R8j5tSGQBpU3-esORu0emxQ936YaA")
    }

    func testVerifyTokenSignedWithRS256() {

        let alg = JWTAlgorithm.rs256(publicKey)
        let jwtString = "eyJhbGciOiJSUzI1NiIsImtpZCI6InRlc3RLZXlJZCIsInR5cCI6IkpXVCJ9.eyJoZWlnaHQiOjEyMS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6NTE1NjE2MTg3OTkzLCJuYW1lIjoid2FuZyIsImlzcyI6Inl1ZnUifQ.cR56Xc9+Xz/ML8ah47Ve3nCkJXmLm4OyOYgbZHxk92q59o8A9KCS3NDXDTDuo5qTQW9tITsoNQKh9x9e9ZI2LfCrzArNTQ0WUShGqRXguC1hC+EfCHEZvOwfzClpSSqYiDMPEGsqTXoy3mE9lSdNDq3O60+DOFytQEE4/PmOYgRM7XbyGPGe6jZn7y9kMM4uZL37+1MCvJIxvBcDZuA26YV4X7XqEg2JznMDoKbBqYJNqE5D8Wh6HJEJuJ5Yd/MGTYZaDpRLNQlF4EVV2843EZWuNq6juvZwXN4Ias53aSfhx2Q4yQqZYqgVSZ1WW2R3wOzD9AJZlwW2thMbgQnVIg=="
        let jwt1 = try? JWT.init(algorithm: alg, rawString: jwtString)
        XCTAssertNotNil(jwt1)

        let jwtStringUrlSafe = "eyJhbGciOiJSUzI1NiIsImtpZCI6InRlc3RLZXlJZCIsInR5cCI6IkpXVCJ9.eyJoZWlnaHQiOjEyMS41LCJhZ2UiOjEyNSwic3ViIjoic2h1byIsImlzQWRtaW4iOnRydWUsImV4cCI6NTE1NjE2MTg3OTkzLCJuYW1lIjoid2FuZyIsImlzcyI6Inl1ZnUifQ.cR56Xc9-Xz_ML8ah47Ve3nCkJXmLm4OyOYgbZHxk92q59o8A9KCS3NDXDTDuo5qTQW9tITsoNQKh9x9e9ZI2LfCrzArNTQ0WUShGqRXguC1hC-EfCHEZvOwfzClpSSqYiDMPEGsqTXoy3mE9lSdNDq3O60-DOFytQEE4_PmOYgRM7XbyGPGe6jZn7y9kMM4uZL37-1MCvJIxvBcDZuA26YV4X7XqEg2JznMDoKbBqYJNqE5D8Wh6HJEJuJ5Yd_MGTYZaDpRLNQlF4EVV2843EZWuNq6juvZwXN4Ias53aSfhx2Q4yQqZYqgVSZ1WW2R3wOzD9AJZlwW2thMbgQnVIg"
        let jwt2 = try? JWT.init(algorithm: alg, rawString: jwtStringUrlSafe)
        XCTAssertNotNil(jwt2)
    }

}
