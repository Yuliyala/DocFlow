import Foundation

final class LocalStorage {
    
    // MARK: - Singleton
    static let shared = LocalStorage()
    private init() {}
    
    // MARK: - UserDefaults Keys
    private enum Keys {
        static let isOnboardingShown = "isOnboardingShown"
        static let timer24hStartDate = "timer24hStartDate"
    }
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Onboarding
    
    var isOnboardingShown: Bool { 
        get {
            userDefaults.bool(forKey: Keys.isOnboardingShown)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isOnboardingShown)
        }
    }
    
    func markOnboardingAsShown() {
        isOnboardingShown = true
    }
    
    // MARK: - 24-Hour Timer
    
    func setTimer24HourStartDate(_ date: Date) {
        userDefaults.set(date, forKey: Keys.timer24hStartDate)
    }
    
    var timer24HourStartDate: Date? {
        get {
            userDefaults.object(forKey: Keys.timer24hStartDate) as? Date
        }
        set {
            if let date = newValue {
                userDefaults.set(date, forKey: Keys.timer24hStartDate)
            } else {
                userDefaults.removeObject(forKey: Keys.timer24hStartDate)
            }
        }
    }
    
    func clearTimer24HourStartDate() {
        userDefaults.removeObject(forKey: Keys.timer24hStartDate)
    }
}

