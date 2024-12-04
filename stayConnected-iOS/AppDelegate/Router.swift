import UIKit

final class Router: UIViewController {
    private let keychainService: KeychainService
    
    init(keychainService: KeychainService = KeychainService()) {
        self.keychainService = keychainService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start()
    }
    
    func start() {
        do {
            let isToken = try keychainService.checkAccessToken()
            
            if isToken {
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                sceneDelegate?.window?.rootViewController = TabBarController()
            } else {
                navigationController?.pushViewController(LoginVC(), animated: false)
            }
        } catch {
            print("Error checking token: \(error)")
            navigationController?.pushViewController(LoginVC(), animated: false)
        }
    }
}
