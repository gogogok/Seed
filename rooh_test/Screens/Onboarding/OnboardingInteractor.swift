import UIKit

final class OnboardingInteractor : OnboardingBusinessLogic{
    
    //MARK: - Constants
    private enum Constants {
        static let userNameKey = "userName"
    }
    
    var presenter: OnboardingPresentationLogic
    
    init (presenter: OnboardingPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadNextScreenTapped(_ request: Model.LoadNextScreen.Request) {
        guard !request.name.isEmpty else { return }
        UserDefaults.standard.set(request.name, forKey: Constants.userNameKey)
        presenter.presentNextScreenTapped(Model.LoadNextScreen.Response(name: request.name))
    }
}
