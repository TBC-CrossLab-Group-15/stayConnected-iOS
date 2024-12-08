import UIKit

final class Router: UIViewController {
    private let keychainService: KeychainService
    private let tokenNetwork: TokenNetwork
    
    init(
        keychainService: KeychainService = KeychainService(),
        tokenNetwork: TokenNetwork = TokenNetwork()
    ) {
        self.keychainService = keychainService
        self.tokenNetwork = tokenNetwork
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .starterCol
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checTokenLife()
    }

    
    private func checTokenLife() {
        Task {
            do {
                try await tokenNetwork.getNewToken()
                
                DispatchQueue.main.async {
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = TabBarController()
                }
            } catch {
                DispatchQueue.main.async {[weak self] in
                    self?.navigationController?.pushViewController(LoginVC(), animated: false)
                }
            }
        }
    }
}
