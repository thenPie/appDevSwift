import UIKit
protocol FriendCellProtocol {
    func updateCell(friend: Friend)
}
final class FriendCell: UITableViewCell, FriendCellProtocol {
    var tap: ((String?, UIImage?) -> Void)?
    private var friendAvatar: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    private var friendName: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.textColor = Theme.currentTheme.textColor
        return label
    }()
    private var friendIsOnline: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(cellClick))
        addGestureRecognizer(recognizer)
        setupUI()
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateCell(friend: Friend) {
        friendName.text = friend.firstName + " " + friend.lastName
        friendName.textColor = Theme.currentTheme.textColor
        friendIsOnline.backgroundColor = friend.online == 1 ? .green : .red
        DispatchQueue.global().async {
            if let url = URL(string: friend.photo), let image = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.friendAvatar.image = UIImage(data: image)
                }
            }
        }
    }
}
private extension FriendCell {
    private func setupUI() {
        contentView.addSubview(friendAvatar)
        contentView.addSubview(friendName)
        contentView.addSubview(friendIsOnline)
    }
    private func addConstraints() {
        friendAvatar.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        friendIsOnline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendAvatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            friendAvatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            friendAvatar.heightAnchor.constraint(equalToConstant: 40),
            friendAvatar.widthAnchor.constraint(equalTo: friendAvatar.heightAnchor),
            friendName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            friendName.leftAnchor.constraint(equalTo: friendAvatar.rightAnchor, constant: 30),
            friendName.rightAnchor.constraint(equalTo: friendIsOnline.leftAnchor, constant: -10),
            friendIsOnline.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            friendIsOnline.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            friendIsOnline.heightAnchor.constraint(equalToConstant: 10),
            friendIsOnline.widthAnchor.constraint(equalTo: friendIsOnline.heightAnchor),
        ])
    }
}
private extension FriendCell {
    @objc private func cellClick() {
        tap?(friendName.text, friendAvatar.image)
    }
}