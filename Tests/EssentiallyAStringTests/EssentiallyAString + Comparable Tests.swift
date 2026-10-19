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
    
    /// Orders by number when both are numbers, like `SemVer.Identifier.<`
    private struct NumericAware: EssentiallyAString {
        var rawValue: String
        init(rawValue: String) { self.rawValue = rawValue }
        
        static func < (lhs: NumericAware, rhs: NumericAware) -> Bool {
            if let lhsNumber = UInt(lhs.rawValue), let rhsNumber = UInt(rhs.rawValue) { return lhsNumber < rhsNumber }
            return lhs.rawValue < rhs.rawValue
        }
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
    
    
    @Test
    // 9 < 10 numerically, though "9" > "10" as text
    func testAllComparisonOperatorsFollowTheConformersLessThan() {
        let nine = NumericAware(rawValue: "9"), ten = NumericAware(rawValue: "10")
        
        #expect((lt: false, gt: false, lte: true, gte: true, eq: true, neq: false) == allComparisonOperators(nine, nine))
        #expect((lt: true, gt: false, lte: true, gte: false, eq: false, neq: true) == allComparisonOperators(nine, ten))
        #expect((lt: false, gt: true, lte: false, gte: true, eq: false, neq: true) == allComparisonOperators(ten, nine))
        #expect((lt: false, gt: false, lte: true, gte: true, eq: true, neq: false) == allComparisonOperators(ten, ten))
        
        #expect((lt: true, gt: false, lte: true, gte: false, eq: false, neq: true) == (nine < ten, nine > ten, nine <= ten, nine >= ten, nine == ten, nine != ten))
    }
    
    
    
    typealias AllComparisonResults = (
        lt: Bool,
        gt: Bool,
        lte: Bool,
        gte: Bool,
        eq: Bool,
        neq: Bool,
    )
}
