final class  CreateHabitPresenter :  CreateHabitPresentationLogic  {
    
    typealias Model = CreateHabitModel
    
    weak var view: CreateHabitViewController?
    
    func presentSaveButtonTapped(_ response: Model.LoadSaveHabit.Response) {
        view?.returnToBackScreen()
    }
    
    
}
