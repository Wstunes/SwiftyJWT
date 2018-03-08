//
//  Base64Utils.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/17.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation

public class Base64Utils: NSObject {

    // Normally base64 encode
    public static func base64encode(input: Data) -> String {
        let data = input.base64EncodedData()
        let string = String(data: data, encoding: .utf8)!
        return string
    }

    public static func base64encode(input: String) -> String? {
        let data = input.data(using: String.Encoding.utf8)
        return data?.base64EncodedString()
    }

    // URI Safe base64 encode
    public static func stringURISafe(input: String) -> String {
        return input
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    // URI Safe base64 encode
    public static func base64encodeURISafe(input: Data) -> String {
        let data = input.base64EncodedData()
        let string = String(data: data, encoding: .utf8)!
        return string
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    // URI Safe base64 decode
    public static func base64decode(_ input: String) -> Data? {
        let rem = input.count % 4

        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }

        let base64 = input.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/") + ending

        return Data(base64Encoded: base64)
    }

    public static func decode(encodedString: String) -> String? {

        if let data = Data(base64Encoded: base64StringWithPadding(encodedString: encodedString)) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    public static func base64StringWithPadding(encodedString: String) -> String {
        var stringTobeEncoded = encodedString.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let paddingCount = encodedString.count % 4
        for _ in 0..<paddingCount {
            stringTobeEncoded += "="
        }
        return stringTobeEncoded
    }
}
