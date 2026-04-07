final class DashboardInteractor : DashboardBusinessLogic{
    
    var presenter: DashboardPresentationLogic
    
    init (presenter: DashboardPresentationLogic) {
        self.presenter = presenter
    }
    
}
