//
//  HealthManager.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//

import Foundation
import HealthKit

//Date extraction
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
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = calendar.date(byAdding: .month, value: -1, to: Date())
        return calendar.startOfDay(for: oneMonth!)
    }
    static var oneWeekAgo: Date {
        let calendar = Calendar.current
        let oneWeek = calendar.date(byAdding: .weekday, value: -1, to: Date())
        return calendar.startOfDay(for: oneWeek!)
    }
}

class HealthManager: ObservableObject{
    let healthStore = HKHealthStore()
    
    @Published var activities: [String: Activity] = [:]
    
    @Published var oneMonthChartData = [DailyStepView]()
    @Published var oneWeekChartData = [DailyStepView]()
    
    //MockActivities for testing purpose
    @Published var mockActivities: [String: Activity] = [
        "todaySteps": Activity(id: 0, title: "Todays steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount:"10000"),
        "todayCalories": Activity(id: 1, title: "Todays Calories", subtitle: "Goal 900", image: "figure.step.training", tintColor: .red, amount:"2000"),
        "todayrunning": Activity(id: 2, title: "Running", subtitle: "Mins ran this week", image: "figure.walk", tintColor: .green, amount: "12 minutes"),
        "todaystrengths": Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "scalemass", tintColor: .red, amount: "25 minutes"),
        "todaysoccer": Activity(id: 4, title: "Soccer", subtitle: "This week", image: "soccerball.inverse", tintColor: .blue, amount: "12 minutes"),
        "todayBasketball": Activity(id: 5, title: "Basketball", subtitle: "This week", image: "basketball", tintColor: .yellow, amount: "12 minutes"),
        "todaystair": Activity(id: 6, title: "Stairs", subtitle: "This week", image: "figure.stairs", tintColor: .yellow, amount: "12 minutes"),
        "todaykick": Activity(id: 7, title: "Kick Boxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "12 minutes")
    ]
    
    init(){
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories,workout] //Requesting Access for steps, calories and workouts
        
        //Show our data from fetch
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchCurrentWeekWorkoutStat()
                fetchPastMonthStepData()
            }catch{
                print ("error fetching health data")
            }
        }
    }
    
    func fetchDailySteps(startDate: Date, completion: @escaping ([DailyStepView]) -> Void){
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, result, error in
            guard let result = result else {
                completion([])
                return
            }
            
            var dailySteps = [DailyStepView]()
            result.enumerateStatistics(from: startDate, to: Date()) {statistics, stop in
                dailySteps.append(DailyStepView(date: statistics.startDate, stepCount: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
            }
            completion(dailySteps)
        }
        healthStore.execute(query)
        
    }
    
    //Fetch steps
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
    
    //Fetch Todays Calories
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
    //Fetch various different workouts
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
            var cyclingCount:Int = 0
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
                } else if workout.workoutActivityType == .cycling {
                    let duration = Int(workout.duration)/60
                    cyclingCount += duration
                }
                    
                
            }
            //Defining what goes into each activity cards
            let runningActivity = Activity(id: 2, title: "Running", subtitle: "Mins ran this week", image: "figure.walk", tintColor: .green, amount: "\(runningCount) minutes")
            let strengthActivity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", tintColor: .red, amount: "\(StrengthCount) minutes")
            let soccerActivity = Activity(id: 4, title: "Soccer", subtitle: "This week", image: "soccerball.inverse", tintColor: .blue, amount: "\(soccerCount) minutes")
            let basketballActivity = Activity(id: 5, title: "Basketball", subtitle: "This week", image: "basketball", tintColor: .blue, amount: "\(BasketballCount) minutes")
            let stairActivity = Activity(id: 6, title: "Stairs", subtitle: "This week", image: "figure.stairs", tintColor: .yellow, amount: "\(stairsCount) minutes")
            let cyclingActivity = Activity(id: 7, title: "Cycling", subtitle: "This week", image: "figure.outdoor.cycle", tintColor: .green, amount: "\(cyclingCount) minutes")
            
            
            DispatchQueue.main.async{
                self.activities["weekRunning"] = runningActivity
                self.activities["weekStrength"] = strengthActivity
                self.activities["weekSoccer"] = soccerActivity
                self.activities["weekBasketball"] = basketballActivity
                self.activities["weekStairs"] = stairActivity
                self.activities["weekCycling"] = cyclingActivity
            }
        }
        healthStore.execute(query)
        
    }
}


    // MARK: Chart data
extension HealthManager{
    func fetchPastMonthStepData(){
        fetchDailySteps(startDate: .oneMonthAgo){dailySteps in
            DispatchQueue.main.async {
                self.oneMonthChartData = dailySteps
            }
        }
    }
    func fetchPastWeekStepData(){
        fetchDailySteps(startDate: .oneWeekAgo){dailySteps in
            DispatchQueue.main.async {
                self.oneWeekChartData = dailySteps
            }
        }
    }
}
