import Foundation

// MARK: - Input Parsing
// Credit: https://github.com/Frugghi/Advent-of-Code-2021
@dynamicMemberLookup
public struct Input {
    public let fileName: String

    public init(fileName: String) {
        self.fileName = fileName
    }

    public func load<T>(
        as type: [T].Type,
        separators: Set<Character> = ["\n"],
        bundle: Bundle = .main
    ) throws -> [T] where T: LosslessStringConvertible {
        guard let url = bundle.url(forResource: fileName, withExtension: "txt") else {
            throw URLError(.fileDoesNotExist)
        }
        
        return try String(contentsOf: url)
            .split(omittingEmptySubsequences: false, whereSeparator: separators.contains)
            .map(String.init)
            .map { string -> T in
                guard let value = T(string) else {
                    throw URLError(.cannotParseResponse)
                }

                return value
            }
    }

    public static subscript(dynamicMember member: String) -> Input {
        return .init(fileName: "\(member)")
    }
}

// MARK: - String Indexing
public extension String {
    subscript(_ i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
