import UIKit

class CustomNavigationController: UINavigationController {

    var needsToUpdateTitleLabel = true

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if needsToUpdateTitleLabel && !Utils.isiPad() {
            updateAppearance()
        }
        needsToUpdateTitleLabel = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateAppearance()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //setting back to darkgreen
        self.navigationController?.navigationBar.barTintColor = UIConstants.primaryColor
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.needsToUpdateTitleLabel = UIDevice.current.orientation.isPortrait
    }

    private func updateAppearance() {
        self.navigationController?.navigationBar.barTintColor = UIConstants.secondaryColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic

        self.navigationController?.navigationBar.largeTitleTextAttributes = Utils.titleAttributes(large: true)
        self.navigationController?.navigationBar.titleTextAttributes = Utils.titleAttributes(large: false)

        self.navigationController?.customizeNavBarAppearance()
    }
}

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if viewControllers.count == 1 {
            return .lightContent
        }

        return .default
    }
 }
