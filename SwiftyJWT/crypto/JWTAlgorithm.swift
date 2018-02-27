//
//  JWTAlgorithm.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/17.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation
import SwiftyCrypto

public enum JWTAlgorithm: CustomStringConvertible {

    case none
    // RSA
    case rs256(RSAKey)
    case rs384(RSAKey)
    case rs512(RSAKey)

    // HSxxx - HMAC using SHA-xxx hash algorithm
    case hs256(String)
    case hs384(String)
    case hs512(String)

    public var description: String {
        switch self {
        case .none:
            return "none"
        case .rs256:
            return "RS256"
        case .rs384:
            return "RS384"
        case .rs512:
            return "RS512"
        case .hs256:
            return "HS256"
        case .hs384:
            return "HS384"
        case .hs512:
            return "HS512"
        }
    }

    public func sign(message: String) -> String? {
        switch self {
        case .none:
            return ""
        case .rs256(let key):
            return signWithRSA(key: key, rawMessageTobeSigned: message)
        case .rs384(let key):
            return signWithRSA(key: key, rawMessageTobeSigned: message)
        case .rs512(let key):
            return signWithRSA(key: key, rawMessageTobeSigned: message)
        case .hs256(let key):
            return hashWithHS(alg: .sha256, key: key, rawMessageTobeSigned: message)
        case .hs384(let key):
            return hashWithHS(alg: .sha384, key: key, rawMessageTobeSigned: message)
        case .hs512(let key):
            return hashWithHS(alg: .sha512, key: key, rawMessageTobeSigned: message)
        }
    }

    private func signWithRSA(key: RSAKey, rawMessageTobeSigned: String) -> String? {
        do {
            let base64Message = try RSAMessage.init(base64String: Base64Utils.base64encode(input: rawMessageTobeSigned.data(using: String.Encoding.utf8)!))
            let signature = try base64Message.sign(signingKey: key, digestType: RSASignature.DigestType.sha256)
            return signature.base64String
        } catch {
            return nil
        }
    }

    private func hashWithHS(alg: HMACAlgorithm, key: String, rawMessageTobeSigned: String) -> String? {
        guard let messageData = rawMessageTobeSigned.data(using: String.Encoding.utf8, allowLossyConversion: false),
            let keyData = key.data(using: String.Encoding.utf8, allowLossyConversion: false)
            else { return nil }
        let hasedData = hmac(algorithm: alg, key: keyData, message: messageData)
        return Base64Utils.base64encodeURISafe(input: hasedData)
    }
}

