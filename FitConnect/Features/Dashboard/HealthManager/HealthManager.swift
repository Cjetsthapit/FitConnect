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
    static var startOfWeek: Date{
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date())
        components.weekday = 2 // Monday
        return calendar.date(from: components)!
    }
}

class HealthManager: ObservableObject{
    let healthStore = HKHealthStore()
    
    @Published var activities: [String: Activity] = [:]
    
    @Published var mockActivities: [String: Activity] = [
        "todaySteps": Activity(id: 0, title: "Todays steps", subtitle: "Goal 10,000", image: "figure.walk", amount:"10000"),
        "todayCalories": Activity(id: 1, title: "Todays Calories", subtitle: "Goal 900", image: "figure.step.training", amount:"2000")
    ]
    
    init(){
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories]
        
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchWeekRunningStats()
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
            let activity = Activity(id: 0, title: "Todays steps", subtitle: "Goal 10,000", image: "figure.walk", amount: stepCount.formattedString())
            
            DispatchQueue.main.async{
                self.activities["todaySteps"] = activity
            }
            print (stepCount)
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayCalories(){
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print ("error fetchin todays calories")
                return
            }
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Todays Calorie", subtitle: "Goal 900", image: "figure.step.training", amount: calorieCount.formattedString())
            
            DispatchQueue.main.async{
                self.activities["todayCalories"] = activity
            }
            print (calorieCount)
        }
        healthStore.execute(query)
    }
    func fetchWeekRunningStats(){
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate,workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 25, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print ("error fetchin todays calories")
                return
            }
            var count:Int = 0
            for workout in workouts {
                let duration = Int(workout.duration)/60
                count += duration
            }
            let activity = Activity(id: 2, title: "Running", subtitle: "Mins ran this week", image: "figure.walk", amount: "\(count) minutes")
            
            DispatchQueue.main.async{
                self.activities["weekRunning"] = activity
            }
        }
        healthStore.execute(query)
    }
}
