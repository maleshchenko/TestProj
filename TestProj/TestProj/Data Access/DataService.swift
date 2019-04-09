import Foundation
import os.log

// Save/delete events, load all events from local storage
class DataService {

    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = DocumentsDirectory.appendingPathComponent(AppConfig.eventsDirectory)
    static let fileExtension = "plist"

    static var faveIDs = [NSNumber]()

    private static func filePath(for event: Event) -> URL {
        let fileName = "\(event.eventId)"
        let path = archiveURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)

        return path
    }

    public static func isFavorite(eventId: NSNumber) -> Bool {
        return faveIDs.contains(eventId)
    }

    public static func save(event: Event) {
        let path = DataService.filePath(for: event)

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: event, requiringSecureCoding: false)
            try data.write(to: path)
            faveIDs.append(event.eventId)
        } catch {
            os_log("Couldn't write to: %{public}@", path.absoluteString)
        }
    }

    public static func delete(event: Event) {
        let path = DataService.filePath(for: event)

        do {
             try FileManager.default.removeItem(at: path)
        } catch {
            os_log("Couldn'tdelete: %{public}@", path.absoluteString)
        }
    }

    public static func load() -> [Event] {
        var events = [Event]()

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: archiveURL, includingPropertiesForKeys: nil, options: [])
            let files = directoryContents.filter { $0.pathExtension == "plist" }
            for item in files {
                if let codedData = try? Data(contentsOf: item) {
                    if let event = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? Event,
                        let unarchivedEvent = event {
                        faveIDs.append(unarchivedEvent.eventId)
                        events.append(unarchivedEvent)
                    }
                }
            }

        } catch {
            // the directory is either empty or doesn't exist
        }

        return events
    }
}
