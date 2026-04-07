import UIKit

final class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    typealias Model = SettingsModel
    
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
        
        static let settingsTitle: String = "SETTINGS"
        static let cellId: String = "SettingCell"
        
        static let notificationsEnabledKey: String = "notifications_enabled"
        static let selectedThemeKey: String = "selected_theme"
        
        static let notificationsTitle: String = "Notifications"
        static let notificationsMessage: String = "Choose notification mode"
        static let notificationsEnableTitle: String = "Enable"
        static let notificationsDisableTitle: String = "Disable"
        
        static let themeTitle: String = "Theme"
        static let themeMessage: String = "Choose app appearance"
        static let themeLightTitle: String = "Light"
        static let themeDarkTitle: String = "Dark"
        static let themeSystemTitle: String = "System"
        
        static let cancelTitle: String = "Cancel"
        static let okTitle: String = "OK"
        
        static let habitGoalsTitle: String = "Habit Goals"
        static let habitGoalsMessage: String = "Here you will be able to set and edit your habit goals."
        
        static let progressInsightsTitle: String = "Progress Insights"
        static let progressInsightsMessage: String = "Here you will see your weekly and monthly progress."
        
        static let privacyTitle: String = "Privacy & Security"
        static let privacyMessage: String = "Privacy and security settings will be available here."
        
        static let rateSeedTitle: String = "Rate SEED"
        static let rateSeedMessage: String = "Thank you for supporting SEED 🌱"
        
        static let aboutSeedTitle: String = "About SEED"
        static let aboutSeedMessage: String = "SEED helps you build healthy habits and stay consistent every day."
        
        static let contactUsTitle: String = "Contact Us"
        static let contactUsMessage: String = "Email us at: support@seed.app"
        
        static let myJourneySectionTitle: String = "MY JOURNEY"
        static let appPreferencesSectionTitle: String = "APP PREFERENCES"
        static let supportSectionTitle: String = "SUPPORT & MORE"
        
        static let iconTarget: String = "target"
        static let iconChartBar: String = "chart.bar"
        static let iconBell: String = "bell"
        static let iconSunMax: String = "sun.max"
        static let iconLock: String = "lock"
        static let iconHeart: String = "heart"
        static let iconLeaf: String = "leaf"
        static let iconEnvelope: String = "envelope"
        
        static let backgroundColorName: String = "NeumorphicBackground"
        static let textColor: UIColor = UIColor(
            named: "SettingsText"
        ) ?? UIColor(red: 0.35, green: 0.45, blue: 0.25, alpha: 1.0)
        
        static let sectionHeaderFontSize: CGFloat = 14
        static let navLargeTitleFontSize: CGFloat = 34
        static let navTitleFontSize: CGFloat = 17
    }
    
    var tableView: UITableView!
    
    struct SettingSection {
        let header: String
        let options: [SettingOption]
    }
    
    struct SettingOption {
        let title: String
        let iconName: String
        let handler: (() -> Void)
    }
    
    var sections: [SettingSection] = []
    var interactor: SettingsBusinessLogic
    
    init(interactor: SettingsBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        setupData()
        applySavedTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationAppearance()
    }
    
    private func setupNavigation() {
        navigationItem.title = Constants.settingsTitle
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupNavigationAppearance() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: Constants.backgroundColorName)
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: Constants.textColor,
            .font: UIFont.systemFont(ofSize: Constants.navLargeTitleFontSize, weight: .bold)
        ]
        
        appearance.titleTextAttributes = [
            .foregroundColor: Constants.textColor,
            .font: UIFont.systemFont(ofSize: Constants.navTitleFontSize, weight: .semibold)
        ]
        
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = Constants.textColor
        navBar.isTranslucent = false
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: Constants.backgroundColorName)
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        tableView.contentInsetAdjustmentBehavior = .automatic
        
        view.addSubview(tableView)
        
        tableView.pinTop(to: view)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }
    
    func setupData() {
        let journeyOptions = [
            SettingOption(title: Constants.habitGoalsTitle, iconName: Constants.iconTarget) { [weak self] in
                self?.showInfoScreen(
                    title: Constants.habitGoalsTitle,
                    message: Constants.habitGoalsMessage
                )
            },
            SettingOption(title: Constants.progressInsightsTitle, iconName: Constants.iconChartBar) { [weak self] in
                self?.showInfoScreen(
                    title: Constants.progressInsightsTitle,
                    message: Constants.progressInsightsMessage
                )
            },
            SettingOption(title: Constants.notificationsTitle, iconName: Constants.iconBell) { [weak self] in
                self?.showNotificationsAlert()
            }
        ]
        
        let appOptions = [
            SettingOption(title: Constants.themeTitle, iconName: Constants.iconSunMax) { [weak self] in
                self?.showThemeAlert()
            },
            SettingOption(title: Constants.privacyTitle, iconName: Constants.iconLock) { [weak self] in
                self?.showInfoScreen(
                    title: Constants.privacyTitle,
                    message: Constants.privacyMessage
                )
            }
        ]
        
        let supportOptions = [
            SettingOption(title: Constants.rateSeedTitle, iconName: Constants.iconHeart) { [weak self] in
                self?.showSimpleAlert(
                    title: Constants.rateSeedTitle,
                    message: Constants.rateSeedMessage
                )
            },
            SettingOption(title: Constants.aboutSeedTitle, iconName: Constants.iconLeaf) { [weak self] in
                self?.showInfoScreen(
                    title: Constants.aboutSeedTitle,
                    message: Constants.aboutSeedMessage
                )
            },
            SettingOption(title: Constants.contactUsTitle, iconName: Constants.iconEnvelope) { [weak self] in
                self?.showSimpleAlert(
                    title: Constants.contactUsTitle,
                    message: Constants.contactUsMessage
                )
            }
        ]
        
        sections = [
            SettingSection(header: Constants.myJourneySectionTitle, options: journeyOptions),
            SettingSection(header: Constants.appPreferencesSectionTitle, options: appOptions),
            SettingSection(header: Constants.supportSectionTitle, options: supportOptions)
        ]
    }
    
    // MARK: - Helpers
    private func showInfoScreen(title: String, message: String) {
        let vc = SimpleInfoViewController(titleText: title, messageText: message)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okTitle, style: .default))
        present(alert, animated: true)
    }
    
    private func showNotificationsAlert() {
        let alert = UIAlertController(
            title: Constants.notificationsTitle,
            message: Constants.notificationsMessage,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: Constants.notificationsEnableTitle, style: .default, handler: { _ in
            UserDefaults.standard.set(true, forKey: Constants.notificationsEnabledKey)
        }))
        
        alert.addAction(UIAlertAction(title: Constants.notificationsDisableTitle, style: .default, handler: { _ in
            UserDefaults.standard.set(false, forKey: Constants.notificationsEnabledKey)
        }))
        
        alert.addAction(UIAlertAction(title: Constants.cancelTitle, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showThemeAlert() {
        let alert = UIAlertController(
            title: Constants.themeTitle,
            message: Constants.themeMessage,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: Constants.themeLightTitle, style: .default, handler: { [weak self] _ in
            UserDefaults.standard.set("light", forKey: Constants.selectedThemeKey)
            self?.overrideUserInterfaceStyle = .light
            self?.view.window?.overrideUserInterfaceStyle = .light
        }))
        
        alert.addAction(UIAlertAction(title: Constants.themeDarkTitle, style: .default, handler: { [weak self] _ in
            UserDefaults.standard.set("dark", forKey: Constants.selectedThemeKey)
            self?.overrideUserInterfaceStyle = .dark
            self?.view.window?.overrideUserInterfaceStyle = .dark
        }))
        
        alert.addAction(UIAlertAction(title: Constants.themeSystemTitle, style: .default, handler: { [weak self] _ in
            UserDefaults.standard.set("system", forKey: Constants.selectedThemeKey)
            self?.overrideUserInterfaceStyle = .unspecified
            self?.view.window?.overrideUserInterfaceStyle = .unspecified
        }))
        
        alert.addAction(UIAlertAction(title: Constants.cancelTitle, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func applySavedTheme() {
        let theme = UserDefaults.standard.string(forKey: Constants.selectedThemeKey) ?? "system"
        
        switch theme {
        case "light":
            overrideUserInterfaceStyle = .light
            view.window?.overrideUserInterfaceStyle = .light
        case "dark":
            overrideUserInterfaceStyle = .dark
            view.window?.overrideUserInterfaceStyle = .dark
        default:
            overrideUserInterfaceStyle = .unspecified
            view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    // MARK: - Table view
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
        let option = sections[indexPath.section].options[indexPath.row]
        
        cell.textLabel?.text = option.title
        cell.textLabel?.textColor = UIColor(white: 0.2, alpha: 1.0)
        
        let icon = UIImage(systemName: option.iconName)
        cell.imageView?.image = icon
        cell.imageView?.tintColor = Constants.textColor
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = Constants.textColor
        header.textLabel?.font = UIFont.systemFont(ofSize: Constants.sectionHeaderFontSize, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = sections[indexPath.section].options[indexPath.row]
        option.handler()
    }
}
