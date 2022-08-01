import Foundation

public enum ExampleType: Decodable, CaseIterable {
  case one
  case two
}

public struct Model: Decodable {
    public let type: ExampleType
    public let string: String
    private let privateProp: ExampleType
    public init(type: ExampleType,
                string: String,
                privateProp: ExampleType) {
        self.type = type
        self.string = string
        self.privateProp = privateProp
    }
}
