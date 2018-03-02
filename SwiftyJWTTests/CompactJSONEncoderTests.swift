//
//  CompactJSONEncoderTests.swift
//  SwiftyJWTTests
//
//  Created by Shuo Wang on 2018/1/17.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import XCTest

class CompactJSONEncoderTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testEncodeJWTHeader() {
        let header = JWTHeader(keyId: "testId")
        let encodedHeader = try? CompactJSONEncoder.shared.encodeToString(value: header)
        let data = Data.init(base64Encoded: Base64Utils.base64StringWithPadding(encodedString: encodedHeader!))!
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
            else { return XCTFail() }

        XCTAssert(dic["typ"] as! String == "JWT")
        XCTAssert(dic["kid"] as! String == "testId")
    }

    func testEncodeJWTPayload() {
        var payload = JWTPayload()
        payload.expiration = 1516187993
        payload.issuer = "yufu"
        payload.subject = "shuo"
        payload.customFields = ["name": EncodableValue(value: "wang")]
        let encodedPayload = try? CompactJSONEncoder.shared.encodeToString(value: payload)

        let data = Data.init(base64Encoded: Base64Utils.base64StringWithPadding(encodedString: encodedPayload!))!
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
            else { return XCTFail() }

        XCTAssert(dic["iss"] as! String == "yufu")
        XCTAssert(dic["sub"] as! String == "shuo")
        XCTAssert(dic["exp"] as! Int == 1516187993)
        XCTAssert(dic["name"] as! String == "wang")
    }
}
