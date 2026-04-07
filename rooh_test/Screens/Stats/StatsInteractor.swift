final class StatsInteractor : StatsBusinessLogic{
    
    var presenter: StatsPresentationLogic
    
    init (presenter: StatsPresentationLogic) {
        self.presenter = presenter
    }
    
}
