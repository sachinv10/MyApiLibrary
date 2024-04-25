import UIKit
 public class MyApiLibrary: UIViewController {
    var tableView: UITableView!
    let button = UIButton(type: .system)
    var users: UserDataResponse?
      var currentPage = 1
      let perPage = 6 // Number of items per page
      var isLoaded : Bool = false
     var delegate: returnToApp?
//     public override func viewDidLoad() {
//        super.viewDidLoad()
//         MyApiLibrary.load()
//    }
     open func load(viewx: UIView){
         view = UIView(frame: viewx.bounds)
         viewx.addSubview(view)
        tableView = UITableView(frame: CGRect(x: 80, y: 300, width: 300, height: 200))
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
       setUi()
       fetchUsers(page: 1)
    }
    func setUi(){
            button.setTitle("Return to App", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.frame = CGRect(x: 100, y: 600, width: 200, height: 50)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            view.addSubview(button)
    }
    @objc func buttonTapped() {
          print("Button tapped!")
        button.removeFromSuperview()
        tableView.removeFromSuperview()
        delegate?.getData(email: users?.data.first?.email ?? "no email")
      }
    func fetchUsers(page: Int) {
        let dataManager = DataManager()
        dataManager.fetchData (completion: { [self] result in
            switch result {
            case .success(let userDataResponse):
                self.users = userDataResponse
                self.tableView.reloadData()
                  print("Fetched users: \(userDataResponse.data)")
            case .failure(let error):
                  print("Error fetching data: \(error)")
            }
        }, pageNo: page)
    }
}
extension MyApiLibrary: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.data.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let user = users?.data[indexPath.row]
        cell.textLabel?.text = user?.email
        // Customize cell as needed
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if  5 == lastRowIndex && isLoaded == false{
            // Reached the last row, load next page
            currentPage += 1
            if currentPage < 3{
                fetchUsers(page: currentPage)
            }
        }
    }
   
}

protocol returnToApp{
    func getData(email: String)
}
