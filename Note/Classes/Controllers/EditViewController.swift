//
//  EditViewController.swift
//  Note
//
//  Created by Yefga on 23/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit

protocol EditViewDelegate: class {
    func notifySaved()
}

class EditViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveUpdateButton: UIBarButtonItem!
    
    private var state: Bool = false {
        didSet {
            if state {
                self.title = "Add"
                self.saveUpdateButton.title = "Save"
            } else {
                self.viewModel.fetch()
                self.title = "Edit"
                self.titleTextField.text = viewModel.note?.title
                self.noteTextView.text = viewModel.note?.text
                self.saveUpdateButton.title = "Update"
            }
        }
    }
    
    weak var delegate: EditViewDelegate!
    
    
    var viewModel = EditViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        state = Preferences.getState(key: "add")
        
        titleTextField.addTarget(self, action: #selector(titleDidChange), for: .allEditingEvents)
        noteTextView.delegate = self
    }
    
    
    private func createAlert() {
        let alertController = UIAlertController(
            title: "Woops!",
            message: "Please input at least a title before save your note", preferredStyle: .alert
        )
        
        alertController.addAction(
            .init(
                title: "Ok",
                style: .default,
                handler: nil)
        )
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func update() {
        if viewModel.validate() {
            createAlert()
        } else {
            viewModel.action(
                from: state,
                completion: {
                    
                self.navigationController?.dismiss(
                    animated: true,
                    completion: {
                 
                        self.delegate.notifySaved()
               
                })
            
            })
            
        }
    }
    
    
    @IBAction private func saveAndUpdate(_ sender: Any) {
        self.update()
    }
    
    
    @objc func titleDidChange(_ sender: UITextField) {
        if let text = sender.text {
            viewModel.getTitle(text)
        }
    }
}

extension EditViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            viewModel.getNote(text)
        }
    }

}

