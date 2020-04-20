//
//  Wrap.swift
//
//  Created by ALI KIRAN on 15.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
@dynamicMemberLookup
public enum Wrap {
    case null
    case float(Double)
    case int(Int)
    case bool(Bool)
    case string(String)
    case array([Wrap])
    case dictionary([String: Wrap])
    
    public init?(usingJSON string: String) {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        
        guard let wrap = Wrap(object) else {
            return nil
        }
        
        self = wrap
    }
    
    public init?(_ value: Any) {
        guard let wrap = Wrap.parse(value: value) else {
            return nil
        }
        
        self = wrap
    }
    
    public init(from array: [Any]) {
        self = .array(array.compactMap({ Wrap.parse(value: $0) }))
    }
    
    public init(from dictionary: [String: Any]) {
        var parsed: [String: Wrap] = [:]
        
        for (key, value) in dictionary {
            parsed[key] = Wrap.parse(value: value)
        }
        
        self = Wrap.dictionary(parsed)
    }
}

extension Wrap: Equatable {}

public extension Wrap {
    var count: Int {
        switch self {
        case .null:
            fallthrough
        case .bool:
            fallthrough
        case .float:
            fallthrough
        case .int:
            fallthrough
        case .string:
            return 1
            
        case let .array(array):
            return array.count
            
        case let .dictionary(dict):
            return dict.count
        }
    }
    
    var first: Wrap? {
        switch self {
        case .null:
            fallthrough
        case .bool:
            fallthrough
        case .float:
            fallthrough
        case .int:
            fallthrough
        case .string:
            return self
            
        case let .array(array):
            return array.first
            
        case let .dictionary(dict):
            return dict.first?.value
        }
    }
    
    var last: Wrap? {
        switch self {
        case .null:
            fallthrough
        case .bool:
            fallthrough
        case .float:
            fallthrough
        case .int:
            fallthrough
        case .string:
            return self
            
        case let .array(arr):
            return arr.last
            
        case let .dictionary(dict):
            return dict.enumerated().reversed().first?.element.value
        }
    }
    
    var string: String? {
        if case let .string(str) = self {
            return str
        }
        return nil
    }
    
    var float: Double? {
        if case let .float(value) = self {
            return value
        }
        return nil
    }
    
    var int: Int? {
        if case let .int(value) = self {
            return value
        }
        return nil
    }
    
    var bool: Bool? {
        if case let .bool(value) = self {
            return value
        }
        return nil
    }
    
    subscript(index: Int) -> Wrap? {
        if case let .array(arr) = self {
            return index < arr.count ? arr[index] : nil
        }
        return nil
    }
    
    subscript(index: Int) -> Wrap {
        if case let .array(arr) = self {
            return index < arr.count ? arr[index] : .null
        }
        
        return .null
    }
    
    subscript(key: String) -> Wrap? {
        if case let .dictionary(dict) = self {
            return dict[key]
        }
        return nil
    }
    
    subscript(key: String) -> Wrap {
        if case let .dictionary(dict) = self {
            return dict[key] ?? .null
        }
        return .null
    }
    
    subscript(dynamicMember member: String) -> Wrap? {
        if case let .dictionary(dict) = self {
            return dict[member]
        }
        return nil
    }
    
    subscript(dynamicMember member: String) -> Wrap {
        if case let .dictionary(dict) = self {
            return dict[member] ?? .null
        }
        
        return .null
    }
}

private extension Wrap {
    static func parse(value: Any) -> Wrap? {
        if let string = value as? String {
            return Wrap.string(string)
        }
        
        if let number = value as? NSNumber {
            if number.isInt {
                return Wrap.int(number.intValue)
            }
            
            if number.isDouble {
                return Wrap.float(number.doubleValue)
            }
            
            if number.isBool {
                return Wrap.bool(number.boolValue)
            }
        }
        
        if let bool = value as? Bool {
            return Wrap.bool(bool)
        }
        
        if let dict = value as? [String: Any] {
            return Wrap(from: dict)
        }
        
        if let arr = value as? [Any] {
            return Wrap(from: arr)
        }
        
        return nil
    }
}

extension Wrap: Swift.ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)!
    }
}

extension Wrap: Swift.ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)!
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)!
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)!
    }
}

extension Wrap: Swift.ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)!
    }
}

extension Wrap: Swift.ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)!
    }
}

extension Wrap: Swift.ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Any)...) {
        let dictionary = elements.reduce(into: [String: Any](), { $0[$1.0] = $1.1 })
        self.init(from: dictionary)
    }
}

extension Wrap: Swift.ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Any...) {
        self.init(from: elements)
    }
}

extension NSNumber {
    var isBool: Bool {
        let boolID = CFBooleanGetTypeID() // the type ID of CFBoolean
        let numID = CFGetTypeID(self) // the type ID of num
        return numID == boolID
    }
    
    var isDouble: Bool {
        return CFNumberIsFloatType(self as CFNumber)
    }
    
    var isInt: Bool {
        return CFNumberGetType(self as CFNumber).isIntegral
    }
}

extension CFNumberType {
    var isIntegral: Bool {
        let raw = rawValue
        return (raw >= CFNumberType.sInt8Type.rawValue && raw <= CFNumberType.sInt64Type.rawValue)
            || raw == CFNumberType.nsIntegerType.rawValue
            || raw == CFNumberType.longType.rawValue
            || raw == CFNumberType.longLongType.rawValue
    }
}
