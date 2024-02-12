import UIKit
protocol ThemeViewDelegate: AnyObject {
    func updateTheme()
}
final class ThemeView: UIView {
    weak var delegate: ThemeViewDelegate?
    private var buttonWhite: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = WhiteTheme().backgroundColor
        return button
    }()
    private var buttonBlue: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = BlueTheme().backgroundColor
        return button
    }()
    private var buttonGreen: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = GreenTheme().backgroundColor
        return button
    }()
    init() {
        super.init(frame: .zero)
        backgroundColor = Theme.currentTheme.backgroundColor
        buttonWhite.addTarget(self, action: #selector(tapWhite), for: .touchUpInside)
        buttonBlue.addTarget(self, action: #selector(tapBlue), for: .touchUpInside)
        buttonGreen.addTarget(self, action: #selector(tapGreen), for: .touchUpInside)
        setupUI()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension ThemeView {
    func setupUI() {
        addSubview(buttonWhite)
        addSubview(buttonBlue)
        addSubview(buttonGreen)
    }
    func setupConstraints() {
        buttonWhite.translatesAutoresizingMaskIntoConstraints = false
        buttonBlue.translatesAutoresizingMaskIntoConstraints = false
        buttonGreen.translatesAutoresizingMaskIntoConstraints = false
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 50
        NSLayoutConstraint.activate([
            buttonWhite.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonWhite.bottomAnchor.constraint(equalTo: buttonBlue.topAnchor, constant: -20),
            buttonWhite.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonWhite.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonBlue.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonBlue.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonBlue.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonBlue.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonGreen.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonGreen.topAnchor.constraint(equalTo: buttonBlue.bottomAnchor, constant: 20),
            buttonGreen.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonGreen.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
}
private extension ThemeView {
    @objc func tapWhite() {
        Theme.currentTheme = WhiteTheme()
        delegate?.updateTheme()
    }
    @objc func tapBlue() {
        Theme.currentTheme = BlueTheme()
        delegate?.updateTheme()
    }
    @objc func tapGreen() {
        Theme.currentTheme = GreenTheme()
        delegate?.updateTheme()
    }
}