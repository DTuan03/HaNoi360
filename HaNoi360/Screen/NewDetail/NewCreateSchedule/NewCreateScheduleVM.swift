//
//  NewCreateScheduleVM.swift
//  HaNoi360
//
//  Created by Tuấn on 29/5/25.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

class NewCreateScheduleVM: BaseVM {
    var calendarPlace = BehaviorRelay<[NewCreateScheduleModel]?>(value: nil)
    
    var plannedPlaces = BehaviorRelay<NewCreateScheduleModel?>(value: nil)
    
    var placeId = BehaviorRelay<String?>(value: nil)
    var place = BehaviorRelay<BlogPost?>(value: nil)
    
    var date = BehaviorRelay<String?>(value: nil)
    
    var eventDates = BehaviorRelay<[Date]>(value: [])
    
    var isSuccess = PublishRelay<Bool>()
    var isAddPlace = PublishRelay<Bool>()
    var isAddPlaceContinue = PublishRelay<Bool>()
    
    var choosedDatePlaceCurrent = BehaviorRelay<[String]?>(value: nil)
                    
    func featchPlaceCalendar() {
        calendarService.fetchWhereEqualTo(field: "userId", value: userId) { result in
            switch result {
            case .success(let calendarPlace):
                self.calendarPlace.accept(calendarPlace)
                let dates: [Date] = calendarPlace.map { $0.date.toDate() ?? Date() }
                self.eventDates.accept(dates)
            case .failure(let error):
                print("Loi: \(error)")
            }
        }
    }
    
    func isCalendarPlace() {
        guard let placeId = placeId.value else {
            return
        }
        let fields = [
            "placeId": placeId,
            "userId": userId
        ]
        calendarService.fetchDocumentsByFields(fields: fields as [String : Any]) { result in
            switch result {
            case .success(let places):
                if !places.isEmpty {
                    let dates: [String] = places.map { $0.date }
                    self.choosedDatePlaceCurrent.accept(dates)
                    self.isAddPlace.accept(true)
                } else {
                    self.isAddPlace.accept(false)
                }
            case .failure(_):
                self.isAddPlace.accept(false)
            }
        }
    }
    
    func addPlaceCalendar() {
        let id = Firestore.firestore().collection("calendars").document().documentID
        let place = NewCreateScheduleModel(scheduleId: placeId.value ?? "",
                                           blogId: placeId.value ?? "",
                                           avatarBlog: place.value?.avatarBlog ?? "",
                                           title: place.value?.title ?? "",
                                           address: place.value?.address ?? "",
                                           avgRating: place.value?.avgRating ?? 0,
                                           date: date.value ?? Date().toString(),
                                           createAt: Date())
        calendarService.set(place, withId: id /*placeId.value ?? ""*/) { result in
            switch result {
            case .success():
                self.isSuccess.accept(true)
            case .failure( _):
                self.isSuccess.accept(false)
            }
        }
    }
}

