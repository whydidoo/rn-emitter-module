//
//  AnyValueConverter.swift
//  Pods
//
//  Created by amir.saifutdinov on 12/07/2025.
//

import Foundation
import NitroModules

struct AnyValueConverter {
    static func convert(_ value: Any) -> AnyValue {
        switch value {
            case is NSNull:
                return .null
            case let number as NSNumber:
                if CFNumberGetType(number) == .charType {
                    return .bool(number.boolValue)
                } else if CFNumberGetType(number) == .longLongType {
                    return .bigint(number.int64Value)
                } else {
                    return .number(number.doubleValue)
                }
            case let string as String:
                return .string(string)
            case let dict as [String: Any]:
                let convertedDict = dict.mapValues { convert($0) }
                return .object(convertedDict)
            case let array as [Any]:
                let convertedArray = array.map { convert($0) }
                return .array(convertedArray)
            default:
                return .null
        }
    }

    static func createMapHolder(from raw: [String: Any]) -> AnyMapHolder {
        let holder = AnyMapHolder()

        for (key, value) in raw {
            let anyValue = convert(value)
            
            switch anyValue {
                case .null:
                    holder.setNull(key: key)
                case .bool(let b):
                    holder.setBoolean(key: key, value: b)
                case .number(let n):
                    holder.setDouble(key: key, value: n)
                case .bigint(let i):
                    holder.setBigInt(key: key, value: i)
                case .string(let s):
                    holder.setString(key: key, value: s)
                case .array(let array):
                    holder.setArray(key: key, value: array)
                case .object(let obj):
                    holder.setObject(key: key, value: obj)
            }
        }

        return holder
    }
}
