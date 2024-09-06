import UIKit
import ChatBot
import SwiftUI

class DemoViewController: UIViewController {

    // MARK: - PROPERTIES
    var hostingController: UIHostingController<LaunchView>?
    
    lazy var launchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Launch Chat Bot", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(launchButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return button
    }()
    
    // MARK: MAIN -
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(launchButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            launchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            launchButton.heightAnchor.constraint(equalToConstant: 50),
            launchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            launchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func launchButtonTapped(){
        
        let appConfig = AppConfigurationManager(
            chatBotId: "YOUR CHAT BOT ID",
            userId: "YOUR USER ID",
            appSecret: "YOUR APP SECRET ID",
            licenseKey: "YOUR LICENSE KEY",
            storeCategoryId: "YOUR STORE CATEGORY ID"
        )

        let launchViewModel = LaunchViewModel(appConfigurations: appConfig, delegate: self)
        let launchView = LaunchView(viewModel: launchViewModel)
        
        hostingController = UIHostingController(rootView: launchView)
        if let hostingController {
            hostingController.modalPresentationStyle = .fullScreen
            self.present(hostingController, animated: true, completion: nil)
        }
        
    }

}

extension DemoViewController: ChatBotDelegate {
    
    func navigateFromBot(withData: ChatBotWidget?, forType: WidgetType?) {
        DispatchQueue.main.async {
            if let hostingController = self.hostingController {
                let controller = MyViewController()
                hostingController.present(controller, animated: true, completion: nil)
            }
        }
    }
    
}
