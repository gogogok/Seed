import Foundation

final class CreateHabitInteractor : CreateHabitBusinessLogic{
    
    var presenter: CreateHabitPresentationLogic
    let worker: HabitRepositoryWorker = HabitRepositoryWorker()
    
    init (presenter: CreateHabitPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadSaveButtonTapped(_ request: Model.LoadSaveHabit.Request) {
        let habit = HabitVM.Habit(id: UUID(), title: request.name, imageName: request.iconName, isCompleted: false)
        worker.add(habit: habit)
        presenter.presentSaveButtonTapped(Model.LoadSaveHabit.Response())
    }
    
}
