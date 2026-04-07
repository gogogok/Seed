import UIKit

enum HabitsListAssembly {
    static func build() -> UIViewController {
        let presenter: HabitsListPresentationLogic = HabitsListPresenter()
        let interactor: HabitsListBusinessLogic = HabitsListInteractor(presenter: presenter)
        
        let viewController: HabitsListViewController = HabitsListViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
