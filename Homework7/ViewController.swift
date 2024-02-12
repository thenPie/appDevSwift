import UIKit
import WebKit
class ViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ViewController"
        setupUI()
        guard let url = URL(string: "https://oauth.vk.com/authorize?client_id=51578861&redirect_uri=https://oauth.vk.com/blank.html&scope=262150&display=mobile&response_type=token") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Theme.currentTheme.backgroundColor
    }
    private func setupUI() {
        view.addSubview(webView)
    }
}
extension ViewController {
    private func tap() {
        let tabl = UINavigationController(rootViewController: FriendsViewController())
        let tab2 = UINavigationController(rootViewController: GroupsViewController())
        let tab3 = UINavigationController(rootViewController: PhotosViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        tabl.tabBarItem.title = "Friends"
        tab2.tabBarItem.title = "Groups"
        tab3.tabBarItem.title = "Photos"
        let tabs = [tabl, tab2, tab3]
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = tabs
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let firstWindow = firstScene.windows.first else {
            return
        }
        firstWindow.rootViewController = tabBarController
    }
}
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "§")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        NetworkService.token = params["access_token"] ?? ""
        print(NetworkService.token)
        decisionHandler(.cancel)
        webView.removeFromSuperview()
        tap()
    }
}