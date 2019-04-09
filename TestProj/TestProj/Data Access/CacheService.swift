import Foundation
import os.log

// Save and load data to memory and disk cache
final class CacheService {

    private let diskPath: URL
    private let memory = NSCache<NSString, NSData>()
    private let fileManager: FileManager
    private let serialQueue = DispatchQueue(label: AppConfig.eventsKey)

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        do {
            let documentDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            diskPath = documentDirectory.appendingPathComponent(AppConfig.eventsDirectory)
            try createDirectoryIfNeeded()
        } catch {
            fatalError()
        }
    }

    func save(data: Data, key: String, completion: (() -> Void)? = nil) {
        serialQueue.async {
            self.memory.setObject(data as NSData, forKey: key as NSString)
            do {
                try data.write(to: self.filePath(key: key))
                completion?()
            } catch {
                os_log("Error saving image: %{public}@", key)
            }
        }
    }

    func load(key: String, completion: @escaping (Data?) -> Void) {
        serialQueue.async {
            if let data = self.memory.object(forKey: key as NSString) {
                completion(data as Data)
                
                return
            }

            if let data = try? Data(contentsOf: self.filePath(key: key)) {
                self.memory.setObject(data as NSData, forKey: key as NSString)
                completion(data)
                
                return
            }

            completion(nil)
        }
    }

    private func filePath(key: String) -> URL {
        return diskPath.appendingPathComponent(key)
    }

    private func createDirectoryIfNeeded() throws {
        if !fileManager.fileExists(atPath: diskPath.path) {
            try fileManager.createDirectory(at: diskPath, withIntermediateDirectories: false, attributes: nil)
        }
    }
}
