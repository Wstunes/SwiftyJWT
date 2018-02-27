//
//  CompactJSONEncoder.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/17.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation

class CompactJSONEncoder: JSONEncoder {

    static let shared = CompactJSONEncoder()
    
    override func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return try encodeToString(value: value).data(using: .ascii) ?? Data()
    }

    func encodeToString<T: Encodable>(value: T) throws -> String {
        return Base64Utils.base64encodeURISafe(input: try super.encode(value))
    }
}
