import Foundation

protocol SettingsBusinessLogic {
    typealias Model = SettingsModel
}

protocol SettingsPresentationLogic: AnyObject {
    typealias Model = SettingsModel

    var view:  SettingsViewController? {get set}
}


