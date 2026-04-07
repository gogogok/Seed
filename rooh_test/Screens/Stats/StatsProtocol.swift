import Foundation

protocol StatsBusinessLogic {
    typealias Model = StatsModel
}

protocol StatsPresentationLogic: AnyObject {
    typealias Model = StatsModel

    var view:  StatsViewController? {get set}
}


