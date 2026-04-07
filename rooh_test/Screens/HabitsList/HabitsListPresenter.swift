import UIKit

final class  HabitsListPresenter :  HabitsListPresentationLogic  {
    
    typealias Model = HabitsListModel
    
    weak var view: HabitsListViewController?
    
    func presentAddButtonTapped(_ response: Model.LoadAddHabit.Response) {
        let createVC = CreateHabitAssembly.build()
        let nav = UINavigationController(rootViewController: createVC)
        view?.displayAddHabit(Model.LoadAddHabit.ViewModel(vc: nav))
    }
    
}
