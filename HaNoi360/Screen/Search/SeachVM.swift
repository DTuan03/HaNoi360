//
//  SeachVM.swift
//  HaNoi360
//
//  Created by Tuấn on 18/5/25.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

class SeachVM: BaseVM {
    var recentSearch = BehaviorRelay<[SearchModel]?>(value: nil)
    var keyWord = BehaviorRelay<String?>(value: nil)
        
    func search(completion: @escaping (Result<[BlogPost], Error>) -> Void) {
        blogService.fetchWhereArrayContains(field: "keyword", value: keyWord.value?.lowercased() ?? "") { result in
            switch result {
            case .success(let blogs):
                completion(.success(blogs))
            case .failure(let error):
                completion(.failure(error))
                print("loi")
            }
        }
    }
    
    func getRecentSearch() {
        let predicate = NSPredicate(format: "userId == %@", self.userId)
        let sortItem = SortItem(byKeyPath: "createAt", ascending: false)
        let recentSearch = RealmHelper.get(SearchModel.self, filter: predicate, sort: sortItem)
        self.recentSearch.accept(recentSearch)
    }
    
    func saveSearch(for model: SearchModel) {
        RealmHelper.set(model)
    }
    
    func deleteRecentSearch(searchId: String) {
        let predicate = NSPredicate(format: "userId == %@ AND searchId == %@", userId, searchId)
        RealmHelper.remove(SearchModel.self, filter: predicate)
    }
}

extension String {
    var normalized: String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
                    .lowercased()
                    .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
