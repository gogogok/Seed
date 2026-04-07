import UIKit

final class StatsViewController: UIViewController {
    
    typealias Model = StatsModel
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Creation error"
        
        static let leafColor: UIColor = UIColor(named: "LeafColor") ?? .systemTeal
        static let bgColor: UIColor = UIColor(named: "NeumorphicBackground") ?? .white
        
        static let playFairDisplayBoldFont: String = "PlayfairDisplay-Regular_Bold"
        static let playFairDisplayFont: String = "PlayfairDisplay-Regular"
        
        static let titleText: String = "Statistics"
        static let subtitleText: String = "Progress in a week"
        static let checkmarkImageName: String = "checkmark"
        
        static let titleFontSize: CGFloat = 28
        static let subtitleFontSize: CGFloat = 20
        static let percentageFontSize: CGFloat = 40
        static let dayLabelFontSize: CGFloat = 12
        
        static let horizontalInset: CGFloat = 25
        static let subtitleTopInset: CGFloat = 4
        static let ringTopInset: CGFloat = 40
        static let streakTopInset: CGFloat = 50
        
        static let ringSize: CGFloat = 220
        static let ringRadius: CGFloat = 85
        static let ringLineWidth: CGFloat = 18
        
        static let streakHeight: CGFloat = 70
        static let dayViewWidth: CGFloat = 40
        static let dayCircleSize: CGFloat = 30
        static let dayCircleCornerRadius: CGFloat = 15
        static let dayLabelTopInset: CGFloat = 8
        static let checkmarkWidth: CGFloat = 14
    }
    
    // MARK: - Fields
    var interactor: StatsBusinessLogic
    
    private var currentProgress: Double = 0
    private var didSetupInitialRing = false
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont(name: Constants.playFairDisplayBoldFont, size: Constants.titleFontSize)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.subtitleText
        label.font = UIFont(name: Constants.playFairDisplayFont, size: Constants.subtitleFontSize)
        label.textColor = .darkGray
        return label
    }()
    
    private let ringContainer = UIView()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.percentageFontSize, weight: .heavy)
        label.textColor = Constants.leafColor
        return label
    }()
    
    private let streakStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private var streakDays: [String] = []
    private var completedDays: [Bool] = []
    
    // MARK: - Lifecycle
    init(interactor: StatsBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.bgColor
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ringContainer.addNeumorphicShadow(radius: ringContainer.frame.width / 2)
        
        guard ringContainer.bounds.width > 0 else { return }
        
        if !didSetupInitialRing {
            setupRingChart(progress: currentProgress, animated: true)
            didSetupInitialRing = true
        } else {
            setupRingChart(progress: currentProgress, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStats()
    }
    
    // MARK: - Load
    private func loadStats() {
        streakDays = AppStatsService.shared.fetchLast7DaysTitles()
        completedDays = AppStatsService.shared.fetchLast7DaysActivity()
        
        setupStreakScale()
        updateProgress(to: AppStatsService.shared.weeklyProgress())
    }
    
    // MARK: - Public
    func updateProgress(to value: Double) {
        currentProgress = value
        percentageLabel.text = "\(Int(value * 100))%"
        
        if didSetupInitialRing {
            setupRingChart(progress: value, animated: true)
        }
    }
    
    private func setupRingChart(progress: Double, animated: Bool) {
        ringContainer.layer.sublayers?
            .filter { $0 is CAShapeLayer }
            .forEach { $0.removeFromSuperlayer() }
        
        let center = CGPoint(x: ringContainer.bounds.midX, y: ringContainer.bounds.midY)
        
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: Constants.ringRadius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.systemGray6.cgColor
        trackLayer.lineWidth = Constants.ringLineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        ringContainer.layer.addSublayer(trackLayer)
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = Constants.leafColor.cgColor
        progressLayer.lineWidth = Constants.ringLineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(progress)
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = 1.2
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "anim")
        }
        
        ringContainer.layer.addSublayer(progressLayer)
    }
    
    // MARK: - UI
    private func setupLayout() {
        tabBarItem.title = ""
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(ringContainer)
        ringContainer.addSubview(percentageLabel)
        view.addSubview(streakStackView)
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.pinLeft(to: view, Constants.horizontalInset)
        
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, Constants.subtitleTopInset)
        subtitleLabel.pinLeft(to: titleLabel.leadingAnchor)
        
        ringContainer.pinTop(to: subtitleLabel.bottomAnchor, Constants.ringTopInset)
        ringContainer.pinCenterX(to: view)
        ringContainer.setWidth(Constants.ringSize)
        ringContainer.setHeight(Constants.ringSize)
        
        percentageLabel.pinCenterX(to: ringContainer)
        percentageLabel.pinCenterY(to: ringContainer)
        
        streakStackView.pinTop(to: ringContainer.bottomAnchor, Constants.streakTopInset)
        streakStackView.pinLeft(to: view, Constants.horizontalInset)
        streakStackView.pinRight(to: view, Constants.horizontalInset)
        streakStackView.setHeight(Constants.streakHeight)
    }
    
    private func setupStreakScale() {
        streakStackView.arrangedSubviews.forEach {
            streakStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        for (index, day) in streakDays.enumerated() {
            let dayView = UIView()
            dayView.setWidth(Constants.dayViewWidth)
            
            let label = UILabel()
            label.text = day
            label.font = .systemFont(ofSize: Constants.dayLabelFontSize, weight: .medium)
            label.textAlignment = .center
            label.textColor = .black
            
            let circle = UIView()
            circle.layer.cornerRadius = Constants.dayCircleCornerRadius
            
            dayView.addSubview(circle)
            dayView.addSubview(label)
            
            circle.pinTop(to: dayView)
            circle.pinCenterX(to: dayView)
            circle.setWidth(Constants.dayCircleSize)
            circle.setHeight(Constants.dayCircleSize)
            
            label.pinTop(to: circle.bottomAnchor, Constants.dayLabelTopInset)
            label.pinCenterX(to: dayView)
            
            if completedDays[index] {
                circle.backgroundColor = Constants.leafColor
                
                let check = UIImageView(
                    image: UIImage(
                        systemName: Constants.checkmarkImageName,
                        withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
                    )
                )
                check.tintColor = .white
                check.contentMode = .scaleAspectFit
                
                circle.addSubview(check)
                check.pinCenter(to: circle)
                check.setWidth(Constants.checkmarkWidth)
            } else {
                circle.backgroundColor = Constants.bgColor
                circle.layer.borderColor = UIColor.systemGray5.cgColor
                circle.layer.borderWidth = 1
            }
            
            streakStackView.addArrangedSubview(dayView)
        }
    }
    
    private func setupRingChart(progress: Double) {
        ringContainer.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }
        
        let center = CGPoint(x: ringContainer.bounds.midX, y: ringContainer.bounds.midY)
        
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: Constants.ringRadius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.systemGray6.cgColor
        trackLayer.lineWidth = Constants.ringLineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        ringContainer.layer.addSublayer(trackLayer)
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = Constants.leafColor.cgColor
        progressLayer.lineWidth = Constants.ringLineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(progress)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = progress
        animation.duration = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.add(animation, forKey: "anim")
        
        ringContainer.layer.addSublayer(progressLayer)
    }
}
