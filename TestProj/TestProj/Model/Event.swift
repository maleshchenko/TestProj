import Foundation

final class Event: NSObject, NSCoding {
    var eventId: NSNumber = 0
    var isFavorite: Bool = false
    var imageUrl: URL?
    var title: String?
    var location: String?
    var date: String?

    enum CodingKeys: String, CodingKey {
        case eventId
        case title
        case imageUrl
        case location
        case date
        case isFavorite
    }

    convenience init(dict: [String: Any]) {
        let eventId = dict[ModelConstants.eventId] as? NSNumber ?? 0
        let title = dict[ModelConstants.title] as? String
        let performers = dict[ModelConstants.performers] as? [[String: Any]]
        let imageUrl = URL(string: performers?.first?[ModelConstants.image] as? String ?? "")
        let location = (dict as NSDictionary).value(forKeyPath: ModelConstants.location) as? String
        let date = dict[ModelConstants.date] as? String
        let isFavorite = false

        self.init(eventId: eventId, title: title, imageUrl: imageUrl, location: location, date: date, isFavorite: isFavorite)
    }

    init(eventId: NSNumber, title: String?, imageUrl: URL?, location: String?, date: String?, isFavorite: Bool = false) {
        self.eventId = eventId
        self.title = title
        self.imageUrl = imageUrl
        self.location = location
        self.date = date
        self.isFavorite = isFavorite
    }

    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(eventId, forKey: CodingKeys.eventId.rawValue)
        aCoder.encode(title, forKey: CodingKeys.title.rawValue)
        aCoder.encode(imageUrl?.absoluteString, forKey: CodingKeys.imageUrl.rawValue)
        aCoder.encode(location, forKey: CodingKeys.location.rawValue)
        aCoder.encode(date, forKey: CodingKeys.date.rawValue)
        aCoder.encode(isFavorite, forKey: CodingKeys.isFavorite.rawValue)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let eventId = aDecoder.decodeObject(of: NSNumber.self, forKey: CodingKeys.eventId.rawValue)
        let title = aDecoder.decodeObject(forKey: CodingKeys.title.rawValue) as? String ?? ""
        let imgUrlString = aDecoder.decodeObject(forKey: CodingKeys.imageUrl.rawValue) as? String ?? ""
        let imageUrl = URL(string: imgUrlString)
        let location = aDecoder.decodeObject(forKey: CodingKeys.location.rawValue) as? String ?? ""
        let date = aDecoder.decodeObject(forKey: CodingKeys.date.rawValue) as? String ?? ""
        let isFavorite = aDecoder.decodeObject(forKey: CodingKeys.isFavorite.rawValue) as? Bool ?? true

        self.init(eventId: eventId ?? 0, title: title, imageUrl: imageUrl, location: location, date: date, isFavorite: isFavorite)
    }
}
