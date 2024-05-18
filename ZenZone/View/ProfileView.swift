import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var isChangeUsernameSheetPresented: Bool = false
    @State private var isNotificationSheetPresented: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Button(action: {
                            showActionSheet = true
                        }) {
                            if let profileImage = profileViewModel.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                        }

                        VStack(alignment: .leading) {
                            Text(profileViewModel.userName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text("Zen Explorer")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }

                    Button(action: {
                        isChangeUsernameSheetPresented = true
                    }) {
                        Text("Change username")
                            .font(.headline)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.softLavender)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        isNotificationSheetPresented = true
                    }) {
                        Text("Set Daily Reminder")
                            .font(.headline)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.softLavender)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()
            }

            Spacer()
        }
        .background(Color.cream.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isChangeUsernameSheetPresented) {
            ChangeUsernameView(profileViewModel: profileViewModel)
        }
        .sheet(isPresented: $isNotificationSheetPresented) {
            HandleNotification(profileViewModel: profileViewModel)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(isPresented: $isImagePickerPresented, image: $selectedImage, sourceType: imagePickerSourceType)
                .onDisappear {
                    if let selectedImage = selectedImage {
                        profileViewModel.updateProfileImage(selectedImage)
                    }
                }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Select"), message: nil, buttons: [
                .default(Text("Take Photo")) {
                    imagePickerSourceType = .camera
                    isImagePickerPresented = true
                },
                .default(Text("Choose from Library")) {
                    imagePickerSourceType = .photoLibrary
                    isImagePickerPresented = true
                },
                .cancel()
            ])
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}



struct HandleNotification: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var notificationTime = Date()
    @Environment(\.presentationMode) var presentationMode
    @State private var scheduledTime: String? = nil
    
    var body: some View {
        ZStack {
            Color.cream.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Set Daily Reminder")
                    .font(.title)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                
                DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding()
                
                if let scheduledTime = scheduledTime {
                    Text("Current Reminder Time: \(scheduledTime)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Button("Schedule Daily Reminder") {
                    profileViewModel.scheduleDailyReminder(notificationTime: notificationTime) { scheduledTime, error in
                        if let error = error {
                            print("ERROR: \(error)")
                        } else if let scheduledTime = scheduledTime {
                            self.scheduledTime = scheduledTime
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .font(.headline)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.softLavender)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.cream)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
            .onAppear {
                scheduledTime = NotificationManager.shared.getNotificationTime()
            }
        }
    }
}

struct ChangeUsernameView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var tempUserName: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.cream.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Change Username")
                    .font(.title)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                
                ZStack {
                     Rectangle()
                         .foregroundColor(.white)
                         .frame(height: 44)
                         .cornerRadius(8)
                     
                     TextField("Enter new username", text: $tempUserName)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                 }
                 .padding()

                Button(action: {
                    if tempUserName.count >= 4 {
                        profileViewModel.updateUserName(tempUserName)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Submit")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.softLavender)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color.cream)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
        }
    }
}


#Preview {
    ProfileView(profileViewModel: ProfileViewModel())
}
