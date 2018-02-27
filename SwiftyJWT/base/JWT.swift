//
//  JWT.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/18.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation

public struct JWT {

    var header: JWTHeader!
    var payload: JWTPayload!
    var signature: String!
    var rawString: String!

    init?(payload: JWTPayload,
        algorithm: JWTAlgorithm,
        header: JWTHeader? = nil) {

        var _header = header
        if nil != _header {
            _header?.algorithm = algorithm.description
        } else {
            _header = JWTHeader.init()
            _header?.algorithm = algorithm.description
        }
        self.header = _header
        self.payload = payload

        guard let encodedHeader = try? CompactJSONEncoder.shared.encodeToString(value: _header),
            let encodedPayload = try? CompactJSONEncoder.shared.encodeToString(value: payload)
            else {
                return nil
        }

        let inputTobeSigned = "\(encodedHeader).\(encodedPayload)"
        guard let signature = algorithm.sign(message: inputTobeSigned) else {
            return nil
        }
        self.signature = signature
        self.rawString = String.init(format: "%@.%@",
            Base64Utils.stringURISafe(input: inputTobeSigned),
            Base64Utils.stringURISafe(input: signature))
    }
}
