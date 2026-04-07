final class  OnboardingPresenter :  OnboardingPresentationLogic  {
    typealias Model = OnboardingModel
    
    weak var view: OnboardingViewController?
    
    func presentNextScreenTapped(_ response: Model.LoadNextScreen.Response) {
        view?.displayNextScreen(Model.LoadNextScreen.ViewModel(name: response.name))
    }
    
}
