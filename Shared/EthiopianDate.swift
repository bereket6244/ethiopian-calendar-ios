import Foundation

struct EthiopianDateInfo {
    let day: Int
    let month: Int
    let year: Int
    let weekdayIndex: Int // 1 = Sunday ... 7 = Saturday

    static let amharicMonths = [
        "መስከረም", "ጥቅምት", "ኅዳር", "ታኅሣሥ",
        "ጥር", "የካቲት", "መጋቢት", "ሚያዝያ",
        "ግንቦት", "ሰኔ", "ሐምሌ", "ነሐሴ", "ጳጉሜ"
    ]

    static let englishMonths = [
        "Meskerem", "Tikimt", "Hidar", "Tahsas",
        "Tir", "Yekatit", "Megabit", "Miyazya",
        "Ginbot", "Sene", "Hamle", "Nehase", "Pagume"
    ]

    static let amharicWeekdays = [
        "እሑድ", "ሰኞ", "ማክሰኞ", "ረቡዕ", "ሐሙስ", "ዓርብ", "ቅዳሜ"
    ]

    static let englishWeekdays = [
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ]

    static let amharicShortWeekdays = ["እሑ", "ሰኞ", "ማክ", "ረቡ", "ሐሙ", "ዓር", "ቅዳ"]

    var monthNameAmharic: String {
        guard month >= 1 && month <= Self.amharicMonths.count else { return "" }
        return Self.amharicMonths[month - 1]
    }

    var monthNameEnglish: String {
        guard month >= 1 && month <= Self.englishMonths.count else { return "" }
        return Self.englishMonths[month - 1]
    }

    var weekdayAmharic: String {
        guard weekdayIndex >= 1 && weekdayIndex <= Self.amharicWeekdays.count else { return "" }
        return Self.amharicWeekdays[weekdayIndex - 1]
    }

    var weekdayEnglish: String {
        guard weekdayIndex >= 1 && weekdayIndex <= Self.englishWeekdays.count else { return "" }
        return Self.englishWeekdays[weekdayIndex - 1]
    }

    static let ethiopicCalendar: Calendar = {
        var cal = Calendar(identifier: .ethiopicAmeteMihret)
        cal.locale = Locale(identifier: "en_US_POSIX")
        return cal
    }()

    static func from(date: Date = Date()) -> EthiopianDateInfo {
        let comps = ethiopicCalendar.dateComponents([.year, .month, .day, .weekday], from: date)
        return EthiopianDateInfo(
            day: comps.day ?? 1,
            month: comps.month ?? 1,
            year: comps.year ?? 2019,
            weekdayIndex: comps.weekday ?? 1
        )
    }

    static func daysInMonth(month: Int, year: Int) -> Int {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        guard let date = ethiopicCalendar.date(from: comps),
              let range = ethiopicCalendar.range(of: .day, in: .month, for: date) else {
            return month == 13 ? 5 : 30
        }
        return range.count
    }

    static func firstWeekdayOfMonth(month: Int, year: Int) -> Int {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        guard let date = ethiopicCalendar.date(from: comps) else { return 1 }
        return ethiopicCalendar.component(.weekday, from: date)
    }

    static func gregorianString(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
