//
//  MutableRawRepresentable.swift
//  EssentiallyAString
//
//  Created by Ky on 2026-10-10.
//

import Foundation



/// A ``RawRepresentable`` which guarantees that its raw value can be changed
public protocol MutableRawRepresentable: RawRepresentable {
    var rawValue: Self.RawValue { get set }
}
