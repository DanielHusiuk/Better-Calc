//
//  BasicHistoryController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 06.09.2024.
//

import UIKit
import CoreData

class BasicHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var HistoryTableView: UITableView!
    @IBOutlet weak var CloseBarButton: UIBarButtonItem!
    @IBOutlet weak var EditBarButton: UIBarButtonItem!
    
    @IBOutlet weak var NavigationTitleOutlet: UINavigationItem!
    
    var coreData = CoreDataManager.shared
    var historyId: Int16 = 1
    let dateFormatter = DateFormatter()
    
    var isEdit: Bool = false
    let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        buttonsTint()
        loadHistory()
        blurBackground()
        toolBar(UIToolbar.init())
        
        HistoryTableView.delegate = self
        HistoryTableView.dataSource = self
        saveBasicState()
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
        CloseBarButton.tintColor = selectedTintColor
        EditBarButton.tintColor = selectedTintColor
        HistoryTableView.tintColor = selectedTintColor
    }
    
    func toolBar(_ sender:UIToolbar) {
        navigationController?.isToolbarHidden = true
        let deleteAll = UIBarButtonItem(title: NSLocalizedString("history_delete_all", comment: ""), style: .plain, target: self, action: #selector(deleteAll))
        deleteAll.tintColor = .red
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteObject))
        if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
            trashButton.tintColor = selectedTintColor
        }
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [deleteAll, flexibleSpace, trashButton]
    }
    
    func saveBasicState() {
        if let navigationController = self.presentingViewController as? UINavigationController,
           let basicVC = navigationController.viewControllers.first(where: { $0 is BasicViewController }) as? BasicViewController {
            basicVC.saveViewState()
        }
    }
    
    
    //MARK: - IB Actions
    
    @IBAction func unwindHome(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
        if let navigationController = self.presentingViewController as? UINavigationController,
           let basicVC = navigationController.viewControllers.first(where: { $0 is BasicViewController }) as? BasicViewController {
            basicVC.loadViewState()
        }
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if isEdit {
            navigationController?.setToolbarHidden(true, animated: true)
            HistoryTableView.setEditing(false, animated: true)
            sender.title = NSLocalizedString("edit", comment: "")
            sender.style = .plain
            isEdit = false
            
            HistoryTableView.contentInset.bottom = 0
            HistoryTableView.verticalScrollIndicatorInsets.bottom = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.CloseBarButton.isEnabled = true
            })
            
            if UserDefaults.standard.bool(forKey: "HapticState") {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        } else {
            navigationController?.setToolbarHidden(false, animated: true)
            HistoryTableView.setEditing(true, animated: true)
            sender.title = NSLocalizedString("done", comment: "")
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
        let deleteAlert = UIAlertController(title: "\(NSLocalizedString("delete_history", comment: ""))\n\(NSLocalizedString("this_action_is_irreversible", comment: ""))" , message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        cancelAction.setValue(selectedTintColor, forKey: "titleTextColor")
        deleteAlert.addAction(cancelAction)
        
        deleteAlert.addAction(UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            guard let self = self else { return }
            self.coreData.deleteAllObjects(with: self.historyId)
            
            if let navigationController = self.presentingViewController as? UINavigationController,
               let basicVC = navigationController.viewControllers.first(where: { $0 is BasicViewController }) as? BasicViewController {
                basicVC.HistoryButtonOutlet.isEnabled = false
            }
            
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.setToolbarHidden(true, animated: true)
        }))
        present(deleteAlert, animated: true, completion: nil)
        
        loadHistory()
    }
    
    @IBAction func deleteObject(_ sender: UIBarButtonItem) {
        guard isEdit else { return }
        
        guard let selectedRows = HistoryTableView.indexPathsForSelectedRows else {
            let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")
            let chooseAlert = UIAlertController(title: NSLocalizedString("history_nothing_to_delete", comment: ""), message: NSLocalizedString("history_choose_results_you_want_to_delete", comment: ""), preferredStyle: .alert)
            let okayAction = UIAlertAction(title: NSLocalizedString("okay", comment: ""), style: .default)
            okayAction.setValue(selectedTintColor, forKey: "titleTextColor")
            chooseAlert.addAction(okayAction)
            present(chooseAlert, animated: true, completion: nil)
            
            if UserDefaults.standard.bool(forKey: "HapticState") {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
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
               let basicVC = navigationController.viewControllers.first(where: { $0 is BasicViewController }) as? BasicViewController {
                basicVC.HistoryButtonOutlet.isEnabled = false
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        HistoryTableView.setEditing(false, animated: true)
        EditBarButton.title = NSLocalizedString("edit", comment: "")
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
    
    
    //MARK: - History Grouping Logic
    
    var groupedHistory: [String: [HistoryItem]] = [:]
    var sortedSectionKeys: [String] = []
    
    func loadHistory() {
        let fetchedHistory = coreData.fetchObjects(with: self.historyId)
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        groupedHistory = Dictionary(grouping: fetchedHistory) { historyItem in
            guard let date = historyItem.date else { return "Unknown Date" }
            return dateFormatter.string(from: date)
        }
        sortedSectionKeys = groupedHistory.keys.sorted { key1, key2 in
            let date1 = dateFormatter.date(from: key1) ?? Date.distantPast
            let date2 = dateFormatter.date(from: key2) ?? Date.distantPast
            return date1 > date2
        }
        HistoryTableView.reloadData()
    }
    
    
    //MARK: - History Table View
    
    func isDateInToday(_ date: Date) -> Bool { return true }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedSectionKeys.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sortedSectionKeys[section]
        return groupedHistory[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let today = Date.now
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        print("today date: \(dateFormatter.string(from: today))")
        print("yesterday date: \(dateFormatter.string(from: yesterday))")
        print("sortedSectionKeys: \(sortedSectionKeys[section])")
        
        if sortedSectionKeys[section] == dateFormatter.string(from: today) {
            return NSLocalizedString("today", comment: "")
        } else if sortedSectionKeys[section] == dateFormatter.string(from: yesterday) {
            return NSLocalizedString("yesterday", comment: "")
        } else {
            return sortedSectionKeys[section]
        }
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
               let basicVC = navigationController.viewControllers.first(where: { $0 is BasicViewController }) as? BasicViewController {
                if let workingText = selectedHistory?.working, let resultText = selectedHistory?.result {
                    basicVC.WorkingsLabelOutlet.text = ""
                    basicVC.ResultsLabelOutlet.text = ""
                    basicVC.WorkingsLabelOutlet.text = workingText
                    basicVC.ResultsLabelOutlet.text = resultText
                    
                    let symbolRange = CharacterSet(charactersIn: "+−×÷")
                    if let currentOperationRange = workingText.rangeOfCharacter(from: symbolRange) {
                        let symbol = workingText[currentOperationRange]
                        switch symbol {
                        case "+":
                            basicVC.currentOperation = .addition
                        case "−":
                            basicVC.currentOperation = .subtraction
                        case "×":
                            basicVC.currentOperation = .multiplication
                        case "÷":
                            basicVC.currentOperation = .division
                        default:
                            break
                        }
                    }
                    basicVC.isTypingNumber = true
                    
                    if basicVC.EraseButtonOutlet.isHidden == true || basicVC.PasteResultButtonOutlet.isHidden == true {
                        basicVC.checkEraseButton()
                        basicVC.checkPasteButton()
                    }
                }
            } else {
                print("Previous Controller not found")
            }
            self.dismiss(animated: true, completion: nil)
        }
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }
    
}
