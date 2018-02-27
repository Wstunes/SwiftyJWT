//
//  EncodableValue.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/22.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation

struct EncodableValue: Encodable {
    let value: Encodable
    
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
