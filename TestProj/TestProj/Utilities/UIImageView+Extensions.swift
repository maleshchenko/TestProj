import UIKit

extension UIImageView {
    func setImage(url: URL) {
        if imageService == nil {
            imageService = ImageService(networkService: NetworkService(), cacheService: CacheService())
        }

        self.imageService?.fetch(url: url, completion: { [weak self] image in
            self?.image = image
        })
    }

    private var imageService: ImageService? {
        get {
            return objc_getAssociatedObject(self, &AssociateKey.imageService) as? ImageService
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociateKey.imageService,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

private struct AssociateKey {
    static var imageService = 0
}
