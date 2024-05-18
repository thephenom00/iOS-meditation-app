import SwiftUI
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    static let usernameKey = "usernameKey"
    static let imageKey = "imageKey"
    
    @Published var userName: String = UserDefaults.standard.string(forKey: ProfileViewModel.usernameKey) ?? "User"
    @Published var profileImage: UIImage? = ProfileViewModel.getImage()

    static func getImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: ProfileViewModel.imageKey) {
            return UIImage(data: imageData)
        }
        return UIImage(systemName: "person.crop.circle.fill")
    }

    func updateUserName(_ newName: String) {
        userName = newName // UPDATE
        UserDefaults.standard.set(newName, forKey: ProfileViewModel.usernameKey)
    }

    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(origin: .zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    func updateProfileImage(_ newImage: UIImage?) {
        guard let image = newImage else {
            profileImage = nil
            UserDefaults.standard.removeObject(forKey: ProfileViewModel.imageKey)
            return
        }

        let targetSize = CGSize(width: 1024, height: 1024)
        let resizedImage = resizeImage(image, targetSize: targetSize)
        
        if let imageData = resizedImage.jpegData(compressionQuality: 0.7) {
            UserDefaults.standard.set(imageData, forKey: ProfileViewModel.imageKey)
        } else {
            UserDefaults.standard.removeObject(forKey: ProfileViewModel.imageKey)
        }
        profileImage = resizedImage
    }
    
    func scheduleDailyReminder(notificationTime: Date, completion: @escaping (String?, Error?) -> Void) {
        NotificationManager.shared.requestAuthorization { success, error in
            if let error = error {
                completion(nil, error)
            } else if success {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: notificationTime)
                if let hour = components.hour, let minute = components.minute {
                    NotificationManager.shared.scheduleDailyNotification(title: "Daily Reminder", subtitle: "Time to meditate!", hour: hour, minute: minute)
                    let scheduledTime = String(format: "%02d:%02d", hour, minute)
                    completion(scheduledTime, nil)
                } else {
                    completion(nil, NSError(domain: "InvalidComponents", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid time components"]))
                }
            } else {
                completion(nil, NSError(domain: "AuthorizationDenied", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authorization not granted"]))
            }
        }
    }

}
