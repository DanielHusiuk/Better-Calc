//
//  TimeHistoryController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 28.03.2025.
//

import UIKit
import CoreData

class TimeHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var HistoryTableView: UITableView!
    @IBOutlet weak var CloseBarButton: UIBarButtonItem!
    @IBOutlet weak var EditBarButton: UIBarButtonItem!
    
    var coreData = CoreDataManager.shared
    var converterId: Int64 = 5
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
        GestureManager.dismissSwipe(to: self)
        
        HistoryTableView.delegate = self
        HistoryTableView.dataSource = self
        saveConverterState()
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
    
    func toolBar(_ sender: UIToolbar) {
        navigationController?.isToolbarHidden = true
        let deleteAll = UIBarButtonItem(title: NSLocalizedString("history_delete_all", comment: ""), style: .plain, target: self, action: #selector(deleteAll))
        deleteAll.tintColor = .systemRed
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteObject))
        if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
            trashButton.tintColor = selectedTintColor
        }
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [deleteAll, flexibleSpace, trashButton]
    }
    
    func executeExternalFunction<T: UIViewController>(_ viewControllerType: T.Type, action: (T) -> (Void)) {
        if let navigationController = self.presentingViewController as? UINavigationController,
           let externalVC = navigationController.viewControllers.first(where: { $0 is T }) as? T {
            action(externalVC)
        }
    }
    
    func saveConverterState() {
        executeExternalFunction(TimeViewController.self) { $0.saveViewState() }
    }
    
    
    //MARK: - IB Actions
    
    @IBAction func unwindHome(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
        executeExternalFunction(TimeViewController.self, action: { $0.loadViewState() })
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
        } else {
            navigationController?.setToolbarHidden(false, animated: true)
            HistoryTableView.setEditing(true, animated: true)
            sender.title = NSLocalizedString("done", comment: "")
            sender.style = .done
            isEdit = true
            
            let toolbarHeight = navigationController?.toolbar.frame.size.height
            HistoryTableView.contentInset.bottom = toolbarHeight!
            HistoryTableView.verticalScrollIndicatorInsets.bottom = toolbarHeight!
            
            if UserDefaults.standard.bool(forKey: "HapticState") {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
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
            self.coreData.deleteAllConverterObjects(with: self.converterId)
            executeExternalFunction(TimeViewController.self, action: { $0.HistoryButtonOutlet.isEnabled = false })
            
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
        
        HistoryTableView.beginUpdates()
        for indexPath in sortedSelectedRows {
            let key = sortedSectionKeys[indexPath.section]
            if var group = groupedHistory[key] {
                let deleteItem = group[indexPath.row]
                coreData.deleteConverterObject(object: deleteItem)
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
            executeExternalFunction(TimeViewController.self, action: { $0.HistoryButtonOutlet.isEnabled = false })
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
    
    var groupedHistory: [String: [ConverterHistoryItem]] = [:]
    var sortedSectionKeys: [String] = []
    
    func loadHistory() {
        let fetchedHistory = coreData.fetchConverterObjects(with: self.converterId)
        dateFormatter.dateFormat = "d MMM, yyyy"
        
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
        dateFormatter.dateFormat = "d MMM, yyyy"
        
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
            cell.textLabel?.text = "\(String(describing: historyItem.fromUnitText!)) -  \(String(describing: historyItem.fromText!))"
            cell.detailTextLabel?.text = "\(String(describing: historyItem.toUnitText!)) -  \(String(describing: historyItem.toText!))"
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
        let key = sortedSectionKeys[indexPath.section]
        let selectedHistory = groupedHistory[key]?[indexPath.row]
        let sortedUnits = UnitsModel().timeDictionary.keys.sorted{ ($0.description) < ($1.description) }
        
        if HistoryTableView.isEditing == true {
            return
        } else {
            if let navigationController = self.presentingViewController as? UINavigationController,
               let converterVC = navigationController.viewControllers.first(where: { $0 is TimeViewController }) as? TimeViewController {
                if let fromText = selectedHistory?.fromText {
                    converterVC.FromLabelOutlet.text = ""
                    converterVC.ToLabelOutlet.text = ""
                    converterVC.FromLabelOutlet.text = fromText
                    
                    if sortedUnits.indices.contains(Int(selectedHistory!.fromUnit)) {
                        let fromUnits = sortedUnits[Int(selectedHistory!.fromUnit)]
                        converterVC.selectedUnits[converterVC.FromButtonOutlet] = fromUnits
                        converterVC.FromButtonOutlet.setTitle("\(fromUnits.symbol) ", for: .normal)
                    }
                    if sortedUnits.indices.contains(Int(selectedHistory!.toUnit)) {
                        let toUnits = sortedUnits[Int(selectedHistory!.toUnit)]
                        converterVC.selectedUnits[converterVC.ToButtonOutlet] = toUnits
                        converterVC.ToButtonOutlet.setTitle("\(toUnits.symbol) ", for: .normal)
                    }
                    
                    converterVC.UnitMenu(in: converterVC.FromButtonOutlet)
                    converterVC.UnitMenu(in: converterVC.ToButtonOutlet)
                    converterVC.convertFunc()
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }
    
}
