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
        "todaySteps": Activity(id: 0, title: "Todays steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount:"10000"),
        "todayCalories": Activity(id: 1, title: "Todays Calories", subtitle: "Goal 900", image: "figure.step.training", tintColor: .red, amount:"2000"),
        "todayrunning": Activity(id: 2, title: "Running", subtitle: "Mins ran this week", image: "figure.walk", tintColor: .green, amount: "12 minutes"),
        "todaystrengths": Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", tintColor: .red, amount: "25 minutes"),
        "todaysoccer": Activity(id: 4, title: "Soccer", subtitle: "This week", image: "soccerball.inverse", tintColor: .blue, amount: "12 minutes"),
        "todayBasketball": Activity(id: 5, title: "Basketball", subtitle: "This week", image: "basketball", tintColor: .yellow, amount: "12 minutes"),
        "todaystair": Activity(id: 6, title: "Stairs", subtitle: "This week", image: "figure.stairs", tintColor: .yellow, amount: "12 minutes"),
        "todaykick": Activity(id: 7, title: "Kick Boxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "12 minutes")
    ]
    
    init(){
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories,workout]
        
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchCurrentWeekWorkoutStat()
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
            let activity = Activity(id: 0, title: "Todays steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: stepCount.formattedString())
            
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
            let activity = Activity(id: 1, title: "Todays Calorie", subtitle: "Goal 900", image: "figure.step.training", tintColor: .blue, amount: calorieCount.formattedString())
            
            DispatchQueue.main.async{
                self.activities["todayCalories"] = activity
            }
            print (calorieCount)
        }
        healthStore.execute(query)
    }
//    func fetchWeekRunningStats(){
//            let workout = HKSampleType.workoutType()
//            let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
//            let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
//            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate,workoutPredicate])
//            let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 25, sortDescriptors: nil) { _, sample, error in
//                guard let workouts = sample as? [HKWorkout], error == nil else {
//                    print ("error fetchin todays calories")
//                    return
//                }
//                var count:Int = 0
//                for workout in workouts {
//                    let duration = Int(workout.duration)/60
//                    count += duration
//                }
//                let activity = Activity(id: 2, title: "Running", subtitle: "Mins ran this week", image: "figure.walk", tintColor: .green, amount: "\(count) minutes")
//                
//                DispatchQueue.main.async{
//                    self.activities["weekRunning"] = activity
//                }
//            }
//            healthStore.execute(query)
//        }
    func fetchCurrentWeekWorkoutStat(){
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print ("error fetchin todays calories")
                return
            }
            var runningCount:Int = 0
            var StrengthCount:Int = 0
            var soccerCount:Int = 0
            var BasketballCount:Int = 0
            var stairsCount:Int = 0
            var kickBoxingCount:Int = 0
            for workout in workouts {
                if workout.workoutActivityType == .running {
                    let duration = Int(workout.duration)/60
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    let duration = Int(workout.duration)/60
                    StrengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    let duration = Int(workout.duration)/60
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    let duration = Int(workout.duration)/60
                    BasketballCount += duration
                }else if workout.workoutActivityType == .stairs {
                    let duration = Int(workout.duration)/60
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    let duration = Int(workout.duration)/60
                    kickBoxingCount += duration
                }
                    
                
            }
            let runningActivity = Activity(id: 2, title: "Running", subtitle: "Mins ran this week", image: "figure.walk", tintColor: .green, amount: "\(runningCount) minutes")
            let strengthActivity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "figure.dumbbell", tintColor: .red, amount: "\(StrengthCount) minutes")
            let soccerActivity = Activity(id: 4, title: "Soccer", subtitle: "This week", image: "soccerball.inverse", tintColor: .blue, amount: "\(soccerCount) minutes")
            let basketballActivity = Activity(id: 5, title: "Basketball", subtitle: "This week", image: "basketball", tintColor: .yellow, amount: "\(BasketballCount) minutes")
            let stairActivity = Activity(id: 6, title: "Stairs", subtitle: "This week", image: "figure.stairs", tintColor: .yellow, amount: "\(stairsCount) minutes")
            let kickBoxingActivity = Activity(id: 7, title: "Kick Boxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(kickBoxingCount) minutes")
            
            
            DispatchQueue.main.async{
                self.activities["weekRunning"] = runningActivity
                self.activities["weekStrength"] = strengthActivity
                self.activities["weekSoccer"] = soccerActivity
                self.activities["weekBasketball"] = basketballActivity
                self.activities["weekStairs"] = stairActivity
                self.activities["weekKickBoxing"] = kickBoxingActivity
            }
        }
        healthStore.execute(query)
        
    }
}
