import UIKit

class MasterViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private var detailViewController: DetailViewController?

    var events = [Event]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    let eventsService = EventsService(networking: NetworkService())

    // MARK: - UI

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        self.events = DataService.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.barTintColor = UIConstants.primaryColor

        if splitViewController!.isCollapsed {
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
    }

    private func setupUI() {
        tableView.register(EventCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self

        // hiding empty rows
        tableView.tableFooterView = UIView(frame: .zero)

        setupSearch()

        if let split = splitViewController {
            let controllers = split.viewControllers
            if let navController = controllers[controllers.count - 1] as? CustomNavigationController,
                let topController = navController.topViewController as? DetailViewController {
                detailViewController = topController
            }
        }
    }

    private func setupSearch() {
        // using the same tableView for both search resutls and favorites
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = events[indexPath.row]
                if let destaination = segue.destination as? UINavigationController {
                    let controller = destaination.topViewController as? DetailViewController
                    controller?.event = object
                    controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller?.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
}

extension UISplitViewController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        let master = viewControllers.first
        
        return master?.preferredStatusBarStyle ?? .lightContent
    }
}
