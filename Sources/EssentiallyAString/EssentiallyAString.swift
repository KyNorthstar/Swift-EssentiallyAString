//
//  EssentiallyAString.swift
//  SpecialString
//
//  Created by Ben Leggiero on 2019-10-02.
//

import Foundation



/// Any type which is technically not a string, but is essentially a string.
///
/// This works by conforming to ``StingProtocol`` and a couple others, and synthesizing as much of that as possible on its own so you don't have to implement it.
///
/// This protocol synthesizes everything _except_ the `rawValue` initializer and variable. Those are what allows the rest to be synthesized for you, assuming `rawValue` can be quickly and easily accessed.
///
/// If you need specialized implementations of any of this protocol's requirements, you're encouraged to implement those requirements yourself.
public protocol EssentiallyAString:
    StringProtocol,
    MutableRawRepresentable,
    Codable
where
    RawValue == String,
    
    StringLiteralType == String.StringLiteralType,
    StringInterpolation == String.StringInterpolation,
    UnicodeScalarLiteralType == String.UnicodeScalarLiteralType,
    ExtendedGraphemeClusterLiteralType == String.ExtendedGraphemeClusterLiteralType,
    
    UTF8View == String.UTF8View,
    UTF16View == String.UTF16View,
    UnicodeScalarView == String.UnicodeScalarView,
    SubSequence == String.SubSequence,
    
    Element == String.Element,
    Index == String.Index,
    Indices == String.Indices
{
    init(rawValue: String)
}



// MARK: - ExpressibleByStringLiteral

public extension EssentiallyAString {
    
    @inline(__always)
    init(stringLiteral value: Self.StringLiteralType) {
        self.init(rawValue: value)
    }
}



// MARK: - CustomStringConvertible

public extension EssentiallyAString {
    
    @inline(__always)
    var description: String { rawValue }
}



// MARK: - Hashable

public extension EssentiallyAString {
    
    @inline(__always)
    func hash(into hasher: inout Hasher) {
        rawValue.hash(into: &hasher)
    }
}



// MARK: - Equatable

public extension EssentiallyAString {
    
    @inline(__always)
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}



// MARK: - Decodable

public extension EssentiallyAString {
    
    @inline(__always)
    init(from decoder: any Decoder) throws {
        try self.init(rawValue: .init(from: decoder))
    }
}



// MARK: - Encodable

public extension EssentiallyAString {
    
    @inline(__always)
    func encode(to encoder: any Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}



// MARK: - StringProtocol

public extension EssentiallyAString {
    
    @inline(__always)
    var utf8: String.UTF8View {
        rawValue.utf8
    }
    
    @inline(__always)
    var utf16: String.UTF16View {
        rawValue.utf16
    }
    
    @inline(__always)
    var unicodeScalars: String.UnicodeScalarView {
        rawValue.unicodeScalars
    }
    
    
    @inline(__always)
    func hasPrefix(_ prefix: String) -> Bool {
        rawValue.hasPrefix(prefix)
    }
    
    
    @inline(__always)
    func hasSuffix(_ suffix: String) -> Bool {
        rawValue.hasSuffix(suffix)
    }
    
    
    @inline(__always)
    func lowercased() -> String {
        rawValue.lowercased()
    }
    
    
    @inline(__always)
    func uppercased() -> String {
        rawValue.uppercased()
    }
    
    
    @inline(__always)
    init<C, Encoding>(decoding codeUnits: C, as sourceEncoding: Encoding.Type) where C : Collection, Encoding : _UnicodeEncoding, C.Element == Encoding.CodeUnit {
        self.init(rawValue: .init(decoding: codeUnits, as: sourceEncoding))
    }
    
    
    @inline(__always)
    init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
        self.init(rawValue: .init(cString: nullTerminatedUTF8))
    }
    
    
    @inline(__always)
    init<Encoding>(decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>, as sourceEncoding: Encoding.Type) where Encoding : _UnicodeEncoding {
        self.init(rawValue: .init(decodingCString: nullTerminatedCodeUnits, as: sourceEncoding))
    }
    
    
    @inline(__always)
    func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
        try rawValue.withCString(body)
    }
    
    
    @inline(__always)
    func withCString<Result, Encoding>(encodedAs targetEncoding: Encoding.Type, _ body: (UnsafePointer<Encoding.CodeUnit>) throws -> Result) rethrows -> Result where Encoding : _UnicodeEncoding {
        try rawValue.withCString(encodedAs: targetEncoding, body)
    }
}



// MARK: - BidirectionalCollection

public extension EssentiallyAString {
    
    @inline(__always)
    func index(before i: String.Index) -> String.Index {
        rawValue.index(before: i)
    }
    
    
    @inline(__always)
    func formIndex(before i: inout String.Index) {
        rawValue.formIndex(before: &i)
    }
    
    
    @inline(__always)
    func index(after i: String.Index) -> String.Index {
        rawValue.index(after: i)
    }
    
    
    @inline(__always)
    func formIndex(after i: inout String.Index) {
        rawValue.formIndex(after: &i)
    }
    
    
    @inline(__always)
    func index(_ i: String.Index, offsetBy distance: Int) -> String.Index {
        rawValue.index(i, offsetBy: distance)
    }
    
    
    @inline(__always)
    func index(_ i: String.Index, offsetBy distance: Int, limitedBy limit: String.Index) -> String.Index? {
        rawValue.index(i, offsetBy: distance, limitedBy: limit)
    }
    
    
    @inline(__always)
    func distance(from start: String.Index, to end: String.Index) -> Int {
        rawValue.distance(from: start, to: end)
    }
    
    
    @inline(__always)
    var indices: String.Indices {
        rawValue.indices
    }
    
    
    @inline(__always)
    subscript(bounds: Range<String.Index>) -> String.SubSequence {
        rawValue[bounds]
    }
    
    
    @inline(__always)
    subscript(position: String.Index) -> String.Element {
        rawValue[position]
    }
    
    
    @inline(__always)
    var startIndex: String.Index {
        rawValue.startIndex
    }
    
    
    @inline(__always)
    var endIndex: String.Index {
        rawValue.endIndex
    }
}



// MARK: - Comparable

public extension EssentiallyAString {
    
    @inline(__always)
    static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}



// MARK: - ExpressibleByStringInterpolation

public extension EssentiallyAString {
    
    @inline(__always)
    init(stringInterpolation: DefaultStringInterpolation) {
        self.init(rawValue: .init(stringInterpolation: stringInterpolation))
    }
}



// MARK: - LosslessStringConvertible

public extension EssentiallyAString {
    
    @inline(__always)
    init(_ description: String) {
        self.init(rawValue: description)
    }
}



// MARK: - TextOutputStream

public extension EssentiallyAString {
    
    @inline(__always)
    mutating func write(_ string: String) {
        rawValue.write(string)
    }
}



// MARK: - TextOutputStreamable

public extension EssentiallyAString {
    
    @inline(__always)
    func write<Target>(to target: inout Target) where Target : TextOutputStream {
        rawValue.write(to: &target)
    }
}
