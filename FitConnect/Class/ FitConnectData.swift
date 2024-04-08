
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Charts

class FitConnectData: ObservableObject {
    @Published var fitConnectData: FitConnectResponse?
    @Published var userId: String?
    
    @Published var totalProtein: Double = 0
    @Published var totalCarb: Double = 0
    @Published var totalFat: Double = 0
    
    @Published var totalWeeklyProtein: Double = 0
    @Published var totalWeeklyCarb: Double = 0
    @Published var totalWeeklyFat: Double = 0
    @Published var weeklySummaryData: [WeeklyViewData] = []
    @Published var filteredIntakes: [Macro] = []
    @Published var selectedMacroDate = Date() {
        didSet {
            filterMacroIntakes()
        }
    }
    @Published var selectedMacroRange = [Date(), Date()]{
        didSet{
            filterWeeklyIntakes()
        }
    }
    @Published var selectedMacroYear : String = ""{
        didSet{
            filterMonthlyIntakes()
        }
    }
    
    @Published var filteredWeeklyIntakes: [Macro] = []
    @Published var monthlySummaryData: [MonthlyViewData] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init() {
        fetchFitConnectData()
    }
    
    func filterMonthlyIntakes() {
        guard let food = fitConnectData?.food else {
            monthlySummaryData = []
            return
        }
        
        let calendar = Calendar.current
        let yearInt = Int(selectedMacroYear) ?? Calendar.current.component(.year, from: Date())
        let foodInSelectedYear = food.filter { calendar.component(.year, from: $0.date) == yearInt }
        
        monthlySummaryData.removeAll()
        
        for monthIndex in 1...12 {
            let monthFood = foodInSelectedYear.filter {
                calendar.component(.month, from: $0.date) == monthIndex
            }
            
            let monthlyProtein = monthFood.reduce(0) { $0 + $1.protein }
            let monthlyCarb = monthFood.reduce(0) { $0 + $1.carb }
            let monthlyFat = monthFood.reduce(0) { $0 + $1.fat }
            
            let monthSymbol = calendar.monthSymbols[monthIndex - 1]
            
                // Appending MonthlyViewData for each nutrient type
            ["Carbs", "Protein", "Fat"].forEach { nutrient in
                let value: Double
                switch nutrient {
                   
                    case "Carbs":
                        value = Double(monthlyCarb * 4)
                    case "Protein":
                        value = Double(monthlyProtein * 4) 
                    case "Fat":
                        value = Double(monthlyFat * 8)
                    default:
                        value = 0 // This case should never be hit due to the hardcoded types
                }
                
                monthlySummaryData.append(MonthlyViewData(month: monthSymbol, value: value, type: nutrient))
            }
        }
    }

    func filterWeeklyIntakes() {
        guard let food = fitConnectData?.food, selectedMacroRange.count == 2 else {
            resetNutrients()
            return
        }
         func dayLabelFromWeekday(_ weekday: Int) -> String {
            let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                // Calendar's weekday starts from 1 (Sunday) to 7 (Saturday)
            return dayNames[weekday - 1]
        }
        let startOfWeek = selectedMacroRange[0]
        let endOfWeek = selectedMacroRange[1]
        let calendar = Calendar.current
        
            // Filter food data within the selected week range
        let weeklyFilteredIntakes = food.filter { $0.date >= startOfWeek && $0.date <= endOfWeek }
        
            // Reset previous data
        weeklySummaryData.removeAll()
        
            // Aggregate data by day and type
        for dayOffset in 0...6 {
            guard let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else { continue }
            let day = dateFormatter.string(from: dayDate)
            let dayOfWeek = calendar.component(.weekday, from: dayDate)
            let dayLabel = dayLabelFromWeekday(dayOfWeek)
            
            let dailyIntakes = weeklyFilteredIntakes.filter { dateFormatter.string(from: $0.date) == day }
            
                // Aggregate by type
            let types = ["Carbs", "Protein", "Fat"]
            for type in types {
                let totalHours = dailyIntakes.reduce(0) { (result, macro) -> Double in
                    switch type {
                        case "Fat":
                            return result + (Double(macro.fat)*8) // Assuming you convert fat to an 'hours'-like metric
                        case "Protein":
                            return result + (Double(macro.protein)*4)
                        case "Carbs":
                            return result + (Double(macro.carb)*4)
                        default:
                            return result
                    }
                }
                let data = WeeklyViewData(day: dayLabel, hours: totalHours, type: type)
                weeklySummaryData.append(data)
            }
        }
    }
    
    func filterMacroIntakes() {
        guard let food = fitConnectData?.food else {
            resetNutrients()
            return
        }
        
        let selectedDateString = dateFormatter.string(from: selectedMacroDate)
        
        filteredIntakes = food.filter { dateFormatter.string(from: $0.date) == selectedDateString }
        
        updateTotalNutrients()
    }
    
    func fetchFitConnectData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        self.userId = currentUser.uid
        
        Firestore.firestore().collection("users").document(currentUser.uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user data:", error.localizedDescription)
                return
            }
            
            guard let document = document, document.exists, let fitConnectData = try? document.data(as: FitConnectResponse.self) else {
                print("User document not found or data is invalid")
                return
            }
            
            self.fitConnectData = fitConnectData
            self.filterMacroIntakes()
        }
    }
    
    private func updateTotalNutrients() {
        totalProtein = filteredIntakes.reduce(0) { $0 + $1.protein }
        totalCarb = filteredIntakes.reduce(0) { $0 + $1.carb }
        totalFat = filteredIntakes.reduce(0) { $0 + $1.fat }
    }
    
    private func resetNutrients() {
        filteredIntakes = []
        totalProtein = 0
        totalCarb = 0
        totalFat = 0
    }
}

struct FitConnectResponse: Decodable{
    let fullName: String
    let contactNumber: String
    let email: String
    let height: Double
    let weight: Double
    let gender: String
    let dob: Date?
    let weightGoal: String?
    let food: [Macro]?
    let macroLimit: MacroLimitSettings
    let weights: [String: WeightEntry]?
}

struct MacroLimitSettings: Decodable{
    let protein: Int
    let fat: Int
    let carb: Int
}

struct Macro: Decodable, Hashable{
    let food: String
    let date: Date
    let protein: Double
    let carb: Double
    let fat: Double
}

struct WeeklyViewData: Identifiable {
    var id = UUID().uuidString
    var day: String
    var hours: Double
    var type: String
}

struct MonthlyViewData: Identifiable {
    var id = UUID().uuidString
    var month: String
    var value: Double
    var type: String
}

struct WeightEntry: Decodable {
    let date: String
    let weight: Double
}
