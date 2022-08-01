import Foundation

/// Conform type to Override to provide a default value for your fixture
///
/// For example:
/// extension User: Override {
///     static let fixOverride = Self.fixDecoded.set(\.email, "email")
/// }
public protocol Override: Decodable {
    /// Called internally instead of `var fix` when the type conforms to override
    static var fixOverride: Self { get }
}

/// Convinience conformance for CaseIterable Enums
/// - returns first declared case
public extension Override where Self: CaseIterable {
    static var fixOverride: Self {
        guard let first = Self.allCases.first else {
            fatalError("Provide at least one case in \(Self.self).allCases")
        }
        return first
    }
}

public extension Decodable where Self: CaseIterable {
    static var fixDecoded: Self { .allCases.first! }

    static var fix: Self {
        guard let override = self as? Override.Type else {
            return .fixDecoded
        }
        return override.fixOverride as! Self
    }
}

public extension Decodable {
    /// Use this method when you want to create an override for a type
    static var fixDecoded: Self {
        do {
            return try .init(from: FixtureDecoder())
        } catch {
            fatalError(message(Self.self))
        }
    }

    /// Prefer this method for creating fixtures
    static var fix: Self {
        guard let override = self as? Override.Type else {
            return .fixDecoded
        }
        return override.fixOverride as! Self
    }
}

public extension Decodable {
    /// Convinience setter, let you mutate one or more properties without passing other arguments
    /// Make sure that property that you're setting is `var` and not `let` otherwise WritableKeyPath is not available
    func set<Value>(_ kp: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var copy = self
        copy[keyPath: kp] = value
        return copy
    }
}
