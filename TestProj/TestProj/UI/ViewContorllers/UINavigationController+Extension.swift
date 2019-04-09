import UIKit

// used by "details" part of split screen and a standalone navigation controller that displays "Details" on iPhone
extension UINavigationController {
    public func customizeNavBarAppearance() {

        //displaying "<" instead of "< Back"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

        //large multiline title
        for item in (self.navigationBar.subviews) {
            for sub in item.subviews {
                if let subLab = sub as? UILabel {
                    subLab.numberOfLines = 0
                    subLab.text = self.title
                    subLab.lineBreakMode = .byWordWrapping
                    subLab.textAlignment = .center
                }
            }
        }

        //hiding navbar "shadow" line
        self.navigationBar.shadowImage = UIImage()
    }
}
