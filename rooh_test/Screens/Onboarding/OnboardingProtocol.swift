import Foundation

protocol OnboardingBusinessLogic {
    typealias Model = OnboardingModel
    
    func loadNextScreenTapped(_ request: Model.LoadNextScreen.Request)
}

protocol OnboardingPresentationLogic: AnyObject {
    typealias Model = OnboardingModel

    var view:  OnboardingViewController? {get set}
    
    func presentNextScreenTapped(_ response: Model.LoadNextScreen.Response)
}


