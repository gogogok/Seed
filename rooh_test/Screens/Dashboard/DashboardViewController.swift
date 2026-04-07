import UIKit

final class DashboardViewController: UIViewController {
    
    typealias Model = DashboardModel
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Creation Error"
        
        static let cellId: String = "TaskCell"
        static let sectionHeaderTitle: String = "Completed today"
        
        static let userNameKey: String = "userName"
        
        static let welcomeDefault: String = "Hello!"
        static let welcomeWithName: String = "Hello, %@!"
        
        static let percentSuffix: String = "%"
        
        static let playFairDisplayFont: String = "PlayfairDisplay-Regular"
        static let playFairDisplayBoldFont: String = "PlayfairDisplay-Regular_Bold"
        
        // Fonts
        static let welcomeFontSize: CGFloat = 28
        static let progressFontSize: CGFloat = 22
        static let percentFontSize: CGFloat = 48
        static let headerFontSize: CGFloat = 22
        
        // Layout
        static let welcomeTopInset: CGFloat = 40
        static let horizontalInset: CGFloat = 25
        
        static let progressTopInset: CGFloat = 30
        static let progressHeight: CGFloat = 180
        
        static let progressLabelTopInset: CGFloat = 30
        static let percentCenterOffset: CGFloat = 20
        
        static let tableTopInset: CGFloat = 20
        
        static let cellHeight: CGFloat = 90
        
        // Colors
        static let backgroundColorName: String = "NeumorphicBackground"
        static let accentColorName: String = "LeafColor"
        
        static let defaultPercent: String = "100%"
    }
    
    // MARK: - Fields
    var interactor: DashboardBusinessLogic
    let worker = HabitRepositoryWorker()
    
    private var completedTasks: [HabitVM.Habit] = []
    private var habitsCount = 0
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.playFairDisplayBoldFont, size: Constants.welcomeFontSize)
        label.textColor = .black
        return label
    }()
    
    private let progressCard = UIView()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Percent completed"
        label.font = UIFont(name: Constants.playFairDisplayFont, size: Constants.progressFontSize)
        label.textColor = .black
        return label
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.percentFontSize, weight: .heavy)
        label.textColor = UIColor(named: Constants.accentColorName)
        return label
    }()
    
    // MARK: - Lifecycle
    init(interactor: DashboardBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Constants.backgroundColorName)
        navigationController?.isNavigationBarHidden = true
        
        loadData()
        configureUI()
        updateWelcomeTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressCard.addNeumorphicShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    // MARK: - Load data
    private func loadData() {
        do {
            completedTasks = try worker.fetchCompletedHabits()
            habitsCount = try worker.fetchAll().count
            reloadPercent()
            tableView.reloadData()
        } catch {
            completedTasks = []
        }
    }
    
    // MARK: - UI
    private func configureUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(progressCard)
        view.addSubview(tableView)
        
        progressCard.addSubview(progressLabel)
        progressCard.addSubview(percentageLabel)
        
        // welcome
        welcomeLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.welcomeTopInset)
        welcomeLabel.pinLeft(to: view, Constants.horizontalInset)
        
        // progress card
        progressCard.pinTop(to: welcomeLabel.bottomAnchor, Constants.progressTopInset)
        progressCard.pinLeft(to: view, Constants.horizontalInset)
        progressCard.pinRight(to: view, Constants.horizontalInset)
        progressCard.setHeight(Constants.progressHeight)
        
        // progress label
        progressLabel.pinTop(to: progressCard, Constants.progressLabelTopInset)
        progressLabel.pinCenterX(to: progressCard)
        
        // percentage
        percentageLabel.pinCenterX(to: progressCard)
        percentageLabel.pinCenterY(to: progressCard, Constants.percentCenterOffset)
        
        // table
        tableView.pinTop(to: progressCard.bottomAnchor, Constants.tableTopInset)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
        
        reloadPercent()
    }
    
    // MARK: - Helpers
    private func updateWelcomeTitle() {
        let userName = UserDefaults.standard.string(forKey: Constants.userNameKey)
        
        if let userName, !userName.isEmpty {
            welcomeLabel.text = String(format: Constants.welcomeWithName, userName)
        } else {
            welcomeLabel.text = Constants.welcomeDefault
        }
    }
    
    private func reloadPercent() {
        if habitsCount != 0 {
            let percent = Int(Double(completedTasks.count) / Double(habitsCount) * 100)
            percentageLabel.text = "\(percent)\(Constants.percentSuffix)"
        } else {
            percentageLabel.text = Constants.defaultPercent
        }
    }
}

// MARK: - UITableView
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellId,
            for: indexPath
        ) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let habit = completedTasks[indexPath.row]
        
        cell.configure(
            title: habit.title,
            imageName: habit.imageName,
            isCompleted: habit.isCompleted
        )
        
        cell.onCheckmarkTapped = { [weak self] in
            guard let self else { return }
            self.worker.toggleHabitCompletion(id: habit.id)
            self.loadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Constants.sectionHeaderTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .black
        header.textLabel?.font = UIFont(
            name: Constants.playFairDisplayBoldFont,
            size: Constants.headerFontSize
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
}
