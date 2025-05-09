//
//  Firebase.swift
//  HaNoi360
//
//  Created by Tuấn on 15/4/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class BaseFirestoreService<T: Codable> {
    private let collection: CollectionReference

    init(collectionPath: String) {
        self.collection = Firestore.firestore().collection(collectionPath)
    }

    // Thêm mới 1 document (tự tạo ID)
    func add(_ item: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try collection.addDocument(from: item) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // Thêm hoặc cập nhật theo ID
    func set(_ item: T, withId id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try collection.document(id).setData(from: item) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // Lấy toàn bộ
    func fetchAll(completion: @escaping (Result<[T], Error>) -> Void) {
        collection.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let items = snapshot.documents.compactMap { doc -> T? in
                    try? doc.data(as: T.self)
                }
                completion(.success(items))
            }
        }
    }
    
    //Lay theo 1 dieu kien
    func fetchWhereEqualTo(field: String, value: Any, completion: @escaping (Result<[T], Error>) -> Void) {
        collection.whereField(field, isEqualTo: value)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let items = snapshot.documents.compactMap { doc in
                        try? doc.data(as: T.self)
                    }
                    completion(.success(items))
                }
            }
    }
    
    //Lay theo nhieu dieu kien
    func fetchDocumentsByFields(fields: [String: Any], completion: @escaping (Result<[T], Error>) -> Void) {
        var query: Query = collection
        
        // Duyệt qua dictionary của các trường và giá trị
        for (field, value) in fields {
            query = query.whereField(field, isEqualTo: value)
        }
        
        // Thực hiện truy vấn
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))  // Nếu có lỗi thì trả về lỗi
            } else if let snapshot = snapshot {
                // Chuyển dữ liệu từ snapshot thành mảng các đối tượng T
                let items = snapshot.documents.compactMap { doc in
                    try? doc.data(as: T.self)
                }
                completion(.success(items))  // Trả về các đối tượng thành công
            }
        }
    }

    // Xóa
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        collection.document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Lay theo the loai
    func fetchByCategory(_ category: String, completion: @escaping (Result<[T], Error>) -> Void) {
        collection.whereField("category", arrayContains: category)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                do {
                    let results: [T] = try documents.map { try $0.data(as: T.self) }
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    func fetchTopRatedPlaces(limit: Int = 4, completion: @escaping (Result<[T], Error>) -> Void) {
        collection
            .order(by: "avgRating", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                do {
                    let results: [T] = try documents.map { try $0.data(as: T.self) }
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            }
    }


}
