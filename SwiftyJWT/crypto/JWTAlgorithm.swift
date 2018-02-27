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
}
