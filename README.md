SwiftyJWT is a lightweight, pure-Swift library to generate JWT in a flexible way.

## Features

- [x] Generate JWT with certain header, payload and algorithm.
- [x] Decode a JWT String into JWT entity after mandatory checkings.
- [x] Multiple-claims checking.
- [x] Multiple-algorithms support.
- [x] HS, RSA algorithm key management.

## How to integrate

```
pod 'SwiftyJWT'
```

## Available Algorithms

The library implements JWT Verification and Signing using the following algorithms:

| JWS | Algorithm | Description |
| :-------------: | :-------------: | :----- |
| HS256 | HMAC256 | HMAC with SHA-256 |
| HS384 | HMAC384 | HMAC with SHA-384 |
| HS512 | HMAC512 | HMAC with SHA-512 |
| RS256 | RSA256 | RSASSA-PKCS1-v1_5 with SHA-256 |
| RS384 | RSA384 | RSASSA-PKCS1-v1_5 with SHA-384 |
| RS512 | RSA512 | RSASSA-PKCS1-v1_5 with SHA-512 |

## Usage

### Generate JWT with certain header, payload and algorithm

#### HS
```
let alg = JWTAlgorithm.hs256("secret")
let headerWithKeyId = JWTHeader.init(keyId: "testKeyId")
var payload = JWTPayload()
payload.expiration = 515616187993
payload.issuer = "yufu"
payload.subject = "shuo"
payload.customFields = ["name": EncodableValue(value: "wang"),
            "isAdmin": EncodableValue(value: true),
            "age": EncodableValue(value: 125),
            "height": EncodableValue(value: 121.5)]

let jwtWithKeyId = try? JWT.init(payload: payload, algorithm: alg, header: headerWithKeyId)
```

#### RSA
```
let privateKey = try! RSAKey.init(base64String: "keyString", keyType: .PRIVATE)
let alg = JWTAlgorithm.rs256(privateKey)
let jwtWithKeyId = try? JWT.init(payload: payload, algorithm: alg, header: headerWithKeyId)
```

### Decode JWT String into JWT entity
#### HS
```
let jwtString = "ey....."
let alg = JWTAlgorithm.hs256("secret")
let jwt = try? JWT.init(algorithm: alg, rawString: jwtString)
```
#### RSA
```
let jwtString = "ey....."
let publicKey = try! RSAKey.init(base64String: "keyString", keyType: .PUBLIC)
let alg = JWTAlgorithm.rs256(publicKey)
let jwt1 = try? JWT.init(algorithm: alg, rawString: jwtString)
```
### JWTPayload claims checking
```
let payload = JWTPayload()
try payload.checkExpiration()
try payload.checkIssueAt(allowNil: false)
try payload.checkSubject(expected: "shuo")
try payload.checkIssuer(expected: "yufu")
try payload.checkAudience(expected: "here")
```
