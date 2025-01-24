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
        buttonsTint()
        loadHistory()
        blurBackground()
        toolBar(UIToolbar.init())
        overrideUserInterfaceStyle = .dark
        
        HistoryTableView.delegate = self
        HistoryTableView.dataSource = self
        saveStandardState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        overrideUserInterfaceStyle = .unspecified
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
    
    func buttonsTint() {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
            self.CloseBarButton.tintColor = selectedTintColor
            self.EditBarButton.tintColor = selectedTintColor
        }
    }
    
    func toolBar(_ sender:UIToolbar) {
        navigationController?.isToolbarHidden = true
        let deleteAll = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAll))
        deleteAll.tintColor = .red
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteObject))
        if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
            trashButton.tintColor = selectedTintColor
        }
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [deleteAll, flexibleSpace, trashButton]
    }
    
    func saveStandardState() {
        if let navigationController = self.presentingViewController as? UINavigationController,
           let standardVC = navigationController.viewControllers.first(where: { $0 is StandardViewController }) as? StandardViewController {
            standardVC.saveViewState()
        }
    }
    
    
    //MARK: - IB Actions
    
    @IBAction func unwindHome(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
        if let navigationController = self.presentingViewController as? UINavigationController,
           let standardVC = navigationController.viewControllers.first(where: { $0 is StandardViewController }) as? StandardViewController {
            standardVC.loadViewState()
        }
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
        let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")
        let deleteAlert = UIAlertController(title: "Delete history?\nThis action is irreversible", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(selectedTintColor, forKey: "titleTextColor")
        deleteAlert.addAction(cancelAction)
        
        deleteAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            guard let self = self else { return }
            self.coreData.deleteAllObjects(with: self.historyId)
            
            if let navigationController = self.presentingViewController as? UINavigationController,
               let standardVC = navigationController.viewControllers.first(where: { $0 is StandardViewController }) as? StandardViewController {
                standardVC.HistoryButtonOutlet.isEnabled = false
            }
            
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.setToolbarHidden(true, animated: true)
        }))
        present(deleteAlert, animated: true, completion: nil)
        
        loadHistory()
        guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @IBAction func deleteObject(_ sender: UIBarButtonItem) {
        guard isEdit else { return }

        guard let selectedRows = HistoryTableView.indexPathsForSelectedRows else {
            let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")
            let chooseAlert = UIAlertController(title: "Nothing to delete", message: "Choose results you want to delete", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default)
            okayAction.setValue(selectedTintColor, forKey: "titleTextColor")
            chooseAlert.addAction(okayAction)
            present(chooseAlert, animated: true, completion: nil)
            return
        }
        let sortedSelectedRows = selectedRows.sorted(by: { $0.item > $1.item })
        print("Rows to delete: \(sortedSelectedRows)")

        HistoryTableView.beginUpdates()
        for indexPath in sortedSelectedRows {
            let key = sortedSectionKeys[indexPath.section]
            if var group = groupedHistory[key] {
                let deleteItem = group[indexPath.row]
                coreData.deleteObject(object: deleteItem)
                group.remove(at: indexPath.row)
                
                if group.isEmpty {
                    groupedHistory.removeValue(forKey: key)
                    sortedSectionKeys.remove(at: indexPath.section)
                    HistoryTableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    groupedHistory[key] = group
                    HistoryTableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
        HistoryTableView.endUpdates()

        if groupedHistory.isEmpty {
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
    
    
    //MARK: - History Logic
    
    var groupedHistory: [String: [HistoryItem]] = [:]
    var sortedSectionKeys: [String] = []

    func loadHistory() {
        let fetchedHistory = coreData.fetchObjects(with: self.historyId)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        groupedHistory = Dictionary(grouping: fetchedHistory) { historyItem in
            guard let date = historyItem.date else { return "Unknown Date" }
            return dateFormatter.string(from: date)
        }
        sortedSectionKeys = groupedHistory.keys.sorted { key1, key2 in
            let date1 = dateFormatter.date(from: key1) ?? Date.distantPast
            let date2 = dateFormatter.date(from: key2) ?? Date.distantPast
            return date1 < date2
        }
        HistoryTableView.reloadData()
    }
    
    
    //MARK: - History Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedSectionKeys.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sortedSectionKeys[section]
        return groupedHistory[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSectionKeys[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let key = sortedSectionKeys[indexPath.section]
        if let historyItem = groupedHistory[key]?[indexPath.row] {
            cell.textLabel?.text = historyItem.working
            cell.detailTextLabel?.text = historyItem.result
        }
        
        let customBackgroundView = UIView()
        customBackgroundView.backgroundColor = #colorLiteral(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        cell.selectedBackgroundView = customBackgroundView
        
        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))
        if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
            disclosureIndicator.tintColor = selectedTintColor
        }
        cell.accessoryView = disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if HistoryTableView.isEditing == true {
            return
        } else {
            let key = sortedSectionKeys[indexPath.section]
            let selectedHistory = groupedHistory[key]?[indexPath.row]
            
            if let navigationController = self.presentingViewController as? UINavigationController,
               let standardVC = navigationController.viewControllers.first(where: { $0 is StandardViewController }) as? StandardViewController {
                if let workingText = selectedHistory?.working, let resultText = selectedHistory?.result {
                    standardVC.WorkingsLabelOutlet.text = ""
                    standardVC.ResultsLabelOutlet.text = ""
                    standardVC.WorkingsLabelOutlet.text = workingText
                    standardVC.ResultsLabelOutlet.text = resultText
                                        
                    let symbolRange = CharacterSet(charactersIn: "+−×÷")
                    if let currentOperationRange = workingText.rangeOfCharacter(from: symbolRange) {
                        let symbol = workingText[currentOperationRange]
                        switch symbol {
                        case "+":
                            standardVC.currentOperation = .addition
                        case "−":
                            standardVC.currentOperation = .subtraction
                        case "×":
                            standardVC.currentOperation = .multiplication
                        case "÷":
                            standardVC.currentOperation = .division
                        default:
                            break
                        }
                    }
                    standardVC.isTypingNumber = true
                    
                    if standardVC.EraseButtonOutlet.isHidden == true || standardVC.PasteResultButtonOutlet.isHidden == true {
                        standardVC.checkEraseButton()
                        standardVC.checkPasteButton()
                    }
                }
            } else {
                print("Previous Controller not found")
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }

}
