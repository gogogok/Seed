import UIKit

enum CreateHabitAssembly {
    static func build() -> UIViewController {
        let presenter: CreateHabitPresentationLogic = CreateHabitPresenter()
        let interactor: CreateHabitBusinessLogic = CreateHabitInteractor(presenter: presenter)
        
        let viewController: CreateHabitViewController = CreateHabitViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
