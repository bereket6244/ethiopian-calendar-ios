import Foundation

struct EthiopianHoliday {
    let name: String
    let amharicName: String
    let date: Date
    let isEstimated: Bool

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    static func next(onOrAfter reference: Date = Date()) -> EthiopianHoliday? {
        let currentYear = EthiopianDateInfo.from(date: reference).year
        let gregorianYear = Calendar(identifier: .gregorian).component(.year, from: reference)
        let islamic = Calendar(identifier: .islamicUmmAlQura)
        let islamicYear = islamic.component(.year, from: reference)
        var holidays: [EthiopianHoliday] = []

        for year in (currentYear - 1)...(currentYear + 2) {
            for (month, day, name, amharic) in [
                (1, 1, "Enkutatash", "እንቁጣጣሽ"),
                (1, 17, "Meskel", "መስቀል"),
                (4, 29, "Genna", "ገና"),
                (5, 11, "Timkat", "ጥምቀት")
            ] {
                if let date = EthiopianDateInfo.gregorianDate(day: day, month: month, year: year) {
                    holidays.append(EthiopianHoliday(name: name, amharicName: amharic, date: date, isEstimated: false))
                }
            }
        }

        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = .current
        for year in (gregorianYear - 1)...(gregorianYear + 2) {
            for (month, day, name, amharic) in [
                (3, 2, "Adwa Victory Day", "የዓድዋ ድል በዓል"),
                (5, 1, "Workers’ Day", "የሠራተኞች ቀን"),
                (5, 5, "Patriots’ Victory Day", "የአርበኞች ቀን")
            ] {
                if let date = gregorian.date(from: DateComponents(year: year, month: month, day: day)) {
                    holidays.append(EthiopianHoliday(name: name, amharicName: amharic, date: date, isEstimated: false))
                }
            }
            if let easter = orthodoxEaster(gregorianYear: year) {
                holidays.append(EthiopianHoliday(name: "Fasika", amharicName: "ፋሲካ", date: easter, isEstimated: false))
                if let friday = gregorian.date(byAdding: .day, value: -2, to: easter) {
                    holidays.append(EthiopianHoliday(name: "Siklet (Good Friday)", amharicName: "ስቅለት", date: friday, isEstimated: false))
                }
            }
        }

        // Islamic dates are predictions; the observed holiday may shift with moon sighting.
        for year in (islamicYear - 1)...(islamicYear + 2) {
            for (month, day, name, amharic) in [
                (3, 12, "Mawlid", "መውሊድ"),
                (10, 1, "Eid al-Fitr", "ዒድ አልፈጥር"),
                (12, 10, "Eid al-Adha", "ዒድ አልአድሐ")
            ] {
                if let date = islamic.date(from: DateComponents(year: year, month: month, day: day)) {
                    holidays.append(EthiopianHoliday(name: name, amharicName: amharic, date: date, isEstimated: true))
                }
            }
        }

        let start = Calendar.current.startOfDay(for: reference)
        return holidays
            .filter { $0.date >= start }
            .sorted { $0.date < $1.date }
            .first
    }

    private static func orthodoxEaster(gregorianYear year: Int) -> Date? {
        let a = year % 4
        let b = year % 7
        let c = year % 19
        let d = (19 * c + 15) % 30
        let e = (2 * a + 4 * b - d + 34) % 7
        let month = (d + e + 114) / 31
        let day = (d + e + 114) % 31 + 1
        var julian = Calendar(identifier: .julian)
        julian.timeZone = .current
        return julian.date(from: DateComponents(year: year, month: month, day: day))
    }
}
