//
//  HealthManager.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//

import Foundation
import HealthKit

extension Date{
    static var startOfDay: Date{
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject{
    let healthStore = HKHealthStore()
    init(){
        let steps = HKQuantityType(.stepCount)
        let healthTypes: Set = [steps]
        
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            }catch{
                print ("error fetching health data")
            }
        }
    }
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print ("error fetchin todays steps")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            print (stepCount)
        }
        
        healthStore.execute(query)
    }
}
