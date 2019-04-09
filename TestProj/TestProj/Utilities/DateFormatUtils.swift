import Foundation

struct DateFormatUtils {

    static let localTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM YYYY HH:mm a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.autoupdatingCurrent

        return formatter
    }()

    static let remoteTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.autoupdatingCurrent

        return formatter
    }()

    static func displayableTime(for string: String) -> String {
        if let date = remoteTime.date(from: string) {
            return localTime.string(from: date)
        }

        return ""
    }
}
