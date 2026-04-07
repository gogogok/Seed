import UIKit

final class SimpleInfoViewController: UIViewController {
    
    //MARK: - Constants
    private enum Constants {
        static let fatalError = "Creation error"
        
        static let horizontalInset: CGFloat = 24
        static let fontSize: CGFloat = 20
        
        static let bgColorName = "NeumorphicBackground"
    }
    
    //MARK: - Filds
    private let titleText: String
    private let messageText: String
    
    //MARK: - Lyfecycle
    init(titleText: String, messageText: String) {
        self.titleText = titleText
        self.messageText = messageText
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Creation error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "NeumorphicBackground") ?? .systemBackground
        title = titleText
        
        let label = UILabel()
        label.text = messageText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .darkGray
        
        view.addSubview(label)
        
        label.pinLeft(to: view, Constants.horizontalInset)
        label.pinRight(to: view, Constants.horizontalInset)
        label.pinCenterY(to: view)
    }
}
