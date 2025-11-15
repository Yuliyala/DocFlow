import UIKit

extension LimitedViewController {
    
    var timerDuration: TimeInterval {
        return 24 * 60 * 60
    }
    
    func setupTimer() {
        let storage = LocalStorage.shared
        
        if let startDate = storage.timer24HourStartDate {
            let elapsed = Date().timeIntervalSince(startDate)
            
            if elapsed >= timerDuration {
                storage.clearTimer24HourStartDate()
                startNewTimer()
            } else {
                startTimerUpdates()
            }
        } else {
            startNewTimer()
        }
    }
    
    func startNewTimer() {
        let now = Date()
        LocalStorage.shared.setTimer24HourStartDate(now)
        startTimerUpdates()
    }
    
    func startTimerUpdates() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimerLabel()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimerLabel() {
        let timerString = getCurrentTimerString()
        DispatchQueue.main.async { [weak self] in
            self?.rootView.updateTimerLabel(timerString)
        }
    }
    
    func getCurrentTimerString() -> String {
        guard let startDate = LocalStorage.shared.timer24HourStartDate else {
            return "00h:00m:00s"
        }
        
        let elapsed = Date().timeIntervalSince(startDate)
        let remaining = max(0, timerDuration - elapsed)
        
        if remaining <= 0 {
            LocalStorage.shared.clearTimer24HourStartDate()
            return "00h:00m:00s"
        }
        
        return formatTimeInterval(remaining)
    }
    
    func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        return String(format: "%02dh:%02dm:%02ds", hours, minutes, seconds)
    }
}


