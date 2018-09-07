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
    public var issuer: String?
    // sub
    public var subject: String?
    // aud
    public var audience: String?
    // exp
    public var expiration: Int?
    // nbf
    public var notBefore: Int?
    // iat
    public var issueAt: Int?
    // jti
    public var jwtId: String?

    public var customFields: [String: EncodableValue]?

    public static let reservedKeys = ["iss", "sub", "aud", "exp", "nbf", "iat", "jti"]

    enum JWTPayloadKeys: String {
        case issuer = "iss"
        case subject = "sub"
        case audience = "aud"
        case expiration = "exp"
        case notBefore = "nbf"
        case issueAt = "iat"
        case jwtId = "jti"
    }

    public init() {
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        issuer = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.issuer.rawValue))
        subject = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.subject.rawValue))
        audience = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.audience.rawValue))
        expiration = try container.decodeIfPresent(Int.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.expiration.rawValue))
        notBefore = try container.decodeIfPresent(Int.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.notBefore.rawValue))
        issueAt = try container.decodeIfPresent(Int.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.issueAt.rawValue))
        jwtId = try container.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: JWTPayloadKeys.jwtId.rawValue))
        let customKeys = container.allKeys
            .filter({ !JWTPayload.reservedKeys.contains($0.stringValue) })
        if 0 < customKeys.count {
            customFields = [:]
            for key in customKeys {
                customFields![key.stringValue] = try container.decodeIfPresent(EncodableValue.self, forKey: key)
            }
        }
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

    private func validateDate(key: DynamicKey, rightCompareResult: ComparisonResult, allowNil: Bool) throws {

        var error: InvalidTokenError
        var value: Int?

        switch key.stringValue {
        case "nbf":
            value = notBefore
            error = InvalidTokenError.invalidNotBefore("\(notBefore ?? 0)")
        case "iat":
            value = issueAt
            error = InvalidTokenError.invalidIssuedAt("\(issueAt ?? 0)")
        case "exp":
            value = expiration
            error = InvalidTokenError.expiredToken("\(expiration ?? 0)")
        default:
            throw InvalidTokenError.invalidOrMissingArgument(key.stringValue)
        }

        if value == nil {
            if allowNil {
                return
            } else {
                throw InvalidTokenError.invalidOrMissingArgument(key.stringValue)
            }
        }

        let date = Date(timeIntervalSince1970: Double(value!))
        if date.compare(Date()) != rightCompareResult {
            throw error
        }
    }

    public func checkNotBefore(allowNil: Bool) throws {
        try validateDate(key: DynamicKey.init(stringValue: JWTPayloadKeys.notBefore.rawValue), rightCompareResult: .orderedAscending, allowNil: allowNil)
    }

    public func checkExpiration(allowNil: Bool) throws {
        try validateDate(key: DynamicKey.init(stringValue: JWTPayloadKeys.expiration.rawValue), rightCompareResult: .orderedDescending, allowNil: allowNil)
    }

    public func checkIssueAt(allowNil: Bool) throws {
        try validateDate(key: DynamicKey.init(stringValue: JWTPayloadKeys.issueAt.rawValue), rightCompareResult: .orderedAscending, allowNil: allowNil)
    }

    private let nullValue = "null"

    public func checkIssuer(expected: String) throws {
        if let iss = self.issuer {
            if iss != expected {
                throw InvalidTokenError.invalidIssuer(iss)
            }
        } else {
            throw InvalidTokenError.invalidIssuer(nullValue)
        }
    }

    public func checkSubject(expected: String) throws {
        if let sub = self.subject {
            if sub != expected {
                throw InvalidTokenError.invalidSubject(sub)
            }
        } else {
            throw InvalidTokenError.invalidSubject(nullValue)
        }
    }

    public func checkAudience(expected: String) throws {
        if let aud = self.audience {
            if aud != expected {
                throw InvalidTokenError.invalidAudience(aud)
            }
        } else {
            throw InvalidTokenError.invalidAudience(nullValue)
        }
    }

    public func checkJTI(expected: String) throws {
        if let jti = self.jwtId {
            if jti != expected {
                throw InvalidTokenError.invalidJTI(jti)
            }
        } else {
            throw InvalidTokenError.invalidJTI(nullValue)
        }
    }

}
