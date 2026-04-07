final class HabitsListInteractor : HabitsListBusinessLogic{
    
    var presenter: HabitsListPresentationLogic
    
    init (presenter: HabitsListPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadAddButtonTapped(_ request: Model.LoadAddHabit.Request) {
        presenter.presentAddButtonTapped(Model.LoadAddHabit.Response())
    }
}
