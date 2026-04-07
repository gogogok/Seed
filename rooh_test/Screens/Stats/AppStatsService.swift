import Foundation

final class AppStatsService {
    
    static let shared = AppStatsService()
    
    private init() {}
    
    private let activityDatesKey = "activity_dates"
    
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }
    
    func markTodayAsActive() {
        let today = calendar.startOfDay(for: Date())
        var dates = loadDates()
        
        if !dates.contains(today) {
            dates.append(today)
            saveDates(dates)
        }
    }
    
    func fetchLast7DaysActivity() -> [Bool] {
        let dates = loadDates()
        let today = calendar.startOfDay(for: Date())
        
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        
        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return []
        }
        
        var result: [Bool] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: monday) {
                result.append(dates.contains(date))
            }
        }
        
        return result
    }
    
    func fetchLast7DaysTitles() -> [String] {
        let today = calendar.startOfDay(for: Date())
        
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        
        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return []
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "E"
        
        var result: [String] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: monday) {
                result.append(formatter.string(from: date))
            }
        }
        
        return result
    }
    
    func weeklyProgress() -> Double {
        let activity = fetchLast7DaysActivity()
        let activeDays = activity.filter { $0 }.count
        return Double(activeDays) / 7.0
    }
    
    private func saveDates(_ dates: [Date]) {
        let normalized = dates.map { calendar.startOfDay(for: $0) }
        UserDefaults.standard.set(normalized, forKey: activityDatesKey)
    }
    
    private func loadDates() -> [Date] {
        guard let dates = UserDefaults.standard.array(forKey: activityDatesKey) as? [Date] else {
            return []
        }
        return dates.map { calendar.startOfDay(for: $0) }
    }
}
