import UIKit

final class CreateHabitViewController: UIViewController {
    
    typealias Model = CreateHabitModel
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Creation error"
        
        static let playFairDisplayFont: String = "PlayfairDisplay-Regular"
        static let playFairDisplayBoldFont: String = "PlayfairDisplay-Regular_Bold"
        
        static let screenTitle: String = "New habit"
        static let backButtonTitle: String = "Back"
        
        static let titleLabelText: String = "Name the habit"
        static let textFieldPlaceholder: String = "For example: running"
        static let iconTitleLabelText: String = "Choose an icon"
        static let saveButtonTitle: String = "Create"
        static let defaultHabitName: String = "Magic habit"
        static let defaultSelectedImageName: String = "default_task"
        
        static let titleFontSize: CGFloat = 18
        static let saveButtonFontSize: CGFloat = 18
        
        static let titleTopInset: CGFloat = 30
        static let horizontalInset: CGFloat = 25
        static let textFieldContainerTopInset: CGFloat = 15
        static let textFieldHorizontalInset: CGFloat = 15
        static let textFieldContainerHeight: CGFloat = 60
        
        static let iconTitleTopInset: CGFloat = 30
        static let iconGridTopInset: CGFloat = 15
        static let stackSpacing: CGFloat = 14
        
        static let saveButtonBottomInset: CGFloat = 30
        static let saveButtonHeight: CGFloat = 55
        static let saveButtonCornerRadius: CGFloat = 20
        
        static let textFieldContainerShadowRadius: CGFloat = 15
        
        static let iconButtonSize: CGFloat = 72
        static let iconCornerRadius: CGFloat = 20
        static let iconBorderWidth: CGFloat = 2
        static let selectedIconBorderWidth: CGFloat = 3
        static let defaultIconAlpha: CGFloat = 0.7
        static let selectedIconAlpha: CGFloat = 1.0
        
        static let titleTextColor: UIColor = .darkGray
        static let iconTitleTextColor: UIColor = .darkGray
        
        static let backgroundColorName: String = "NeumorphicBackground"
        static let textFieldContainerColorName: String = "NeumorphicAccentPink"
        static let accentColorName: String = "LeafColor"
        
        static let habitIcons: [String] = [
            "book",
            "food",
            "meditation",
            "run",
            "drop",
            "default_task"
        ]
    }
    
    // MARK: - CallBacks
    var onHabitCreated: (() -> Void)?
    
    // MARK: - Fields
    var interactor: CreateHabitBusinessLogic
    
    private let habitIcons = Constants.habitIcons
    private var selectedImageName: String = Constants.defaultSelectedImageName
    private var iconButtons: [UIButton] = []
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleLabelText
        label.font = UIFont(name: Constants.playFairDisplayBoldFont, size: Constants.titleFontSize)
        label.textColor = Constants.titleTextColor
        return label
    }()
    
    private let textFieldContainer = UIView()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = Constants.textFieldPlaceholder
        tf.borderStyle = .none
        return tf
    }()
    
    private let iconTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.iconTitleLabelText
        label.font = UIFont(name: Constants.playFairDisplayBoldFont, size: Constants.titleFontSize)
        label.textColor = Constants.iconTitleTextColor
        return label
    }()
    
    private let iconGridContainer = UIView()
    
    private lazy var firstRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Constants.stackSpacing
        return stack
    }()
    
    private lazy var secondRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Constants.stackSpacing
        return stack
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.saveButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.saveButtonFontSize, weight: .bold)
        button.backgroundColor = UIColor(named: Constants.accentColorName)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.saveButtonCornerRadius
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Constants.backgroundColorName)
        setupLayout()
        setupNav()
        addActionForSaveButton()
        setupIconPicker()
        updateSelectedIconUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldContainer.addNeumorphicShadow(
            radius: Constants.textFieldContainerShadowRadius,
            bgColor: Constants.textFieldContainerColorName
        )
    }
    
    init(interactor: CreateHabitBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    // MARK: - Setup
    private func setupNav() {
        title = Constants.screenTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.backButtonTitle,
            style: .plain,
            target: self,
            action: #selector(dismissVC)
        )
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(textFieldContainer)
        textFieldContainer.addSubview(textField)
        view.addSubview(iconTitleLabel)
        view.addSubview(iconGridContainer)
        iconGridContainer.addSubview(firstRowStack)
        iconGridContainer.addSubview(secondRowStack)
        view.addSubview(saveButton)
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopInset)
        titleLabel.pinLeft(to: view, Constants.horizontalInset)
        
        textFieldContainer.pinTop(to: titleLabel.bottomAnchor, Constants.textFieldContainerTopInset)
        textFieldContainer.pinLeft(to: view, Constants.horizontalInset)
        textFieldContainer.pinRight(to: view, Constants.horizontalInset)
        textFieldContainer.setHeight(Constants.textFieldContainerHeight)
        
        textField.pinLeft(to: textFieldContainer, Constants.textFieldHorizontalInset)
        textField.pinRight(to: textFieldContainer, Constants.textFieldHorizontalInset)
        textField.pinCenterY(to: textFieldContainer)
        
        iconTitleLabel.pinTop(to: textFieldContainer.bottomAnchor, Constants.iconTitleTopInset)
        iconTitleLabel.pinLeft(to: view, Constants.horizontalInset)
        
        iconGridContainer.pinTop(to: iconTitleLabel.bottomAnchor, Constants.iconGridTopInset)
        iconGridContainer.pinLeft(to: view, Constants.horizontalInset)
        iconGridContainer.pinRight(to: view, Constants.horizontalInset)
        
        firstRowStack.pinTop(to: iconGridContainer)
        firstRowStack.pinLeft(to: iconGridContainer)
        firstRowStack.pinRight(to: iconGridContainer)
        
        secondRowStack.pinTop(to: firstRowStack.bottomAnchor, Constants.stackSpacing)
        secondRowStack.pinLeft(to: iconGridContainer)
        secondRowStack.pinRight(to: iconGridContainer)
        secondRowStack.pinBottom(to: iconGridContainer)
        
        saveButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.saveButtonBottomInset)
        saveButton.pinLeft(to: view, Constants.horizontalInset)
        saveButton.pinRight(to: view, Constants.horizontalInset)
        saveButton.setHeight(Constants.saveButtonHeight)
    }
    
    private func setupIconPicker() {
        for (index, imageName) in habitIcons.enumerated() {
            let button = makeIconButton(imageName: imageName, tag: index)
            iconButtons.append(button)
            
            if index < 3 {
                firstRowStack.addArrangedSubview(button)
            } else {
                secondRowStack.addArrangedSubview(button)
            }
        }
    }
    
    private func makeIconButton(imageName: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = tag
        button.backgroundColor = .clear
        button.layer.cornerRadius = Constants.iconCornerRadius
        button.layer.borderWidth = Constants.iconBorderWidth
        button.layer.borderColor = UIColor.clear.cgColor
        button.clipsToBounds = true
        
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setHeight(Constants.iconButtonSize)
        
        button.addTarget(self, action: #selector(iconTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func addActionForSaveButton() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func updateSelectedIconUI() {
        for (index, button) in iconButtons.enumerated() {
            let isSelected = habitIcons[index] == selectedImageName
            button.layer.borderColor = isSelected
                ? (UIColor(named: Constants.accentColorName) ?? UIColor.systemGreen).cgColor
                : UIColor.clear.cgColor
            button.layer.borderWidth = isSelected
                ? Constants.selectedIconBorderWidth
                : Constants.iconBorderWidth
            button.alpha = isSelected
                ? Constants.selectedIconAlpha
                : Constants.defaultIconAlpha
        }
    }
    
    // MARK: - Actions
    @objc private func iconTapped(_ sender: UIButton) {
        selectedImageName = habitIcons[sender.tag]
        updateSelectedIconUI()
    }
    
    @objc private func saveButtonTapped() {
        interactor.loadSaveButtonTapped(
            Model.LoadSaveHabit.Request(
                name: textField.text ?? Constants.defaultHabitName,
                iconName: selectedImageName
            )
        )
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    // MARK: - Display func
    func returnToBackScreen() {
        onHabitCreated?()
        dismiss(animated: true)
    }
}
