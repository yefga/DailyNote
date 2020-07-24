//
//  NotesViewController.swift
//  Note
//
//  Created by Yefga on 23/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    
    var viewModel = NotesViewModel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.request()
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
        super.viewDidAppear(true)
    }
    
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.emptyView.isHidden = !self.viewModel.results.isEmpty
            self.tableView.reloadData()
        }
    }
    
    
    private func toEditViewController() {
        let rootViewController = EditViewController.instantiate()
        rootViewController.delegate = self
        
        let viewControllerToPresent = UINavigationController(rootViewController: rootViewController)
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    
    @IBAction func add(_ sender: Any) {
        Preferences.setState(active: true, key: "add")
        toEditViewController()
    }
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Preferences.setState(active: false, key: "add")
        
        if let id = viewModel.results[indexPath.section].notesArray[indexPath.row].id {
            UserDefaults.standard.set("\(id)", forKey: "noteID")
        }
        
        toEditViewController()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.deleteNote(from: tableView, indexPath: indexPath)
        }
    
    }    
}

extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitle(section: section)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows(section: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        viewModel.cellConfigure(cell, indexPath: indexPath)
        
        return cell
        
    }
    
}

extension NotesViewController: EditViewDelegate {
    
    func notifySaved() {
        self.viewModel.request()
        updateUI()
    }
    
}
