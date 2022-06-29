import XCTest
@testable import Autofixtures

struct Simple: Decodable, Hashable, Equatable {
    let id: Int
    let string: String
}

extension Decodable {
    /// This method is for testing cases when type doesn't comform to Autofixture, use static var fix in your test code
    static var decoded: Self { try! Self(from: FixtureDecoder()) }
}

final class AutofixturesTests: XCTestCase {

    func testAtomic() {
        XCTAssertEqual(String.decoded, "FIX")
        XCTAssertEqual(Int.decoded, 333)
        XCTAssertEqual(Int.decoded, 333)
    }

    func testStruct() {
        XCTAssertEqual(Simple.decoded.id, Int.decoded)
        XCTAssertEqual(Simple.decoded.string, String.decoded)
    }

    func testNested() {
        struct Nested: Decodable {
            let nested: Simple
        }
        XCTAssertEqual(Nested.decoded.nested.id, Int.decoded)
        XCTAssertEqual(Nested.decoded.nested.string, String.decoded)
    }

    func testArrayOfStrings() {
        let decoded = [String].decoded
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded[0], String.decoded)
    }
    func testArrayOfSimples() {
        let decoded = [Simple].decoded
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded.first, Simple.decoded)
    }

    func testSetOfSimples() {
        let decoded = Set<Simple>.decoded
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded.first, Simple.decoded)
    }

    func testGeneric() {
        struct Generic<A: Decodable>: Decodable {
            let a: A
        }
        XCTAssertEqual(Generic<Simple>.decoded.a, Simple.decoded)
    }

    func testEnum() {
        enum Enum: Autofixture {
            case one

            static var fix = Enum.one
        }

        XCTAssertEqual(Enum.fix, .one)
    }

    func testEnumWithAssociatedValue() {
        enum EnumWithValue: Autofixture, Equatable {
            case value(Simple)

            static var fix = EnumWithValue.value(.decoded)
        }

        XCTAssertEqual(EnumWithValue.fix, .value(.decoded))
    }

    func testOptional() {
        XCTAssertEqual(Optional<Simple>.decoded, nil)
    }

    func testStringDictionary() {
        XCTAssertEqual([String: String].decoded, [.decoded: .decoded])
        XCTAssertEqual([String: Simple].decoded, [.decoded: .decoded])
    }

    func testProp() {
        struct Auto: Autofixture {
            var name: String
        }
        let fix = Auto.fix
            .prop(\.name, "updated")
        XCTAssertEqual(fix.name, "updated")
    }
}
