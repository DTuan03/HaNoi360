//
//  RealmHelper.swift
//  HaNoi360
//
//  Created by Tuấn on 3/5/25.
//

import Foundation
import RealmSwift

// sắp xếp
struct SortItem {
    var keyPath = ""
    var ascending = true
    
    init(byKeyPath: String, ascending: Bool = true) {
        self.keyPath = byKeyPath
        self.ascending = ascending
    }
}

// class helper for RealmSwift
@objc class RealmHelper: NSObject {
    
    // MARK: lưu 1 object vào realm database
    static func set<Element: Object>(_ object: Element) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            // entity có primaryKey thì mới set update: true
            if object.objectSchema.primaryKeyProperty != nil {
                realm.add(object, update: .all)
            } else {
                realm.add(object)
            }
            try realm.commitWrite()
        } catch {
            print("\(#file) :: \(#function) :: error occurred: \(error)")
        }
    }
    
    //MARK: lưu 1 mảng object vào realm database
    static func set<Element: Object>(_ objects: [Element]) {
        guard !objects.isEmpty, let firstObject = objects.first else { return }
        do {
            let realm = try Realm()
            try realm.write {
                // entity có primaryKey thì mới set update: true
                if firstObject.objectSchema.primaryKeyProperty != nil {
                    realm.add(objects, update: .all)
                } else {
                    realm.add(objects)
                }
            }
        } catch {
            print("\(#file) :: \(#function) :: error: \(error)")
        }
    }
    
    //MARK: xóa 1 object khỏi realm database
    static func remove<Element: Object>(_ object: Element) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(object)
            try realm.commitWrite()
        } catch {
            print("\(#file) :: \(#function) :: error occurred: \(error)")
        }
    }
    
    //MARK: xóa nhiều object khỏi realm database
    static func remove<Element: Object>(_ objects: [Element]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(objects)
            try realm.commitWrite()
        } catch {
            print("\(#file) :: \(#function) :: error occurred: \(error)")
        }
    }
    
    //MARK: xóa nhiều object theo filter
//    let predicate = NSPredicate(format: "age < 18")
//    RealmHelper.remove(Person.self, filter: predicate)
    static func remove<Element: Object>(_ type: Element.Type, filter: NSPredicate) {
        let results = get(type, filter: filter, detachable: false)
        if results.count > 0 {
            RealmHelper.remove(results.map({ $0 }))
        }
    }
    //MARK: xóa nhiều object theo filter dứoi dạng string, tham số động
//    RealmHelper.remove(Person.self, filter: "age < %@", 18)
    static func remove<Element: Object>(_ type: Element.Type, filter: String, _ args: Any...) {
        let predicate = NSPredicate(format: filter, argumentArray: args.compactMap { $0 })
        self.remove(type, filter: predicate)
    }
    
    //MARK: xóa toàn bộ object kiểu Element
//    RealmHelper.removeAll(Person.self)
    static func removeAll<Element: Object>(_ type: Element.Type) {
        do {
            let realm = try Realm()
            let allObjects = realm.objects(type)
            realm.beginWrite()
            realm.delete(allObjects)
            try realm.commitWrite()
        } catch {
            print("\(#file) :: \(#function) :: error: \(error)")
        }
    }
    
    //MARK: select các objects có kiểu Element
//    let sortItem = SortItem(byKeyPath: "name", ascending: true)
//    let predicate = NSPredicate(format: "age > 20")
//    let people = RealmHelper.get(Person.self, filter: predicate, sort: sortItem)  // Truy vấn và sắp xếp
    static func get<Element: Object>(_ type: Element.Type,
                                     filter: NSPredicate? = nil,
                                     sort: SortItem? = nil,
                                     detachable: Bool = true) -> [Element] {
        do {
            let realm = try Realm()
            var results = realm.objects(type)
            if let filter = filter {
                results = results.filter(filter)
            }
            if let sort = sort {
                results = results.sorted(byKeyPath: sort.keyPath, ascending: sort.ascending)
            }
            return results.map { detachable ? $0.detached() : $0 }
        } catch {
            print("\(#file) :: \(#function) :: error: \(error)")
        }
        return []
    }
    
    //Như trên nhưng filter theo string và tham số động
    //RealmHelper.get(Person.self, filter: "age > %@", filterArgs: [20])
    static func get<Element: Object>(_ type: Element.Type,
                                     filter: String,
                                     filterArgs: [Any]? = nil,
                                     sort: SortItem? = nil,
                                     detachable: Bool = true) -> [Element] {
        let predicate = NSPredicate(format: filter, argumentArray: filterArgs)
        return self.get(type, filter: predicate, sort: sort, detachable: detachable)
    }
    //MARK: Lấy ra đối tượng đầu tiên trong truy vấn
//    let person = RealmHelper.getOne(Person.self, filter: "name == %@", filterArgs: ["John"])
    static func get<Element: Object>(_ type: Element.Type,
                                     filter: String,
                                     sort: SortItem? = nil,
                                     detachable: Bool = true,
                                     _ filterArgs: Any...) -> [Element] {
        let predicate = NSPredicate(format: filter, argumentArray: filterArgs.map { $0 })
        return self.get(type, filter: predicate, sort: sort, detachable: detachable)
    }
    
    //MARK: select first object
    static func getOne<Element: Object>(_ type: Element.Type,
                                        filter: String,
                                        filterArgs: [Any]? = nil,
                                        sort: SortItem? = nil,
                                        detachable: Bool = true) -> Element? {
        let predicate = NSPredicate(format: filter, argumentArray: filterArgs)
        return self.getOne(type, filter: predicate, sort: sort, detachable: detachable)
    }
    
    //MARK: select first object
    static func getOne<Element: Object>(_ type: Element.Type,
                                        filter: String,
                                        sort: SortItem? = nil,
                                        detachable: Bool = true,
                                        _ filterArgs: Any...) -> Element? {
        let predicate = NSPredicate(format: filter, argumentArray: filterArgs.map { $0 })
        return self.getOne(type, filter: predicate, sort: sort, detachable: detachable)
    }
    //MARK: Lấy đối tượng đầu tiên trong kết quả truy vấn (nếu có)
    static func getOne<Element: Object>(_ type: Element.Type,
                                        filter: NSPredicate? = nil,
                                        sort: SortItem? = nil,
                                        detachable: Bool = true) -> Element? {
        let results = get(type, filter: filter, sort: sort)
        if !results.isEmpty {
            return detachable ? results.first!.detached() : results.first!
        }
        return nil
    }
    
    //MARK: đếm số bản ghi của 1 object
    static func count<Element: Object>(_ type: Element.Type, filter: NSPredicate? = nil) -> Int {
        return get(type, filter: filter).count
    }
    
    static func count<Element: Object>(_ type: Element.Type, filter: String, _ filterArgs: Any...) -> Int {
        let predicate = NSPredicate(format: filter, argumentArray: filterArgs.map { $0 })
        return get(type, filter: predicate).count
    }
    
    static func write(code block:() -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                block()
            }
        } catch {
            print("\(#file) :: \(#function) :: write block error: \(error)")
        }
    }
}

extension RealmHelper {
    public static func objects<Element: Object>(_ type: Element.Type) throws -> Results<Element> {
        let realm = try Realm()
        return realm.objects(type)
    }
}
