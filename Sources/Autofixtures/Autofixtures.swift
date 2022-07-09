import Foundation

/// Conform type to Override to provide a default value for your fixture
///
/// For example:
/// extension User: Override {
///     static let fixOverride = Self.fixDecoded.set(\.email, "email")
/// }

public protocol Override: Decodable {
    static var fixOverride: Self { get }
}

extension Override where Self: CaseIterable {
    static var fixOverride: Self { Self.allCases.first! }
}

public extension Decodable {
    static var fixDecoded: Self {
        try! .init(from: FixtureDecoder())
    }

    static var fix: Self {
        guard let override = self as? Override.Type else {
            return .fixDecoded
        }
        return override.fixOverride as! Self
    }
}

public extension Decodable {
    /// Make sure that property that you're setting is `var` and not `let` otherwise WritableKeyPath is not available
    func set<Value>(_ kp: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var copy = self
        copy[keyPath: kp] = value
        return copy
    }
}
