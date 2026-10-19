//
//  EssentiallyAString + Comparable Tests.swift
//  EssentiallyAString
//
//  Created by Ky on 2026-10-18.
//  Some code written by directing Claude Sonnet 5.5
//

import Testing
import EssentiallyAString



@Suite("Comparable")
struct EssentiallyAStringComparableTests {
    
    @Test
    // 9 < 10 numerically, though "9" > "10" as text
    func testAllComparisonOperatorsFollowTheConformersLessThan() {
        let nine = NumericAware(rawValue: "9"), ten = NumericAware(rawValue: "10")
        
        #expect((lt: false,      gt: false,      lte: true,        gte: true,        eq: true,        neq: false) == allComparisonOperators(nine, nine))
        #expect((lt: true,       gt: false,      lte: true,        gte: false,       eq: false,       neq: true)  == allComparisonOperators(nine, ten))
        #expect((lt: false,      gt: true,       lte: false,       gte: true,        eq: false,       neq: true)  == allComparisonOperators(ten, nine))
        #expect((lt: false,      gt: false,      lte: true,        gte: true,        eq: true,        neq: false) == allComparisonOperators(ten, ten))
        
        #expect((lt: true,       gt: false,      lte: true,        gte: false,       eq: false,       neq: true)
             == (lt: nine < ten, gt: nine > ten, lte: nine <= ten, gte: nine >= ten, eq: nine == ten, neq: nine != ten))
    }
    
    
    
    // MARK: Opposite order
    
    /// Orders opposite to its text, so any operator which compares `rawValue` instead of using this `<` is wrong for every pair of different strings
    private struct Reversed: EssentiallyAString {
        var rawValue: String
        init(rawValue: String) { self.rawValue = rawValue }
        
        static func < (lhs: Reversed, rhs: Reversed) -> Bool { rhs.rawValue < lhs.rawValue }
    }
    
    
    @Test(arguments: comparisonStrings, comparisonStrings)
    func testOppositeOrderConformerFollowsItsLessThanOnEveryPair(_ lhsText: String, _ rhsText: String) {
        let lhs = Reversed(rawValue: lhsText), rhs = Reversed(rawValue: rhsText)
        
        // `<` is reversed, so `lhs < rhs` means `lhsText > rhsText`. Equality is still the text's
        let expected: AllComparisonResults = (
            lt:  lhsText >  rhsText,
            gt:  lhsText <  rhsText,
            lte: lhsText >= rhsText,
            gte: lhsText <= rhsText,
            eq:  lhsText == rhsText,
            neq: lhsText != rhsText,
        )
        
        #expect(expected == allComparisonOperators(lhs, rhs))
        #expect(expected == allEssentiallyAStringOperators(lhs, rhs))
        #expect(expected == (lt: lhs < rhs, gt: lhs > rhs, lte: lhs <= rhs, gte: lhs >= rhs, eq: lhs == rhs, neq: lhs != rhs))
    }
    
    
    
    // MARK: Things built on the operators
    
    @Test
    func testSortingAndRangesFollowTheConformersLessThan() {
        let two = NumericAware(rawValue: "2"), nine = NumericAware(rawValue: "9"), ten = NumericAware(rawValue: "10"), twenty = NumericAware(rawValue: "20"), hundred = NumericAware(rawValue: "100")
        let unsorted = [ten, hundred, two, twenty, nine]
        
        #expect([two, nine, ten, twenty, hundred] == unsorted.sorted())
        #expect([hundred, twenty, ten, nine, two] == unsorted.sorted(by: >))
        #expect(hundred == unsorted.max())
        #expect(two == unsorted.min())
        
        // `ClosedRange.contains` uses `<=` on both ends. As text, "20" > "100"
        #expect((ten...hundred).contains(twenty))
        #expect(false == (ten...hundred).contains(nine))
        #expect(false == (ten...twenty).contains(hundred))
    }
    
    
    
    // MARK: The shape SemVer's identifiers have
    
    /// Generic, with its `EssentiallyAString` conformance conditional. This is how `SemVer.Identifier` is declared.
    ///
    /// At the time this was written, a conformer shaped like this did not show the bug even with the old overrides in place, so this
    /// guards against the compiler resolving it differently later
    @Test(arguments: comparisonStrings, comparisonStrings)
    func testConditionallyConformingGenericFollowsItsLessThan(_ lhsText: String, _ rhsText: String) {
        let lhs = Tagged<Mark>(rawValue: lhsText), rhs = Tagged<Mark>(rawValue: rhsText)
        
        // Same reversal as above
        let expected: AllComparisonResults = (
            lt:  lhsText >  rhsText,
            gt:  lhsText <  rhsText,
            lte: lhsText >= rhsText,
            gte: lhsText <= rhsText,
            eq:  lhsText == rhsText,
            neq: lhsText != rhsText,
        )
        
        #expect(expected == allComparisonOperators(lhs, rhs))
        #expect(expected == allEssentiallyAStringOperators(lhs, rhs))
        #expect(expected == (lt: lhs < rhs, gt: lhs > rhs, lte: lhs <= rhs, gte: lhs >= rhs, eq: lhs == rhs, neq: lhs != rhs))
    }
}



// MARK: - Utilities

private let comparisonStrings = ["", "a", "b", "B", "ab", "9", "10", "100", "é"]



private protocol Marker {}
private enum Mark: Marker {}



private struct Tagged<Tag> {
    var rawValue: String
}



extension Tagged: Equatable {}
extension Tagged: Hashable {}
extension Tagged: Codable {}



extension Tagged: Comparable {
    static func < (lhs: Tagged, rhs: Tagged) -> Bool { rhs.rawValue < lhs.rawValue }
}



extension Tagged: CustomStringConvertible {
    var description: String { rawValue }
}



extension Tagged: EssentiallyAString,
                  StringProtocol,
                  BidirectionalCollection,
                  Collection,
                  Sequence,
                  ExpressibleByStringInterpolation,
                  ExpressibleByStringLiteral,
                  ExpressibleByExtendedGraphemeClusterLiteral,
                  ExpressibleByUnicodeScalarLiteral,
                  LosslessStringConvertible,
                  TextOutputStream,
                  TextOutputStreamable,
                  MutableRawRepresentable,
                  RawRepresentable
where Tag: Marker
{
    init(rawValue: String) { self.rawValue = rawValue }
}



private func allComparisonOperators<Value: Comparable>(_ lhs: Value, _ rhs: Value) -> AllComparisonResults {
    (
        lt:  lhs <  rhs,
        gt:  lhs >  rhs,
        lte: lhs <= rhs,
        gte: lhs >= rhs,
        eq:  lhs == rhs,
        neq: lhs != rhs,
    )
}


private func allEssentiallyAStringOperators<Value: EssentiallyAString>(_ lhs: Value, _ rhs: Value) -> AllComparisonResults {
    (
        lt:  lhs <  rhs,
        gt:  lhs >  rhs,
        lte: lhs <= rhs,
        gte: lhs >= rhs,
        eq:  lhs == rhs,
        neq: lhs != rhs,
    )
}



/// Orders by number when both are numbers, like `SemVer.Identifier.<`
private struct NumericAware: EssentiallyAString {
    var rawValue: String
    init(rawValue: String) { self.rawValue = rawValue }
    
    static func < (lhs: NumericAware, rhs: NumericAware) -> Bool {
        if let lhsNumber = UInt(lhs.rawValue), let rhsNumber = UInt(rhs.rawValue) { return lhsNumber < rhsNumber }
        return lhs.rawValue < rhs.rawValue
    }
}



/// All the results of comparison operators
private typealias AllComparisonResults = (
    lt:  Bool,
    gt:  Bool,
    lte: Bool,
    gte: Bool,
    eq:  Bool,
    neq: Bool,
)
