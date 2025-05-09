//
//  CalendarVM.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import RxSwift
import RxCocoa

class CalendarVM: BaseVM {
    var placeCalendar = BehaviorRelay<[AddCalendarModel]?>(value: nil)
    var date = BehaviorRelay<String?>(value: nil)
    
    func featchPlace() {
        let fields = [
            "date": date.value ?? "",
            "userId": userId ?? ""
        ] as [String : Any]
        
        calendarService.fetchDocumentsByFields(fields: fields as [String : Any]) { result in
            switch result {
            case .success(let places):
                self.placeCalendar.accept(places)
            case .failure(let error):
                print("error")
            }
        }
    }
}
