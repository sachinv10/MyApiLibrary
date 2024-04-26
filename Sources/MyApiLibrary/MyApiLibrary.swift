
import Foundation
import UIKit
import Alamofire

public protocol CustomViewDelegate: AnyObject {
    func didSelectItem(atIndex index: Int, user: [String: Any])
}

public class CustomView: UIView, UITableViewDelegate, UITableViewDataSource {
    public var currentPage = 1
    public var listView: UITableView!
    public var actionButton: UIButton!
    private var users: UserDataResponse?
   // private var users: [User] = []
    public weak var delegate: CustomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        fetchUsers(page: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        fetchUsers(page: 1)
    }
    
    private func setupViews() {
        listView = UITableView()
        listView.delegate = self
        listView.dataSource = self
        addSubview(listView)
        listView.frame = bounds
        
        actionButton = UIButton(type: .system)
        actionButton.setTitle("Return to App", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(actionButton)
        
        listView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: topAnchor),
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -8)
        ])
        
        // Add constraints for Button
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44) // Adjust height as needed
        ])
    }
    
    @objc private func buttonTapped() {
        removeFromSuperview()
        if users?.data.count ?? 0 > 0{
            let selectedUser = users!.data[0]
             let userDictionary: [String: Any] = [
                "id": selectedUser.id,
                "email": selectedUser.email,
                "firstName": selectedUser.first_name,
                "lastName": selectedUser.last_name,
                "avatar": selectedUser.avatar
            ]
            delegate?.didSelectItem(atIndex: 0, user: userDictionary)
        }
    }
    
       private func fetchUsers(page: Int) {
            let dataManager = DataManager()
            dataManager.fetchData (completion: { [self] result in
                switch result {
                case .success(let userDataResponse):
                    self.users = userDataResponse
                    self.listView.reloadData()
                      print("Fetched users: \(userDataResponse.data)")
                case .failure(let error):
                      print("Error fetching data: \(error)")
                }
            }, pageNo: page)
        }

    
    // MARK: - UITableViewDataSource methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.data.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if users!.data.count > 0{
            let user = users!.data[indexPath.row]
            cell.textLabel?.text = "\(user.first_name) \(user.last_name)"
            cell.detailTextLabel?.text = user.email
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
        public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
            if  5 == lastRowIndex{
                // Reached the last row, load next page
                currentPage += 1
                if currentPage < 3{
                    fetchUsers(page: currentPage)
                }
            }
        }
}

