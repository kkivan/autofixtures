# Autofixtures
[![CI](https://github.com/kkivan/autofixtures/workflows/CI/badge.svg)](https://github.com/kkivan/autofixtures/actions?query=workflow%3ACI)  
Fixtures for Swift

# Motivation
During testing or development we ususally need to create mock models (fixtures) to pass them as arguments.  
The models tend to become very complex and cumbersome to create every time, so you may come up with static method to create models.  
For example:
```
struct User {
  let id: Int
  let name: String
  let email: String
  struct Address {
    let road: String
    let building: String
  }
  let address: Address
}
```
You can come up with something like this
```
extension User {
  static func fixture(id: Int = 11,
                      name: String = "fix",
                      email: String = "fix",
                      address: Address = .fixture()) -> User {
    return User(id: id,
                name: name,
                email: email,
                address: address)
  }
}

extension Address {
  static func fixture(road: String = "fix",
                      building: String = "fix") -> Address {
    return Address(road: road,
                   building: building)
  }
}
```
This is much better than creating models inline everytime, but it's a lot of boilerplate code, that needs to be compiled and maintained every time we change our models.

# Usage
## Basic
With Autofixtures all you need to do is comform your model to Decodable (if it doesn't yet), and import Autofixtures
```
import Autofixtures
extension User: Decodable {}

let fixture = User.fix
```

## Setter
To set a value
```
import Autofixtures
extension User: Decodable {}

let fixture = User.fix.set(\.address.road, "Abbey Road")
```
## Customize fixtures
Conform your model to Autofixtures.Override protocol and provide a new default.  
Use .fixDecoded static var to avoid infinite recursion
```
extension User: Override {
  static var fixOverride = User.fixDecoded.set(\.address.road, "Abbey Road")
}
let fixture = User.fix
```
## Enums
CaseIterable enums return first case from .fix, but they need to conform to Override 
```
enum Enum: String, Decodable, CaseIterable {
    case one
    case two
}

extension Enum: Override {}
```
## Enums with associated values
Enums with associated values require to provide override
```
enum EnumWithValue: Decodable, Equatable, Override {
    case value(Simple)

    static let fixOverride: EnumWithValue = .value(.fix)
}
```

## Optionals
Optionals return nil by default.

## Closures
```
/// Closure wrapper for decodable support
struct Closure<A,B>: Decodable {
    var closure: (A) -> B

    init(from decoder: Decoder) throws {
        self.closure = { a in fatalError() }
    }
}

/// Example of setting up default for closure
extension Closure: Override where A == Void, B == Int {
    static var fixOverride: Closure<(), Int> = .fixDecoded
        .set(\.closure, { return 9 })
}
```

# Installation

Swift Package Manager
