//
//  JWT.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/18.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation

public struct JWT {

    public var header: JWTHeader!
    public var payload: JWTPayload!
    public var signature: String!
    public var rawString: String!

    public init?(payload: JWTPayload,
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

    public init(algorithm: JWTAlgorithm,
        rawString: String) throws {

        let segments = rawString.components(separatedBy: ".")
        if segments.count != 3 {
            throw InvalidTokenError.decodeError("The number of segments is not 3")
        }

        let encodedHeader = segments[0]
        let encodedPayload = segments[1]
        let signatureSegment = segments[2]

        self.header = try CompactJSONDecoder.shared.decode(JWTHeader.self, from: encodedHeader)
        self.payload = try CompactJSONDecoder.shared.decode(JWTPayload.self, from: encodedPayload)
        try self.payload.checkExpiration(allowNil: false)
        try self.payload.checkIssueAt(allowNil: true)
        try self.payload.checkNotBefore(allowNil: true)

        if try !algorithm.verify(base64EncodedSignature: signatureSegment, rawMessage: "\(encodedHeader).\(encodedPayload)") {
            throw InvalidTokenError.invalidSignature()
        }

        self.signature = signatureSegment
        self.rawString = rawString
    }
}
