import Foundation
import os.log

struct EventQueryParams {
    static let clientId = "client_id"
    static let query = "q"
}

// fetch Events from remove host
final class EventsService {
    private let baseUrl = URL(string: "https://api.seatgeek.com/2/events")!
    private let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    @discardableResult func search(query: String, completion: @escaping ([Event]) -> Void) -> URLSessionTask? {
        let resource = Resource(url: baseUrl, parameters: [
            EventQueryParams.clientId: AppConfig.apiKey,
            EventQueryParams.query: query
        ])

        return networking.fetch(resource: resource, completion: { data in
            DispatchQueue.main.async {
                if let dataToParse = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: dataToParse, options: [])
                        if let textVal = json as? [String: Any],
                            let testVal = textVal[AppConfig.eventsKey] as? [[String: Any]] {
                            // Parsing into Events
                            let events = testVal.map { Event(dict: $0) }
                            completion(events)
                        }
                    } catch {
                        os_log("Couldn't load events: %{public}@", error.localizedDescription)
                        completion([Event]())
                    }
                }
            }
        })
    }
}
