import UIKit
protocol ProfileViewControllerProtocol {
    func updateProfile(profile: Profile)
}
class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private let networkService = NetworkService()
    private var themeView = ThemeView()
    private var isUserProfile: Bool
    private var profileImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        return view
    }()
    private var profileName: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .center
        label.textColor = Theme.currentTheme.textColor
        return label
    }()
    init(name: String? = nil, photo: UIImage? = nil, isUserProfile: Bool) {
        self.isUserProfile = isUserProfile
        super.init(nibName: nil, bundle: nil)
        self.profileName.text = name
        self.profileImage.image = photo
        themeView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.currentTheme.backgroundColor
        setupUI()
        addConstraints()
        if isUserProfile {
            networkService.getProfileInfo { [weak self] profile in
                print(profile)
                self?.updateProfile(profile: profile)
            }
        }
        else {
            themeView.isHidden = true
        }
    }
    func updateProfile(profile: Profile) {
        DispatchQueue.global().async {
            if let url = URL(string: profile.photo ?? ""), let image = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.profileName.text = profile.firstName + " " + profile.lastName
                    self.profileImage.image = UIImage(data: image)
                }
            }
        }
    }
}
extension ProfileViewController {
    private func setupUI() {
        view.addSubview(profileImage)
        view.addSubview(profileName)
        view.addSubview(themeView)
        themeView.backgroundColor = .lightGray
    }
    private func addConstraints() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileName.translatesAutoresizingMaskIntoConstraints = false
        themeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            profileName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            themeView.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 30),
            themeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            themeView.rightAnchor.constraint(equalTo: view.rightAnchor),
            themeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
extension ProfileViewController: ThemeViewDelegate {
    func updateTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        profileName.textColor = Theme.currentTheme.textColor
    }
}