//
//  CompactJSONDecoder.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/2/28.
//  Copyright © 2018年 Yufu. All rights reserved.
//
import Foundation

public class CompactJSONDecoder: JSONDecoder {
    
    public static let shared = CompactJSONDecoder()
    
    override public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        guard let string = String(data: data, encoding: .ascii) else {
            throw InvalidTokenError.decodeError("data should contain only ASCII characters")
        }

        return try decode(type, from: string)
    }

    public func decode<T>(_ type: T.Type, from string: String) throws -> T where T: Decodable {
        guard let decoded = Base64Utils.base64decode(string) else {
            throw InvalidTokenError.decodeError("data should be a valid base64 string")
        }

        return try super.decode(type, from: decoded)
    }

    public func decode(from string: String) throws -> [String: Any] {
        guard let decoded = Base64Utils.base64decode(string) else {
            throw InvalidTokenError.decodeError("Payload is not correctly encoded as base64")
        }

        let object = try JSONSerialization.jsonObject(with: decoded)
        guard let payload = object as? [String: Any] else {
            throw InvalidTokenError.decodeError("Invalid payload")
        }

        return payload
    }
}


