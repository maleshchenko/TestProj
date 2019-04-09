import UIKit
import os.log

// Check local cache and fetch remote image
final class ImageService {

    private let networkService: Networking
    private let cacheService: CacheService
    private var task: URLSessionTask?
    private let imageBaseUrl = "https://seatgeek.com/images/"

    init(networkService: Networking, cacheService: CacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    // Fetch image from url
    func fetch(url: URL, completion: @escaping (UIImage?) -> Void) {
        // Cancel existing task if any
        task?.cancel()

        //Setting acceptable filename
        let filename = url.absoluteString.replacingOccurrences(of: imageBaseUrl, with: "").replacingOccurrences(of: "/", with: "-")

        // Try to load from cache
        cacheService.load(key: filename, completion: { [weak self] cachedData in
            if let data = cachedData, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                // Try to request from network
                let resource = Resource(url: url)
                self?.task = self?.networkService.fetch(resource: resource, completion: { networkData in
                    if let data = networkData, let image = UIImage(data: data) {
                        // Save to cache
                        self?.cacheService.save(data: data, key: filename)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                })

                self?.task?.resume()
            }
        })
    }
}
