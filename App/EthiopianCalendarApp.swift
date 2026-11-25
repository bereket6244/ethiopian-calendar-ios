import SwiftUI

@main
struct EthiopianCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    private let today = EthiopianDateInfo.from()
    @State private var displayMonth: Int
    @State private var displayYear: Int

    init() {
        let now = EthiopianDateInfo.from()
        _displayMonth = State(initialValue: now.month)
        _displayYear = State(initialValue: now.year)
    }

    private var daysCount: Int {
        EthiopianDateInfo.daysInMonth(month: displayMonth, year: displayYear)
    }

    private var leadingEmptySlots: Int {
        EthiopianDateInfo.firstWeekdayOfMonth(month: displayMonth, year: displayYear) - 1
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    todayCard
                    calendarCard
                    widgetTipCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Ethiopian Calendar")
        }
    }

    private var todayCard: some View {
        VStack(spacing: 8) {
            Text(today.weekdayAmharic + " • " + today.weekdayEnglish)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.9))

            Text("\(today.day)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("\(today.monthNameAmharic) \(today.year) ዓ.ም.")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)

            Text("\(today.monthNameEnglish) \(today.day), \(today.year) E.C.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))

            Divider()
                .background(.white.opacity(0.3))
                .padding(.vertical, 4)

            Text("Gregorian: \(EthiopianDateInfo.gregorianString())")
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .background(
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.45, blue: 0.24), Color(red: 0.05, green: 0.30, blue: 0.18)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
    }

    private var calendarCard: some View {
        VStack(spacing: 14) {
            HStack {
                Button {
                    previousMonth()
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title2)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(EthiopianDateInfo.amharicMonths[displayMonth - 1]) \(displayYear)")
                        .font(.headline)
                    Text(EthiopianDateInfo.englishMonths[displayMonth - 1])
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    nextMonth()
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                }
            }
            .tint(.green)

            let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(EthiopianDateInfo.amharicShortWeekdays, id: \.self) { wd in
                    Text(wd)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                ForEach(0..<leadingEmptySlots, id: \.self) { _ in
                    Color.clear.frame(height: 36)
                }

                ForEach(1...daysCount, id: \.self) { day in
                    let isToday = (day == today.day && displayMonth == today.month && displayYear == today.year)
                    Text("\(day)")
                        .font(.subheadline.weight(isToday ? .bold : .regular))
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(isToday ? Color.green : Color.clear)
                        .foregroundStyle(isToday ? .white : .primary)
                        .clipShape(Circle())
                }
            }

            if displayMonth != today.month || displayYear != today.year {
                Button("Back to Today") {
                    displayMonth = today.month
                    displayYear = today.year
                }
                .font(.caption.weight(.semibold))
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var widgetTipCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "square.grid.2x2.fill")
                .font(.title2)
                .foregroundStyle(.green)
            VStack(alignment: .leading, spacing: 2) {
                Text("Add Home Screen Widget")
                    .font(.subheadline.weight(.semibold))
                Text("Long-press your Home Screen, tap + (Edit > Add Widget), and search for Ethiopian Calendar.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func previousMonth() {
        if displayMonth == 1 {
            displayMonth = 13
            displayYear -= 1
        } else {
            displayMonth -= 1
        }
    }

    private func nextMonth() {
        if displayMonth == 13 {
            displayMonth = 1
            displayYear += 1
        } else {
            displayMonth += 1
        }
    }
}
