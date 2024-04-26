//import UIKit


// public class MyApiLibrary: UIViewController {
//    var tableView: UITableView!
//    let button = UIButton(type: .system)
//    var users: UserDataResponse?
//      var currentPage = 1
//      let perPage = 6 // Number of items per page
//      var isLoaded : Bool = false
//      var delegate: returnToApp?
//    public init() {
//        super.init(nibName: nil, bundle: nil)
//     }
//     
//     required init?(coder: NSCoder) {
//         fatalError("init(coder:) has not been implemented")
//     }
//     //     public override func viewDidLoad() {
////        super.viewDidLoad()
////         MyApiLibrary.load()
////    }
//     
//     open func load(viewx: UIView){
//         view = UIView(frame: viewx.bounds)
//         viewx.addSubview(view)
//        tableView = UITableView(frame: CGRect(x: 80, y: 300, width: 300, height: 200))
//        tableView.dataSource = self
//        tableView.delegate = self
//        view.addSubview(tableView)
//       setUi()
//       fetchUsers(page: 1)
//    }
//    func setUi(){
//            button.setTitle("Return to App", for: .normal)
//            button.setTitleColor(.blue, for: .normal)
//            button.frame = CGRect(x: 100, y: 600, width: 200, height: 50)
//            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//            view.addSubview(button)
//    }
//    @objc func buttonTapped() {
//          print("Button tapped!")
//        button.removeFromSuperview()
//        tableView.removeFromSuperview()
//        delegate?.getData(email: users?.data.first?.email ?? "no email")
//      }
//    func fetchUsers(page: Int) {
//        let dataManager = DataManager()
//        dataManager.fetchData (completion: { [self] result in
//            switch result {
//            case .success(let userDataResponse):
//                self.users = userDataResponse
//                self.tableView.reloadData()
//                  print("Fetched users: \(userDataResponse.data)")
//            case .failure(let error):
//                  print("Error fetching data: \(error)")
//            }
//        }, pageNo: page)
//    }
//}
//extension MyApiLibrary: UITableViewDataSource, UITableViewDelegate {
//    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return users?.data.count ?? 0
//    }
//    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
//        let user = users?.data[indexPath.row]
//        cell.textLabel?.text = user?.email
//        // Customize cell as needed
//        return cell
//    }
//    
//    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
//        if  5 == lastRowIndex && isLoaded == false{
//            // Reached the last row, load next page
//            currentPage += 1
//            if currentPage < 3{
//                fetchUsers(page: currentPage)
//            }
//        }
//    }
//   
//}
//
//protocol returnToApp{
//    func getData(email: String)
//}


//public struct MyApiPackage {
//    public private(set) var text = "Hello, World!"
//
//    public init() {
//    }
//}
import Foundation
import UIKit
import Alamofire

public protocol CustomViewDelegate: AnyObject {
    func didSelectItem(atIndex index: Int, user: [String: Any])
    func customView(_ customView: CustomView, didSelectUser user: [String: Any])
}

public class CustomView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    public var listView: UITableView!
    public var actionButton: UIButton!
    
    private var users: [User] = []
    public weak var delegate: CustomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        fetchUsers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        fetchUsers()
    }
    
    private func setupViews() {
        listView = UITableView()
        listView.delegate = self
        listView.dataSource = self
        addSubview(listView)
        listView.frame = bounds
        
        actionButton = UIButton(type: .system)
        actionButton.setTitle("Back To Main", for: .normal)
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
    }
    
    private func fetchUsers() {
        AF.request("https://reqres.in/api/users?page=1").responseDecodable(of: UserResponse.self) { response in
            switch response.result {
            case .success(let userResponse):
                self.users = userResponse.data
                self.listView.reloadData()
            case .failure(let error):
                print("Error fetching users: \(error)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let user = users[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.detailTextLabel?.text = user.email
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                    
        let selectedUser = users[indexPath.row]
        let userDictionary: [String: Any] = [
            "id": selectedUser.id,
            "email": selectedUser.email,
            "firstName": selectedUser.firstName,
            "lastName": selectedUser.lastName,
            "avatar": selectedUser.avatar
        ]
        delegate?.didSelectItem(atIndex: indexPath.row, user: userDictionary)
        removeFromSuperview()
//        delegate?.customView(self, didSelectUser: userDictionary)
    }
    
}

struct User: Decodable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String

    private enum CodingKeys: String, CodingKey {
        case id = "id", email = "email", firstName = "first_name", lastName = "last_name", avatar = "avatar"
    }
}

struct UserResponse: Decodable {
    let data: [User]
}
