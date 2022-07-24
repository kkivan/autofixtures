import Foundation

struct FixtureDecoder: Decoder {
    var codingPath: [CodingKey] = []

    var userInfo: [CodingUserInfoKey : Any] = [:]

    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let allKeys: [Key]
        let codingPath: [CodingKey] = []

        init(decoder: FixtureDecoder) {
            self.allKeys = [.init(stringValue: "FIX")].compactMap { $0 }

        }

        func contains(_ key: Key) -> Bool {
            true
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            true
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            T.fix
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError()
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            fatalError()
        }

        func superDecoder() throws -> Decoder {
            fatalError()
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError()
        }
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return .init(KeyedContainer(decoder: self))
    }

    struct UnkeyedContainer: UnkeyedDecodingContainer {

        mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            currentIndex += 1
            return T.fix
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            fatalError("Not implemented")
        }

        var codingPath: [CodingKey] = []

        var count: Int? = 1

        var isAtEnd: Bool { count == currentIndex }

        var currentIndex: Int = 0

        mutating func decodeNil() throws -> Bool {
            fatalError("Not implemented")
        }

        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError("Not implemented")
        }

        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError("Not implemented")
        }

        mutating func superDecoder() throws -> Decoder {
            fatalError("Not implemented")
        }
    }

    struct SingleValueContainer: SingleValueDecodingContainer {
        var codingPath: [CodingKey] = []

        func decodeNil() -> Bool {
            true
        }

        func decode(_ type: Bool.Type) throws -> Bool {
            true
        }

        func decode(_ type: String.Type) throws -> String { "FIX" }

        func decode(_ type: Double.Type) throws -> Double { 1.1 }

        func decode(_ type: Float.Type) throws -> Float { 1.2 }

        func decode(_ type: Int.Type) throws -> Int { 333 }

        func decode(_ type: Int8.Type) throws -> Int8 { 8 }

        func decode(_ type: Int16.Type) throws -> Int16 { 16 }

        func decode(_ type: Int32.Type) throws -> Int32 { 32 }

        func decode(_ type: Int64.Type) throws -> Int64 { 64 }

        func decode(_ type: UInt.Type) throws -> UInt { 333 }

        func decode(_ type: UInt8.Type) throws -> UInt8 { 111 }

        func decode(_ type: UInt16.Type) throws -> UInt16 { 333 }

        func decode(_ type: UInt32.Type) throws -> UInt32 { 333 }

        func decode(_ type: UInt64.Type) throws -> UInt64 { 333 }

        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            T.fix
        }
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        UnkeyedContainer()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleValueContainer()
    }
}

func message<T>(_ type: T.Type) -> String {
    return """
    ---Override is not provided----
    You see this error because because fixture for \(type) cannot be created
    It's probably an enum type
    If \(type) is CaseIterable declare protocol conformance to get first enum case as a fixture
    ```
    extension \(type): Override {}
    ```
    Otherwise provide an override for fixture
    ```
    extension \(type): Override {
        static var fixOverride: Self = ...create fixture here...
    }
    ```
    """
}
