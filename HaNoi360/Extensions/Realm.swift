//
//  Realm.swift
//  HaNoi360
//
//  Created by Tuấn on 29/5/25.
//

import Foundation
import RealmSwift

protocol DetachableObject: AnyObject {
    func detached() -> Self
}

extension Object: DetachableObject {
    func detached() -> Self {
        let newObj = type(of: self).init()
        var properties = objectSchema.properties
        if let property = objectSchema.primaryKeyProperty {
            properties.append(property)
        }
        for property in properties {
            guard let value = value(forKey: property.name) else { continue }
            if let objDetachable = value as? DetachableObject {
                newObj.setValue(objDetachable.detached(), forKey: property.name)
            } else {
                newObj.setValue(value, forKey: property.name)
            }
        }
        return newObj
    }
}

extension List: DetachableObject {
    func detached() -> List<Element> {
        let result = List<Element>()
        forEach {
            if let detachableObject = $0 as? DetachableObject,
               let element = detachableObject.detached() as? Element {
                result.append(element)
            } else { // Then it is a primitive
                result.append($0)
            }
        }
        return result
    }
}
