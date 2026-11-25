import WidgetKit
import SwiftUI

struct EthiopianEntry: TimelineEntry {
    let date: Date
    let info: EthiopianDateInfo
    let holiday: EthiopianHoliday?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> EthiopianEntry {
        entry(for: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (EthiopianEntry) -> Void) {
        let now = Date()
        completion(entry(for: now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EthiopianEntry>) -> Void) {
        let now = Date()
        let entry = entry(for: now)
        let nextMidnight = Calendar.current.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0, second: 5),
            matchingPolicy: .nextTime
        ) ?? Calendar.current.date(byAdding: .hour, value: 1, to: now)!
        let timeline = Timeline(entries: [entry], policy: .after(nextMidnight))
        completion(timeline)
    }

    private func entry(for date: Date) -> EthiopianEntry {
        EthiopianEntry(
            date: date,
            info: EthiopianDateInfo.from(date: date),
            holiday: EthiopianHoliday.next(onOrAfter: date)
        )
    }
}

struct EthiopianWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemMedium:
            mediumView
        case .accessoryInline:
            inlineView
        case .accessoryCircular:
            circularView
        case .accessoryRectangular:
            rectangularView
        default:
            smallView
        }
    }

    private var inlineView: some View {
        Text("\(entry.info.monthNameAmharic) \(entry.info.day) · \(entry.info.year) ዓ.ም.")
            .lineLimit(1)
            .containerBackground(for: .widget) { Color.clear }
    }

    private var circularView: some View {
        VStack(spacing: 0) {
            Text("\(entry.info.day)")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.7)
            Text(entry.info.monthNameAmharic)
                .font(.system(size: 10, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) { Color.clear }
    }

    private var rectangularView: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("\(entry.info.monthNameAmharic) \(entry.info.day), \(entry.info.year) ዓ.ም.")
                .font(.headline.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text("\(entry.info.weekdayEnglish) · \(entry.info.monthNameEnglish) \(entry.info.day)")
                .font(.caption2)
                .lineLimit(1)
            if let holiday = entry.holiday {
                Text((holiday.isToday ? "Today: " : "Next: ") + holiday.name + (holiday.isEstimated ? " (est.)" : ""))
                    .font(.caption2.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) { Color.clear }
    }

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.info.weekdayAmharic)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))

            Spacer()

            Text("\(entry.info.day)")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)

            Text(entry.info.monthNameAmharic)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)

            Text("\(entry.info.monthNameEnglish) \(entry.info.year)")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.8))

            if let holiday = entry.holiday {
                Text((holiday.isToday ? "★ " : "Next: ") + holiday.name + (holiday.isEstimated ? " (est.)" : ""))
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Color(red: 0.98, green: 0.84, blue: 0.25))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) {
            widgetBackground
        }
    }

    private var mediumView: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.info.weekdayAmharic)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                Text("\(entry.info.day)")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(entry.info.monthNameAmharic)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("\(entry.info.year) ዓ.ም.")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Color(red: 0.98, green: 0.84, blue: 0.25))
                Text("\(entry.info.monthNameEnglish) \(entry.info.day), \(entry.info.year)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.9))
                Text(entry.info.weekdayEnglish)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.75))
                Spacer()
                if let holiday = entry.holiday {
                    Text((holiday.isToday ? "Today: " : "Next: ") + holiday.name)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color(red: 0.98, green: 0.84, blue: 0.25))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    if holiday.isEstimated {
                        Text("Estimated date")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.75))
                    }
                }
                Text(EthiopianDateInfo.gregorianString(for: entry.date))
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            widgetBackground
        }
    }

    private var widgetBackground: some View {
        LinearGradient(
            colors: [Color(red: 0.08, green: 0.45, blue: 0.24), Color(red: 0.04, green: 0.24, blue: 0.14)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

@main
struct EthiopianCalendarWidget: Widget {
    let kind: String = "EthiopianCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EthiopianWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Ethiopian Calendar")
        .description("Shows today's Ethiopian date and upcoming holidays on the Home Screen and Lock Screen.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}
