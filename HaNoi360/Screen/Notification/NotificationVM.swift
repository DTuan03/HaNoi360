//
//  NotificationVM.swift
//  HaNoi360
//
//  Created by Tuấn on 14/6/25.
//
import RxSwift
import RxCocoa

class NotificationVM: BaseVM {
    var noti = BehaviorRelay<[NotificationModel]>(value: [])
    
    override init() {
        super.init()
        print(userId)
        notiService.fetchWhereEqualTo(field: "userId", value: userId) { result in
            switch result {
            case .success(let noti):
                print(noti.count)
                self.noti.accept(noti)
            case .failure(let error):
                print("Loi")
            }
        }
    }
    
    func updateIsRead(notiId: String) {
        notiService.updateFields(["isRead": true], forId: notiId) { result in
            switch result {
            case .success():
                print("UPDATE OK")
            case .failure(_):
                print("Update loi")
            }
        }
    }
}
