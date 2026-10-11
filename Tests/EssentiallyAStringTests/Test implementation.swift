//
//  Test implementation.swift
//  EssentiallyAString
//
//  Created by Ky on 2026-10-08.
//

import Foundation
import EssentiallyAString



public struct TestString: EssentiallyAString {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
