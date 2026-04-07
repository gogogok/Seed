import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        
        static let shadowRadius: CGFloat = 15
        static let imageSize: CGFloat = 40
        static let checkmarkSize: CGFloat = 24
        
        static let topBottomInset: CGFloat = 10
        static let horizontalInset: CGFloat = 25
        
        static let innerHorizontalInset: CGFloat = 15
        static let labelSpacing: CGFloat = 15
        static let checkmarkSpacing: CGFloat = 10
        
        static let titleFontSize: CGFloat = 16
        
        static let playFairDisplayFont: String = "PlayfairDisplay-Regular"
        static let playFairDisplayBlackFont: String = "PlayfairDisplay-Regular_Black"
        
        static let completedImageName: String = "checkmark.circle.fill"
        static let notCompletedImageName: String = "circle"
        
        static let backgroundColorName: String = "NeumorphicBackground"
        static let accentColorName: String = "NeumorphicAccentPink"
        static let leafColorName: String = "LeafColor"
        
        static let completedAlpha: CGFloat = 1.0
        static let notCompletedAlpha: CGFloat = 0.35
    }
    
    // MARK: - Callbacks
    var onCheckmarkTapped: (() -> Void)?
    
    // MARK: - State
    private var isCompleted: Bool = false
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: Constants.backgroundColorName)
        view.layer.cornerRadius = Constants.shadowRadius
        return view
    }()
    
    private let taskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(named: Constants.leafColorName)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.playFairDisplayBlackFont, size: Constants.titleFontSize)
        label.textColor = .black
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGestures()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.applyNeumorphicStyle()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskLabel.text = nil
        taskImageView.image = nil
        checkmarkImageView.image = nil
        onCheckmarkTapped = nil
        isCompleted = false
    }
    
    // MARK: - Configure
    func configure(title: String, imageName: String, isCompleted: Bool) {
        taskLabel.text = title
        taskImageView.image = UIImage(named: imageName)
        self.isCompleted = isCompleted
        updateCheckmarkAppearance()
    }
    
    // MARK: - Setup
    private func setupUI() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(taskImageView)
        containerView.addSubview(taskLabel)
        containerView.addSubview(checkmarkImageView)
        
        containerView.backgroundColor = UIColor(named: Constants.accentColorName)
        
        // container
        containerView.pinTop(to: contentView, Constants.topBottomInset)
        containerView.pinBottom(to: contentView, Constants.topBottomInset)
        containerView.pinLeft(to: contentView, Constants.horizontalInset)
        containerView.pinRight(to: contentView, Constants.horizontalInset)
        
        // image
        taskImageView.pinLeft(to: containerView, Constants.innerHorizontalInset)
        taskImageView.pinCenterY(to: containerView)
        taskImageView.setWidth(Constants.imageSize)
        taskImageView.setHeight(Constants.imageSize)
        
        // checkmark
        checkmarkImageView.pinRight(to: containerView, Constants.innerHorizontalInset)
        checkmarkImageView.pinCenterY(to: containerView)
        checkmarkImageView.setWidth(Constants.checkmarkSize)
        checkmarkImageView.setHeight(Constants.checkmarkSize)
        
        // label
        taskLabel.pinLeft(to: taskImageView.trailingAnchor, Constants.labelSpacing)
        taskLabel.pinRight(to: checkmarkImageView.leadingAnchor, Constants.checkmarkSpacing)
        taskLabel.pinCenterY(to: containerView)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkmarkTapped))
        checkmarkImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func checkmarkTapped() {
        isCompleted.toggle()
        updateCheckmarkAppearance()
        onCheckmarkTapped?()
    }
    
    private func updateCheckmarkAppearance() {
        let imageName = isCompleted
            ? Constants.completedImageName
            : Constants.notCompletedImageName
        
        checkmarkImageView.image = UIImage(systemName: imageName)
        
        let baseColor = UIColor(named: Constants.leafColorName) ?? .systemGreen
        
        checkmarkImageView.tintColor = isCompleted
            ? baseColor
            : baseColor.withAlphaComponent(Constants.notCompletedAlpha)
    }
    
    private func applyNeumorphicStyle() {
        let radius = Constants.shadowRadius
        let view = containerView
        
        view.layer.sublayers?
            .filter { $0.name == "neumorphic" }
            .forEach { $0.removeFromSuperlayer() }
        
        let darkShadow = CALayer()
        darkShadow.name = "neumorphic"
        darkShadow.frame = view.bounds
        darkShadow.backgroundColor = view.backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor.black.cgColor
        darkShadow.shadowOffset = CGSize(width: 5, height: 5)
        darkShadow.shadowOpacity = 0.1
        darkShadow.shadowRadius = 5
        darkShadow.cornerRadius = radius
        
        let lightShadow = CALayer()
        lightShadow.name = "neumorphic"
        lightShadow.frame = view.bounds
        lightShadow.backgroundColor = view.backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.shadowOffset = CGSize(width: -5, height: -5)
        lightShadow.shadowOpacity = 1.0
        lightShadow.shadowRadius = 5
        lightShadow.cornerRadius = radius
        
        view.layer.insertSublayer(darkShadow, at: 0)
        view.layer.insertSublayer(lightShadow, at: 0)
        
        darkShadow.shadowPath = UIBezierPath(
            roundedRect: view.bounds,
            cornerRadius: radius
        ).cgPath
        
        lightShadow.shadowPath = UIBezierPath(
            roundedRect: view.bounds,
            cornerRadius: radius
        ).cgPath
    }
}
