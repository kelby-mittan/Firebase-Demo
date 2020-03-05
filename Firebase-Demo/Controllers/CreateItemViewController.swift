//
//  CreateItemViewController.swift
//  Firebase-Demo
//
//  Created by Kelby Mittan on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateItemViewController: UIViewController {

    @IBOutlet var itemNameTextField: UITextField!
    
    @IBOutlet var itemPriceTextField: UITextField!
    
    @IBOutlet var itemImageView: UIImageView!
    
    private var category: Category
    
    private let dbService = DatabaseService()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            itemImageView.image = selectedImage
        }
    }
    
    init?(coder: NSCoder, category: Category) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = category.name
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func sellButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let itemName = itemNameTextField.text, !itemName.isEmpty, let priceText = itemPriceTextField.text, !priceText.isEmpty, let price = Double(priceText) else {
            
            showAlert(title: "Missing Fields", message: "All fields are required.")
            return
        }
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete Profile", message: "Please go to the profile to complete your Profile")
            return
        }
        
        dbService.createItem(itemName: itemName, price: price, category: category, displayName: displayName) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Bleep", message: "Error: \(error.localizedDescription)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Cool", message: "Succesfully Listed Your Item")
                }
            }
        }
        
    }
}

extension CreateItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError()
        }
        
        selectedImage = image
        dismiss(animated: true)
    }
}
