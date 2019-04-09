import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    var event: Event? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        if let detail = event, let imageView = imageView, let timeLabel = timeLabel, let locationLabel = locationLabel {

            //initially, everything in details screen is hidden
            imageView.isHidden = false
            timeLabel.isHidden = false
            locationLabel.isHidden = false

            if let imageUrl = detail.imageUrl {
                imageView.setImage(url: imageUrl)
            }

            if let eventDate = detail.date {
                timeLabel.text = DateFormatUtils.displayableTime(for: eventDate)
            }

            locationLabel.text = detail.location
            self.title = detail.title

            let rightButton = UIButton(type: .system)
            rightButton.setBackgroundImage(buttonImage(isFavorite: event?.isFavorite ?? false), for: .normal)
            rightButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
            let rightButtonItem = UIBarButtonItem(customView: rightButton)
            navigationItem.rightBarButtonItem = rightButtonItem
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.customizeNavBarAppearance()
    }

    @objc func favorite() {
        if let event = self.event {
            let isFav = event.isFavorite
            self.event?.isFavorite = !isFav
            (self.event?.isFavorite ?? false) ? DataService.save(event: event) : DataService.delete(event: event)

            let buttomItem = navigationItem.rightBarButtonItem
            let button = buttomItem?.customView as? UIButton
            button?.setBackgroundImage(buttonImage(isFavorite: event.isFavorite), for: .normal)
        }
    }

    private func buttonImage(isFavorite: Bool) -> UIImage? {
        let imageName = isFavorite ? UIConstants.favoriteImage : UIConstants.unfavoriteImage
        
        return UIImage(named: imageName, in: nil, compatibleWith: nil)
    }
}
