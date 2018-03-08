//
//  EncodableValue.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/22.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation

struct EncodableValue: Codable {
    let value: Encodable

    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }

    init(value _value: Encodable) {
        value = _value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let doubleVal = try? container.decode(Double.self) {
            value = doubleVal
        } else if let boolVal = try? container.decode(Bool.self) {
            value = boolVal
        } else if let stringVal = try? container.decode(String.self) {
            value = stringVal
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing to serialize")
        }
    }
}
