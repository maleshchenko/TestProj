import UIKit

class Utils {
    static func isiPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    // large/regular navBar title
    static func titleAttributes(large: Bool) -> [NSAttributedString.Key: Any] {
        let fontSize = large ? UIConstants.largeTitleSize : UIConstants.regularTitleSize

        return [NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold)]
    }
}
