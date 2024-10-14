//
//  ProfileViewController.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nombre de usuario:"
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Actualizar perfil", for: .normal)
        return button
    }()
    
    let changeProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cambiar Foto de Perfil", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        loadUserProfile()
        
        updateButton.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        changeProfileImageButton.addTarget(self, action: #selector(changeProfilePicture), for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(profileImageView)
        view.addSubview(updateButton)
        view.addSubview(changeProfileImageButton)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            changeProfileImageButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            changeProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            updateButton.topAnchor.constraint(equalTo: changeProfileImageButton.bottomAnchor, constant: 20),
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func loadUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userDocRef = Firestore.firestore().collection("users").document(userId)
        userDocRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self?.nameTextField.text = data?["username"] as? String
                
                if let profileImageUrl = data?["profileImageUrl"] as? String {
                    self?.loadProfileImage(urlString: profileImageUrl)
                }
            } else {
                print("User does not exist or error: \(error?.localizedDescription ?? "")")
            }
        }
    }

    private func loadProfileImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }

    @objc private func updateProfile() {
        guard let userId = Auth.auth().currentUser?.uid,
              let newUsername = nameTextField.text else { return }
        
        let userDocRef = Firestore.firestore().collection("users").document(userId)
        userDocRef.updateData(["username": newUsername]) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: "Error al actualizar el perfil", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Profile updated successfully")
                let alert = UIAlertController(title: "Atención", message: "Se ha actualizado la información de tu perfil correctamente.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @objc private func changeProfilePicture() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            uploadProfileImage(selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }

    private func uploadProfileImage(_ image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.75) {
            storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let downloadURL = url?.absoluteString else { return }
                    self?.updateUserProfileImageURL(downloadURL)
                }
            }
        }
    }

    private func updateUserProfileImageURL(_ url: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).updateData(["profileImageUrl": url]) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("User profile updated successfully.")
            }
        }
    }
}
