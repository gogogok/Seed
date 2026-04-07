final class SettingsInteractor : SettingsBusinessLogic{
    
    var presenter: SettingsPresentationLogic
    
    init (presenter: SettingsPresentationLogic) {
        self.presenter = presenter
    }
    
}
