import SwiftUI
import WidgetKit

struct WatchDateEntry: TimelineEntry {
    let date: Date
    let info: EthiopianDateInfo
    let holiday: EthiopianHoliday?
}

struct WatchDateProvider: TimelineProvider {
    func placeholder(in context: Context) -> WatchDateEntry { entry(for: Date()) }

    func getSnapshot(in context: Context, completion: @escaping (WatchDateEntry) -> Void) {
        completion(entry(for: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WatchDateEntry>) -> Void) {
        let now = Date()
        let midnight = Calendar.current.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0, second: 5),
            matchingPolicy: .nextTime
        ) ?? now.addingTimeInterval(3600)
        completion(Timeline(entries: [entry(for: now)], policy: .after(midnight)))
    }

    private func entry(for date: Date) -> WatchDateEntry {
        WatchDateEntry(date: date,
                       info: EthiopianDateInfo.from(date: date),
                       holiday: EthiopianHoliday.next(onOrAfter: date))
    }
}

struct WatchDateComplicationView: View {
    @Environment(\.widgetFamily) private var family
    let entry: WatchDateEntry
    private let green = Color(red: 0.72, green: 0.84, blue: 0.40)

    var body: some View {
        Group {
            switch family {
            case .accessoryCircular:
                VStack(spacing: 0) {
                    Text("\(entry.info.day)")
                        .font(.system(size: 27, weight: .bold, design: .rounded))
                    Text(entry.info.monthNameAmharic)
                        .font(.system(size: 9, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            case .accessoryInline:
                Text("\(entry.info.monthNameAmharic) \(entry.info.day) · \(entry.info.year) ዓ.ም.")
                    .lineLimit(1)
            default:
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("\(entry.info.day)")
                            .font(.system(size: 31, weight: .bold, design: .rounded))
                        VStack(alignment: .leading, spacing: 0) {
                            Text(entry.info.monthNameAmharic)
                                .font(.headline.weight(.bold))
                            Text("\(entry.info.year) ዓ.ም.")
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(green)
                        }
                    }
                    if let holiday = entry.holiday {
                        Text((holiday.isToday ? "TODAY · " : "NEXT · ") + holiday.name + (holiday.isEstimated ? " (est.)" : ""))
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .containerBackground(for: .widget) { Color.black }
    }
}

@main
struct EthiopianCalendarWatchWidget: Widget {
    let kind = "EthiopianCalendarWatchComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WatchDateProvider()) { entry in
            WatchDateComplicationView(entry: entry)
        }
        .configurationDisplayName("Ethiopian Calendar")
        .description("Ethiopian date and next holiday on your watch face.")
        .supportedFamilies([.accessoryRectangular, .accessoryCircular, .accessoryInline])
    }
}
