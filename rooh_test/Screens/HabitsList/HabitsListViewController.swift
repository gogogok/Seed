import UIKit

final class HabitsListViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError = "Creation error"
        
        static let cellId = "HabitCell"
        static let navTitle = "My habits"
        
        static let backgroundColorName = "NeumorphicBackground"
        static let accentColorName = "LeafColor"
        
        static let horizontalInset: CGFloat = 0
        static let cellHeight: CGFloat = 100
        
        static let playFairDisplayBoldFont = "PlayfairDisplay-Regular_Bold"
        
        static let navFontSize: CGFloat = 20
        static let navLargeFontSize: CGFloat = 34
        
        static let addIcon = "plus.circle.fill"
    }
    
    typealias Model = HabitsListModel
    
    //MARK: - Fields
    var interactor : HabitsListBusinessLogic
    let worker = HabitRepositoryWorker()
    
    // MARK: - Data
    var habits: [HabitVM.Habit] = []
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        setupNavigationBar()
    }
    
    init(interactor: HabitsListBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: Constants.backgroundColorName)
        view.addSubview(tableView)
        
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }
    
    //MARK: - Load data
    private func loadData() {
        do {
            try habits = worker.fetchNotCompletedHabits()
            tableView.reloadData()
        } catch {
            habits = []
        }
    }
    
    private func setupNavigationBar() {
        tabBarItem.title = ""
        
        navigationItem.title = Constants.navTitle
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: Constants.backgroundColorName)
        
        appearance.titleTextAttributes = [
            .font: UIFont(name: Constants.playFairDisplayBoldFont, size: Constants.navFontSize) ?? .systemFont(ofSize: Constants.navFontSize),
            .foregroundColor: UIColor.black
        ]
        
        appearance.largeTitleTextAttributes = [
            .font: UIFont(name: Constants.playFairDisplayBoldFont, size: Constants.navLargeFontSize) ?? .systemFont(ofSize: Constants.navLargeFontSize),
            .foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.addIcon),
            style: .plain,
            target: self,
            action: #selector(addHabitTapped)
        )
        addButton.tintColor = UIColor(named: Constants.accentColorName)
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - Actions
    @objc private func addHabitTapped() {
        interactor.loadAddButtonTapped(HabitsListModel.LoadAddHabit.Request())
    }
    
    func displayAddHabit(_ vm: Model.LoadAddHabit.ViewModel) {
        if let createVC = vm.vc as? CreateHabitViewController {
            createVC.onHabitCreated = { [weak self] in
                self?.loadData()
            }
        } else if let nav = vm.vc as? UINavigationController,
                  let createVC = nav.viewControllers.first as? CreateHabitViewController {
            createVC.onHabitCreated = { [weak self] in
                self?.loadData()
            }
        }
        
        present(vm.vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HabitsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let habit = habits[indexPath.row]
        
        cell.configure(
            title: habit.title,
            imageName: habit.imageName,
            isCompleted: habit.isCompleted
        )
        
        cell.onCheckmarkTapped = { [weak self] in
            guard let self else { return }
            
            let habitId = habit.id
            
            self.worker.toggleHabitCompletion(id: habitId)
            self.loadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let habit = habits[indexPath.row]
            worker.delete(id: habit.id)
            loadData()
        }
    }
}
