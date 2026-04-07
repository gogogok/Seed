import Foundation

protocol CreateHabitBusinessLogic {
    typealias Model = CreateHabitModel
    
    func loadSaveButtonTapped(_ request: Model.LoadSaveHabit.Request)
}

protocol CreateHabitPresentationLogic: AnyObject {
    typealias Model = CreateHabitModel

    var view:  CreateHabitViewController? {get set}
    
    func presentSaveButtonTapped(_ response: Model.LoadSaveHabit.Response)
}


