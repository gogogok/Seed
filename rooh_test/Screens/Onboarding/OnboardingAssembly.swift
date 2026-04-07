import UIKit

enum OnboardingAssembly {
    static func build() -> UIViewController {
        let presenter: OnboardingPresentationLogic = OnboardingPresenter()
        let interactor: OnboardingBusinessLogic = OnboardingInteractor(presenter: presenter)
        
        let viewController: OnboardingViewController = OnboardingViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
