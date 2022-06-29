import Foundation

public protocol Autofixture: Decodable {
    static var fix: Self { get }
}

public extension Autofixture {
    static var fix: Self { try! Self(from: FixtureDecoder()) }
}

extension Decodable {
    /// Make sure that property that you're setting is `var` and not `let` otherwise WritableKeyPath is not available
    func prop<Value>(_ kp: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var copy = self
        copy[keyPath: kp] = value
        return copy
    }
}

// How to make custom fixtures
//struct User: Autofixture {
//    let id: Int
//    var email: String
//
//    static let fix = Self.fix.prop(\.email, "email")
//}
