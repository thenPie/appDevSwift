import UIKit
protocol GroupCellProtocol {
    func updateCell(group: Group)
}
final class GroupCell: UITableViewCell, GroupCellProtocol {
    private var groupAvatar: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    private var groupName: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.textColor = Theme.currentTheme.textColor
        return label
    }()
    private var groupDescription: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textAlignment = .left
        label.textColor = Theme.currentTheme.textColor
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupUI()
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateCell(group: Group) {
        groupName.text = group.name
        groupDescription.text = group.description
        groupName.textColor = Theme.currentTheme.textColor
        groupDescription.textColor = Theme.currentTheme.textColor
        DispatchQueue.global().async {
            if let url = URL(string: group.photo), let image = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.groupAvatar.image = UIImage(data: image)
                }
            }
        }
    }
}
extension GroupCell {
    private func setupUI() {
        contentView.addSubview(groupAvatar)
        contentView.addSubview(groupName)
        contentView.addSubview(groupDescription)
    }
    private func addConstraints() {
        groupAvatar.translatesAutoresizingMaskIntoConstraints = false
        groupName.translatesAutoresizingMaskIntoConstraints = false
        groupDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            groupAvatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            groupAvatar.heightAnchor.constraint(equalToConstant: 40),
            groupAvatar.widthAnchor.constraint(equalTo: groupAvatar.heightAnchor),
            groupName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            groupName.leftAnchor.constraint(equalTo: groupAvatar.rightAnchor, constant: 30),
            groupName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            groupDescription.topAnchor.constraint(equalTo: groupName.bottomAnchor, constant: 10),
            groupDescription.leftAnchor.constraint(equalTo: groupName.leftAnchor),
            groupDescription.rightAnchor.constraint(equalTo: groupName.rightAnchor),
            groupDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}