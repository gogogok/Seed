import UIKit

final class MainTabBarViewController: UITabBarController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
        
        static let backgroundColorName: String = "NeumorphicBackground"
        static let accentColorName: String = "LeafColor"
        
        static let homeTitle: String = "Главная"
        static let habitsTitle: String = "Привычки"
        static let statsTitle: String = "Прогресс"
        static let settingsTitle: String = "Настройки"
        
        static let homeImageName: String = "house.fill"
        static let habitsImageName: String = "leaf.fill"
        static let statsImageName: String = "chart.pie.fill"
        static let settingsImageName: String = "gearshape.fill"
    }
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    // MARK: - Setup
    private func setupTabs() {
        let dashboardVC = DashboardAssembly.build()
        let habitsVC = HabitsListAssembly.build()
        let statsVC = StatsAssembly.build()
        let settingsVC = SettingsAssembly.build()
        
        viewControllers = [
            createNav(
                with: Constants.homeTitle,
                image: Constants.homeImageName,
                vc: dashboardVC
            ),
            createNav(
                with: Constants.habitsTitle,
                image: Constants.habitsImageName,
                vc: habitsVC
            ),
            createNav(
                with: Constants.statsTitle,
                image: Constants.statsImageName,
                vc: statsVC
            ),
            createNav(
                with: Constants.settingsTitle,
                image: Constants.settingsImageName,
                vc: settingsVC
            )
        ]
    }
    
    private func createNav(with title: String, image: String, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = UIImage(systemName: image)
        return nav
    }
    
    private func setupAppearance() {
        tabBar.backgroundColor = UIColor(named: Constants.backgroundColorName)
        tabBar.tintColor = UIColor(named: Constants.accentColorName)
        tabBar.unselectedItemTintColor = .systemGray2
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: Constants.backgroundColorName)
        appearance.shadowColor = .clear
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
