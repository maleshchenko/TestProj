import UIKit

class EventCell: UITableViewCell {
    static let cellId = "EventCell"

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var favoriteIndicatorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private(set) lazy var img: UIImage = {
        return UIImage()
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(event: Event) {
        if DataService.isFavorite(eventId: event.eventId) {
            event.isFavorite = true
        }

        favoriteIndicatorImageView.isHidden = !event.isFavorite
        titleLabel.text = event.title
        locationLabel.text = event.location

        if let eventDate = event.date {
            dateLabel.text = DateFormatUtils.displayableTime(for: eventDate)
        }

        if let imgUrl = event.imageUrl {
            thumbnailImageView.setImage(url: imgUrl)
        } else {
            thumbnailImageView.image = UIImage(named: UIConstants.placeholderImage)
        }
    }
}
