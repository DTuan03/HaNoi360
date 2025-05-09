//
//  AddCalendarVM.swift
//  HaNoi360
//
//  Created by Tuấn on 21/4/25.
//
import RxSwift
import RxCocoa
import FirebaseFirestore

class AddCalendarVM: BaseVM {
    var calendarPlace = BehaviorRelay<[AddCalendarModel]?>(value: nil)
    
    var plannedPlaces = BehaviorRelay<AddCalendarModel?>(value: nil)
    
    var placeId = BehaviorRelay<String?>(value: nil)
    var place = BehaviorRelay<DetailModel?>(value: nil)
    
    var date = BehaviorRelay<String?>(value: nil)
    
    var eventDates = BehaviorRelay<[Date]>(value: [])
    
    var isSuccess = PublishRelay<Bool>()
    var isAddPlace = PublishRelay<Bool>()
    var isAddPlaceContinue = PublishRelay<Bool>()
    
    var choosedDatePlaceCurrent = BehaviorRelay<[String]?>(value: nil)
                    
    func featchPlaceCalendar() {
        calendarService.fetchWhereEqualTo(field: "userId", value: userId ?? "") { result in
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
            case .failure(let error):
                self.isAddPlace.accept(false)
            }
        }
    }

    func addPlaceCalendar() {
        let id = Firestore.firestore().collection("calendars").document().documentID
        let place = AddCalendarModel(scheduleId: id,
                                     placeId: placeId.value ?? "",
                                     placeImage: place.value?.placeImage ?? "",
                                     name: place.value?.name ?? "",
                                     address: place.value?.address ?? "",
                                     avgRating: place.value?.avgRating ?? 0,
                                     userId: userId ?? "",
                                     date: date.value ?? Date().toString(),
                                     createAt: Date())
        calendarService.set(place, withId: id) { result in
            self.isLoading.accept(false)
            switch result {
            case .success():
                self.isSuccess.accept(true)
            case .failure( _):
                self.isSuccess.accept(false)
            }
        }
    }
}

