import SwiftUI

@main
struct EthiopianCalendarWatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchDateView()
        }
    }
}

struct WatchDateView: View {
    private let green = Color(red: 0.72, green: 0.84, blue: 0.40)
    private let today = EthiopianDateInfo.from()
    private let holiday = EthiopianHoliday.next()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("ETHIOPIAN CALENDAR")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(green)

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("\(today.day)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                    VStack(alignment: .leading, spacing: 1) {
                        Text(today.monthNameAmharic)
                            .font(.title3.weight(.bold))
                        Text("\(today.year) ዓ.ም.")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(green)
                    }
                }

                Text(today.weekdayEnglish + " · " + today.monthNameEnglish)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                if let holiday {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(holiday.isToday ? "TODAY'S HOLIDAY" : "NEXT HOLIDAY")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(green)
                        Text(holiday.name + (holiday.isEstimated ? " (est.)" : ""))
                            .font(.footnote.weight(.semibold))
                            .lineLimit(2)
                        Text(holiday.date, format: .dateTime.month(.abbreviated).day())
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 5)
        }
    }
}
