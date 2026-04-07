import Foundation

protocol HabitsListBusinessLogic {
    typealias Model = HabitsListModel
    
    func loadAddButtonTapped(_ request: Model.LoadAddHabit.Request)
}

protocol HabitsListPresentationLogic: AnyObject {
    typealias Model = HabitsListModel

    var view:  HabitsListViewController? {get set}
    
    func presentAddButtonTapped(_ response: Model.LoadAddHabit.Response)
}


