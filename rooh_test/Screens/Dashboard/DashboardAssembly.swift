import UIKit

enum DashboardAssembly {
    static func build() -> UIViewController {
        let presenter: DashboardPresentationLogic = DashboardPresenter()
        let interactor: DashboardBusinessLogic = DashboardInteractor(presenter: presenter)
        
        let viewController: DashboardViewController = DashboardViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
