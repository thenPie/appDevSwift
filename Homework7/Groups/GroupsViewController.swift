import UIKit
protocol GroupsViewControllerProtocol {
    func getGroups()
    func showAlert()
}
final class GroupsViewController: UITableViewController, GroupsViewControllerProtocol {
    private let networkService = NetworkService()
    private var coreDataService = CoreDataService()
    private var model: [Group] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        title = "Groups"
        tableView.register(GroupCell.self, forCellReuseIdentifier: "cell")
        getGroups()
    }
    func getGroups() {
        networkService.getGroups { [weak self] result in
            switch result {
            case .success(let groups):
                self?.model = groups
                self?.coreDataService.saveGroups(groups: groups)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(_):
                self?.model = self?.coreDataService.getGroups() ?? []
                DispatchQueue.main.async {
                    self?.showAlert()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupCell else {
            return UITableViewCell()
        }
        cell.updateCell(group: model[indexPath.row])
        return cell
    }
    func showAlert() {
        let date = DateHelper.getDate(date: coreDataService.getGroupsDate())
        let alert = UIAlertController(
            title: "Не удалось получить данные",
            message: "Данные актуальны на \(date)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}