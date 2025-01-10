//
//  StandardHistoryController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 06.09.2024.
//

import UIKit
import CoreData

class StandardHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var HistoryTableView: UITableView!
    @IBOutlet weak var CloseBarButton: UIBarButtonItem!
    @IBOutlet weak var EditBarButton: UIBarButtonItem!
    
    var coreData = CoreDataManager.shared
    var historyId: Int16 = 1
    var isEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHistory()
        blurBackground()
        toolBar(UIToolbar.init())
        overrideUserInterfaceStyle = .dark
        
        HistoryTableView.delegate = self
        HistoryTableView.dataSource = self
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        overrideUserInterfaceStyle = .unspecified
    }
    
    
    //MARK: - IB Actions
    
    @IBAction func unwindHome(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if isEdit {
            navigationController?.setToolbarHidden(true, animated: true)
            HistoryTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            sender.style = .plain
            isEdit = false
            
            HistoryTableView.contentInset.bottom = 0
            HistoryTableView.verticalScrollIndicatorInsets.bottom = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.CloseBarButton.isEnabled = true
            })
        } else {
            navigationController?.setToolbarHidden(false, animated: true)
            HistoryTableView.setEditing(true, animated: true)
            sender.title = "Done"
            sender.style = .done
            isEdit = true
            
            let toolbarHeight = navigationController?.toolbar.frame.size.height
            HistoryTableView.contentInset.bottom = toolbarHeight!
            HistoryTableView.verticalScrollIndicatorInsets.bottom = toolbarHeight!
            UIView.animate(withDuration: 0.3, animations: {
                self.CloseBarButton.isEnabled = false
            })
        }
    }
    
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Delete history?", message: "This action is irreversible", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            guard let self = self else { return }
            self.coreData.deleteAllObjects(with: self.historyId)
            
            if let navigationController = self.presentingViewController as? UINavigationController,
               let standardVC = navigationController.viewControllers.first(where: { $0 is StandardViewController }) as? StandardViewController {
                standardVC.HistoryButtonOutlet.isEnabled = false
            }
            
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.setToolbarHidden(true, animated: true)
        }))
        present(refreshAlert, animated: true, completion: nil)
        
        loadHistory()
        guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @IBAction func deleteObject(_ sender: UIBarButtonItem) {
        guard isEdit else { return }

        guard let selectedRows = HistoryTableView.indexPathsForSelectedRows else {
            let chooseAlert = UIAlertController(title: "Nothing to delete", message: "Choose results you want to delete", preferredStyle: .alert)
            chooseAlert.addAction(UIAlertAction(title: "Okay", style: .default))
            present(chooseAlert, animated: true, completion: nil)
            return
        }

        let sortedSelectedRows = selectedRows.sorted(by: { $0.item > $1.item })
        print("Rows to delete: \(sortedSelectedRows)")

        for indexPath in sortedSelectedRows {
            let deleteItem = historyArray[indexPath.row]
            coreData.deleteObject(object: deleteItem)
            historyArray.remove(at: indexPath.row)
        }
        
        HistoryTableView.performBatchUpdates {
            HistoryTableView.deleteRows(at: sortedSelectedRows, with: .fade)
        }

        if historyArray.isEmpty {
            if let navigationController = self.presentingViewController as? UINavigationController,
               let standardVC = navigationController.viewControllers.first(where: { $0 is StandardViewController }) as? StandardViewController {
                standardVC.HistoryButtonOutlet.isEnabled = false
            }
            self.dismiss(animated: true, completion: nil)
        }

        HistoryTableView.setEditing(false, animated: true)
        EditBarButton.title = "Edit"
        EditBarButton.style = .plain
        isEdit = false

        navigationController?.setToolbarHidden(true, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.CloseBarButton.isEnabled = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.loadHistory()
        }
    }
    
    
    //MARK: - Preferences
    
    func blurBackground() {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false
        view.insertSubview(blurEffectView, at: 0)
    }
    
    func toolBar(_ sender:UIToolbar) {
        navigationController?.isToolbarHidden = true
        let deleteAll = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAll))
        deleteAll.tintColor = .red
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteObject))
        trashButton.tintColor = #colorLiteral(red: 0.8, green: 0.5098039216, blue: 0.2784313725, alpha: 1)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [deleteAll, flexibleSpace, trashButton]
    }
    
    
    //MARK: - History Logic
    
    var historyArray: [HistoryItem] = [ ]
    
    func loadHistory() {
        historyArray = coreData.fetchObjects(with: self.historyId)
        HistoryTableView.reloadData()
    }
    
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let historyItem = historyArray[indexPath.row]
        cell.textLabel?.text = historyItem.working
        cell.detailTextLabel?.text = historyItem.result
        
        let customBackgroundView = UIView()
        customBackgroundView.backgroundColor = #colorLiteral(red: 0.3000000119, green: 0.3000000119, blue: 0.3000000119, alpha: 1)
        cell.selectedBackgroundView = customBackgroundView
        
        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))
        disclosureIndicator.tintColor = #colorLiteral(red: 0.8, green: 0.5098039216, blue: 0.2784313725, alpha: 1)
        cell.accessoryView = disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if HistoryTableView.isEditing == true {
            return
        } else {
            let selectedHistory = historyArray[indexPath.row]
            
            if let navigationController = self.presentingViewController as? UINavigationController,
               let standardVC = navigationController.viewControllers.first(where: { $0 is StandardViewController }) as? StandardViewController {
                if let workingText = selectedHistory.working, let resultText = selectedHistory.result {
                    standardVC.WorkingsLabelOutlet.text = ""
                    standardVC.ResultsLabelOutlet.text = ""
                    standardVC.WorkingsLabelOutlet.text = "\(workingText)"
                    standardVC.ResultsLabelOutlet.text = "\(resultText)"
                    standardVC.isTypingNumber = false
                    
                    if standardVC.EraseButtonOutlet.isHidden == true || standardVC.PasteResultButtonOutlet.isHidden == true {
                        standardVC.EraseButtonOutlet.alpha = 0.0
                        standardVC.PasteResultButtonOutlet.alpha = 0.0
                        standardVC.EraseButtonOutlet.isHidden = false
                        standardVC.PasteResultButtonOutlet.isHidden = false
                        UIView.animate(withDuration: 0.1, animations: {
                            standardVC.EraseButtonOutlet.alpha = 1.0
                            standardVC.PasteResultButtonOutlet.alpha = 1.0
                        })
                    }
                }
            } else {
                print("Previous Controller not found")
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }

}
