import XCTest
@testable import Autofixtures

enum Enum: Decodable {
    case one
}

extension Enum: Override {
    static let fix = Enum.one
}

struct Simple: Decodable, Hashable, Equatable {
    let id: Int
    let string: String
    let enumeration: Enum
}

final class AutofixturesTests: XCTestCase {

    func testAtomic() {
        XCTAssertEqual(String.fix, "FIX")
        XCTAssertEqual(Int.fix, 333)
        XCTAssertEqual(Int.fix, 333)
    }

    func testStruct() {
        XCTAssertEqual(Simple.fix.id, Int.fix)
        XCTAssertEqual(Simple.fix.string, String.fix)
    }

    func testNested() {
        struct Nested: Decodable {
            let nested: Simple
        }
        XCTAssertEqual(Nested.fix.nested.id, Int.fix)
        XCTAssertEqual(Nested.fix.nested.string, String.fix)
    }

    func testArrayOfStrings() {
        let decoded = [String].fix
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded[0], String.fix)
    }
    func testArrayOfSimples() {
        let decoded = [Simple].fix
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded.first, Simple.fix)
    }

    func testSetOfSimples() {
        let decoded = Set<Simple>.fix
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded.first, Simple.fix)
    }

    func testGeneric() {
        struct Generic<A: Decodable>: Decodable {
            let a: A
        }
        XCTAssertEqual(Generic<Simple>.fix.a, Simple.fix)
    }

    func testEnum() {
        XCTAssertEqual(Simple.fix.enumeration, .one)
    }

    func testEnumWithAssociatedValue() {
        enum EnumWithValue: Override, Equatable {
            case value(Simple)

            static let fix = EnumWithValue.value(.fix)
        }

        XCTAssertEqual(EnumWithValue.fix, .value(.fix))
    }

    func testOptional() {
        XCTAssertEqual(Optional<Simple>.fix, nil)
    }

    func testStringDictionary() {
        XCTAssertEqual([String: String].fix, [.fix: .fix])
        XCTAssertEqual([String: Simple].fix, [.fix: .fix])
    }

    func testProp() {
        struct Auto: Decodable {
            var name: String
        }
        let fix = Auto.fix
            .prop(\.name, "updated")
        XCTAssertEqual(fix.name, "updated")
    }

    func testClosure() {
        struct WithClosure: Decodable {
            let closure: Closure<Void, Void>
        }
        XCTAssertNotNil(WithClosure.fix)
    }

    func testClosureWithOverridenValue() {
        struct WithClosure: Decodable {
            let closure: Closure<Void, Int>
        }
        XCTAssertEqual(WithClosure.fix.closure.closure(()), 9)
    }
}

/// Closure wrapper for decodable support
struct Closure<A,B>: Decodable {
    var closure: (A) -> B

    init(from decoder: Decoder) throws {
        self.closure = { a in fatalError() }
    }
}

/// Example of setting up default for closure
extension Closure: Override where A == Void, B == Int {
    static var fix: Closure<(), Int> = .fix
        .prop(\.closure, { return 9 })
}
