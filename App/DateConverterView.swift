import SwiftUI

struct DateConverterView: View {
    private enum Direction: String, CaseIterable {
        case gregorianToEthiopian = "GC → EC"
        case ethiopianToGregorian = "EC → GC"
    }

    @State private var direction: Direction = .gregorianToEthiopian
    @State private var gregorianDate = Date()
    @State private var ecDay: Int
    @State private var ecMonth: Int
    @State private var ecYear: Int

    init() {
        let today = EthiopianDateInfo.from()
        _ecDay = State(initialValue: today.day)
        _ecMonth = State(initialValue: today.month)
        _ecYear = State(initialValue: today.year)
    }

    private var ecDaysInMonth: Int {
        EthiopianDateInfo.daysInMonth(month: ecMonth, year: ecYear)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Convert Dates", systemImage: "arrow.left.arrow.right")
                .font(.headline)

            Picker("Conversion direction", selection: $direction) {
                ForEach(Direction.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)

            if direction == .gregorianToEthiopian {
                DatePicker("Gregorian date", selection: $gregorianDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                let result = EthiopianDateInfo.from(date: gregorianDate)
                resultBlock(
                    label: "Ethiopian date",
                    primary: "\(result.monthNameAmharic) \(result.day), \(result.year)",
                    secondary: "\(result.monthNameEnglish) \(result.day), \(result.year) E.C."
                )
            } else {
                HStack(spacing: 8) {
                    Picker("Day", selection: $ecDay) {
                        ForEach(1...ecDaysInMonth, id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    Picker("Month", selection: $ecMonth) {
                        ForEach(1...13, id: \.self) { month in
                            Text(EthiopianDateInfo.englishMonths[month - 1]).tag(month)
                        }
                    }
                    Picker("Year", selection: $ecYear) {
                        ForEach(1900...2100, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                }
                .tint(.green)
                .onChange(of: ecMonth) { _, _ in clampDay() }
                .onChange(of: ecYear) { _, _ in clampDay() }

                if let result = EthiopianDateInfo.gregorianDate(day: ecDay, month: ecMonth, year: ecYear) {
                    resultBlock(
                        label: "Gregorian date",
                        primary: EthiopianDateInfo.gregorianString(for: result),
                        secondary: "G.C."
                    )
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func resultBlock(label: String, primary: String, secondary: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(primary)
                .font(.title3.weight(.bold))
            Text(secondary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func clampDay() {
        ecDay = min(ecDay, ecDaysInMonth)
    }
}
