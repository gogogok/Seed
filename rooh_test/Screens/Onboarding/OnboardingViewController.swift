import UIKit

final class OnboardingViewController: UIViewController {
    
    typealias Model = OnboardingModel
    
    //MARK: - Constants
    private enum Constants {
        static let fatalError = "Creation Error"
        
        static let titleText = "What is your name?"
        static let placeholder = "Enter your name"
        static let buttonTitle = "Continue"
        
        static let titleTop: CGFloat = 120
        static let horizontalInset: CGFloat = 24
        static let textFieldTop: CGFloat = 32
        static let buttonTop: CGFloat = 24
        
        static let textFieldHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 44
        
        static let backgroundColorName = "NeumorphicBackground"
    }
    
    //MARK: - Fields
    var interactor: OnboardingBusinessLogic
    var onNameSaved: ((String) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = Constants.placeholder
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 18)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(interactor: OnboardingBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Constants.backgroundColorName) ?? .white
        configureUI()
        continueButton.addTarget(self, action: #selector(saveName), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(continueButton)
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTop)
        titleLabel.pinLeft(to: view, Constants.horizontalInset)
        titleLabel.pinRight(to: view, Constants.horizontalInset)
        
        nameTextField.pinTop(to: titleLabel.bottomAnchor, Constants.textFieldTop)
        nameTextField.pinLeft(to: view, Constants.horizontalInset)
        nameTextField.pinRight(to: view, Constants.horizontalInset)
        nameTextField.setHeight(Constants.textFieldHeight)
        
        continueButton.pinTop(to: nameTextField.bottomAnchor, Constants.buttonTop)
        continueButton.pinCenterX(to: view)
        continueButton.setHeight(Constants.buttonHeight)
    }
    
    @objc
    private func saveName() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        interactor.loadNextScreenTapped(Model.LoadNextScreen.Request(name: name))
    }
    
    func displayNextScreen(_ vc: Model.LoadNextScreen.ViewModel) {
        onNameSaved?(vc.name)
    }
}
