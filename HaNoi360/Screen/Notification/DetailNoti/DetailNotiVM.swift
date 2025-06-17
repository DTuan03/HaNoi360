//
//  DetailNotiVM.swift
//  HaNoi360
//
//  Created by Tuấn on 15/6/25.
//

import RxSwift
import RxCocoa
import FirebaseFirestore


class DetailNotiVM: BaseVM {
    var noti = BehaviorRelay<NotificationModel?>(value: nil)
    
    func getDetailNoti(notiId: String, completion: @escaping () -> Void) {
        notiService.fetchWhereEqualTo(field: "notificationId", value: notiId) { result in
            switch result {
            case .success(let noti):
                self.noti.accept(noti[0])
            case .failure(let error):
                print("Loi")
            }
            completion()
        }
    }
}
