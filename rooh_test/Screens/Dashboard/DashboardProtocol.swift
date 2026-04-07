import Foundation

protocol DashboardBusinessLogic {
    typealias Model = DashboardModel
}

protocol DashboardPresentationLogic: AnyObject {
    typealias Model = DashboardModel

    var view:  DashboardViewController? {get set}
}


