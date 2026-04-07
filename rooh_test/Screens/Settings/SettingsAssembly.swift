import UIKit

enum SettingsAssembly {
    static func build() -> UIViewController {
        let presenter: SettingsPresentationLogic = SettingsPresenter()
        let interactor: SettingsBusinessLogic = SettingsInteractor(presenter: presenter)
        
        let viewController: SettingsViewController = SettingsViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
