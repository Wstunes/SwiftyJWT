//
//  InvalidTokenException.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/2/28.
//  Copyright © 2018年 Yufu. All rights reserved.
//
import Foundation

public enum InvalidTokenError: CustomStringConvertible, Error {
    /// Decoding the JWT itself failed
    case decodeError(String)

    /// The JWT uses an unsupported algorithm
    case invalidAlgorithm(String)
    
    /// The JWT signature can not be verified
    case invalidSignature()

    /// The token has expired
    case expiredToken(String)

    /// The token is for the future
    case invalidNotBefore(String)

    /// The token is issued in the future
    case invalidIssuedAt(String)

    /// The audience of the claim doesn't match
    case invalidAudience(String)

    /// The issuer of the claim doesn't match
    case invalidIssuer(String)

    /// The subject of the claim doesn't match
    case invalidSubject(String)

    /// The JTI of the claim doesn't match
    case invalidJTI(String)
    
    /// The argument is missing or illegal
    case invalidOrMissingArgument(String)

    public var description: String {
        switch self {
        case .decodeError(let error):
            return "Decode Error: \(error)"
        case .invalidIssuer(let issuer):
            return "Invalid Issuer: \(issuer)"
        case .expiredToken(let expTime):
            return "Expired token: \(expTime)"
        case .invalidNotBefore(let nbfTime):
            return "The token is not yet valid (not before claim): \(nbfTime)"
        case .invalidIssuedAt(let iatTime):
            return "Issued at claim (iat) is in the future: \(iatTime)"
        case .invalidAudience(let aud):
            return "Invalid Audience: \(aud)"
        case .invalidAlgorithm(let alg):
            return "Unsupported algorithm: \(alg)"
        case .invalidSubject(let sub):
            return "Invalid Subject: \(sub)"
        case .invalidJTI(let jti):
            return "Invalid JTI: \(jti)"
        case .invalidOrMissingArgument(let argumentName) :
            return "InvalidOrMissingArgument: \(argumentName)"
        case .invalidSignature():
            return "InvalidSignature"
        }
    }
}
