
import UIKit

protocol UserListView {
    func setUsers(_ users: [User])
}

class UserListViewController: UITableViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Aa..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private var presenter: UserListPresentation?
    
    private var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter?.viewDidLoad()
    }
    
    private func setup() {
        navigationItem.titleView = searchBar
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifiler)
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
    }
    
    func inject(presenter: UserListPresentation) {
        self.presenter = presenter
    }
}

// MARK: - UITableView Delegate DataSource

extension UserListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifiler)!
        cell.imageView?.setImage(from: users[indexPath.row].avatarUrl)
        cell.textLabel?.text = users[indexPath.row].screenName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(user: users[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBar Delegate

extension UserListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.searchButtonClicked(value: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UserListView

extension UserListViewController: UserListView {
    
    func setUsers(_ users: [User]) {
        self.users = users
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
