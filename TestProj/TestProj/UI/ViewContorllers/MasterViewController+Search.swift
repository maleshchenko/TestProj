import UIKit

extension MasterViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // return to favorites
        self.events = DataService.load()
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text, !query.isEmpty {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            eventsService.search(query: query, completion: { [weak self] events in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self?.events = events
                }
            })
        }
    }
}
