import Foundation

var gregorian = Calendar(identifier: .gregorian)
gregorian.timeZone = .current

func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
    gregorian.date(from: DateComponents(year: year, month: month, day: day))!
}

let newYear = date(2024, 9, 11)
let ethiopian = EthiopianDateInfo.from(date: newYear)
precondition(ethiopian.year == 2017 && ethiopian.month == 1 && ethiopian.day == 1)

let converted = EthiopianDateInfo.gregorianDate(day: 1, month: 1, year: 2017)!
precondition(gregorian.isDate(converted, inSameDayAs: newYear))
precondition(EthiopianDateInfo.gregorianDate(day: 7, month: 13, year: 2017) == nil)

let genna = EthiopianHoliday.next(onOrAfter: date(2027, 1, 7))!
precondition(genna.name == "Genna" && gregorian.isDate(genna.date, inSameDayAs: date(2027, 1, 7)))

let fasika = EthiopianHoliday.next(onOrAfter: date(2027, 5, 2))!
precondition(fasika.name == "Fasika" && gregorian.isDate(fasika.date, inSameDayAs: date(2027, 5, 2)))

print("Date conversion and holiday checks passed")
