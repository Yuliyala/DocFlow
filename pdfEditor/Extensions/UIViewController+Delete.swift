import UIKit

extension UIViewController {
    func presentDeleteAlert(onDelete: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: NSLocalizedString("delete.title", comment: "Delete alert title"),
            message: NSLocalizedString("delete.message", comment: "Delete alert message"),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("delete.cancel", comment: "Cancel button"), style: .default)
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete.delete", comment: "Delete button"), style: .destructive) { _ in
            onDelete()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
        alertController.view.tintColor = .accent
    }
    
    func presentRestorePurchasesFailureAlert(errorDescription: String) {
        let alertController = UIAlertController(
            title: NSLocalizedString("restore.failure.title", comment: "Restore purchases failure alert title"),
            message: errorDescription,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: NSLocalizedString("restore.failure.ok", comment: "OK button"), style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    func presentSubscriptionErrorAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("subscription.error.title", comment: "Subscription error alert title"),
            message: NSLocalizedString("subscription.error.message", comment: "Subscription error alert message"),
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: NSLocalizedString("subscription.error.ok", comment: "OK button"), style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    func presentRestorePurchasesSuccessBanner() {
        let alertController = UIAlertController(
            title: NSLocalizedString("restore.success.title", comment: "Restore purchases success banner title"),
            message: NSLocalizedString("restore.success.message", comment: "Restore purchases success banner message"),
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: NSLocalizedString("restore.success.ok", comment: "OK button"), style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
}

