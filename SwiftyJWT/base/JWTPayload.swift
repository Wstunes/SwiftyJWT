//
//  JWTPayload.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/17.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation

// Ref: registered claim names
// https://tools.ietf.org/html/rfc7519#section-4.1
public struct JWTPayload: Codable {
    // iss
    var issuer: String?
    // sub
    var subject: String?
    // aud
    var audience: String?
    // exp
    var expiration: Int?
    // nbf
    var notBefore: Int?
    // iat
    var issueAt: Int?
    // jti
    var jwtId: String?

    var customFields: [String: EncodableValue]?

    init() {
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        issuer = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.issuer.rawValue))
        subject = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.subject.rawValue))
        audience = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.audience.rawValue))
        if let exp = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.expiration.rawValue)) {
            expiration = Int(exp)
        }
        if let nbf = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.notBefore.rawValue)) {
            notBefore = Int(nbf)
        }
        if let iat = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.issueAt.rawValue)) {
            issueAt = Int(iat)
        }
        jwtId = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.jwtId.rawValue))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encodeIfPresent(issuer, forKey: DynamicKey(stringValue: JWTPayloadKeys.issuer.rawValue))
        try container.encodeIfPresent(subject, forKey: DynamicKey(stringValue: JWTPayloadKeys.subject.rawValue))
        try container.encodeIfPresent(audience, forKey: DynamicKey(stringValue: JWTPayloadKeys.audience.rawValue))
        try container.encodeIfPresent(expiration, forKey: DynamicKey(stringValue: JWTPayloadKeys.expiration.rawValue))
        try container.encodeIfPresent(notBefore, forKey: DynamicKey(stringValue: JWTPayloadKeys.notBefore.rawValue))
        try container.encodeIfPresent(issueAt, forKey: DynamicKey(stringValue: JWTPayloadKeys.issueAt.rawValue))
        try container.encodeIfPresent(jwtId, forKey: DynamicKey(stringValue: JWTPayloadKeys.jwtId.rawValue))
        if let fields = customFields {
            for (key, value) in fields {
                let codingKey = DynamicKey(stringValue: key)
                try container.encodeIfPresent(value, forKey: codingKey)
            }
        }
    }

    enum JWTPayloadKeys: String {
        case issuer = "iss"
        case subject = "sub"
        case audience = "aud"
        case expiration = "exp"
        case notBefore = "nbf"
        case issueAt = "iat"
        case jwtId = "jti"
    }
}
