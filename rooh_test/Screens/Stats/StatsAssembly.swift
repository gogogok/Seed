import UIKit

enum StatsAssembly {
    static func build() -> UIViewController {
        let presenter: StatsPresentationLogic = StatsPresenter()
        let interactor: StatsBusinessLogic = StatsInteractor(presenter: presenter)
        
        let viewController: StatsViewController = StatsViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
