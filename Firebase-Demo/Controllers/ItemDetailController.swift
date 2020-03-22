//
//  ItemDetailController.swift
//  Firebase-Demo
//
//  Created by Kelby Mittan on 3/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ItemDetailController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var containerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var textView: UITextField!
    
    private var item: Item
    
    private var originalValueForConstraint: CGFloat = 0
    
    private var databaseService = DatabaseService.shared
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy h:mm a" //"EEEE, MMM d, yyyy h:mm a"
        return formatter
    }()
    
    private var listener: ListenerRegistration?
    
    private var comments = [Comment]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var isFavorite = false {
      didSet {
        if isFavorite {
          navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        } else {
          navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        }
      }
    }
    
    init?(coder: NSCoder, item: Item) {
        self.item = item
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = item.itemName
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.tableHeaderView = HeaderView(imageURL: item.imageURL)
        originalValueForConstraint = containerBottomConstraint.constant
        
        textView.delegate = self
        tableView.dataSource = self
        
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        registerKeyboardNotifications()
        
        listener = Firestore.firestore().collection(DatabaseService.itemsCollection).document(item.itemId).collection(DatabaseService.commentsCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "try again", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let comments = snapshot.documents.map { Comment($0.data()) }
                self?.comments = comments.sorted { $0.commentDate.dateValue() > $1.commentDate.dateValue() }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
        listener?.remove()
    }
    

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        dismissKeyboard()
        
        guard let commentText = textView.text, !commentText.isEmpty else {
            showAlert(title: "Missing Fields", message: "A comment is required to send.")
            return
        }
        
        postComment(text: commentText)
    }
    
    private func postComment(text: String) {
        databaseService.postComment(item: item, comment: text) {[weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Try Again", message: error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Comment posted", message: "")
                }
            }
        }
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        print(notification.userInfo ?? "")
        guard let keyboardFrame = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect else {
            return
        }
        
        containerBottomConstraint.constant = -(keyboardFrame.height - view.safeAreaInsets.bottom)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard() {
        containerBottomConstraint.constant = originalValueForConstraint
        textView.resignFirstResponder()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
      
      if isFavorite { // remove from favorites
        databaseService.removeFromFavorites(item: item) { [weak self] (result) in
          switch result {
          case .failure(let error):
            DispatchQueue.main.async {
              self?.showAlert(title: "Failed to remove favorite", message: error.localizedDescription)
            }
          case .success:
            DispatchQueue.main.async {
              self?.showAlert(title: "Item removed", message: "")
              self?.isFavorite = false
            }
          }
        }
      } else { // add to favorites
        databaseService.addToFavorites(item: item) { [weak self] (result) in
           switch result {
           case .failure(let error):
             DispatchQueue.main.async {
               self?.showAlert(title: "Favoriting error", message: error.localizedDescription)
             }
           case .success:
             DispatchQueue.main.async {
               self?.showAlert(title: "Item favorited", message: "")
              self?.isFavorite = true
             }
           }
         }
      }
      
      
    }
    
}

extension ItemDetailController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}

extension ItemDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        let comment = comments[indexPath.row]
        
        let dateString = dateFormatter.string(from: comment.commentDate.dateValue())
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = "@" + comment.commentedBy + " " + dateString
        return cell
    }
}
