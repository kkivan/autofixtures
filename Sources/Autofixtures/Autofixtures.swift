import Foundation

public protocol Override: Decodable {
    static var fix: Self { get }
}

public extension Decodable {
    static var fix: Self {
        guard let override = Self.self as? Override.Type else {
            return try! Self(from: FixtureDecoder())
        }
        return override.fix as! Self
    }
}

public extension Decodable {
    /// Make sure that property that you're setting is `var` and not `let` otherwise WritableKeyPath is not available
    func prop<Value>(_ kp: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var copy = self
        copy[keyPath: kp] = value
        return copy
    }
}

// How to make custom fixtures
//extension User: Override {
//    static let fix = Self.fix.prop(\.email, "email")
//}
