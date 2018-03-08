//
//  DynamicKey.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/17.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation

public struct DynamicKey: CodingKey {
    public var stringValue: String
    public init(stringValue: String) {
        self.stringValue = stringValue
    }
    public var intValue: Int? { return nil }
    public init?(intValue: Int) { return nil }
}
