//
//  SettingsViewController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 30.09.2024.
//

import UIKit
import CoreData

var selectedSegueIdentifier: String?

enum Section: Int, CaseIterable {
    case colorTheme
    case openLaunch
    case preferences
    case data
    case info
}

enum RowItem: Hashable {
    case header(String)
    case details(String)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var RightNavBarButton: UIBarButtonItem!
    
    var tableView: UITableView!
    var choosedCalcTextLabel: UILabel?
    var selectedPickerText: String = "None"
    
    var pickerView: UIPickerView?
    let pickersModel = PickerModel()
    private var expandedSections: Set<Int> = []
    
    private var model = ButtonsModel()
    private var mainView = ViewController()
    
    private var tintModel = TintModel()
    private var selectedTintId: Int16 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferences()
        loadTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightNavBarButtonIcon()
        loadSavePicker()
        loadNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        origAppear()
    }
    
    //MARK: - Update
    
    func updatePreferences() {
        let defaultTintCell = 1
        let savedIndex = UserDefaults.standard.integer(forKey: "selectedTint")
        let indexToUse = savedIndex == 0 ? defaultTintCell : savedIndex
        selectedIndexPath = IndexPath(row: indexToUse, section: 0)
        
        if UserDefaults.standard.object(forKey: "HapticState") == nil {
            UserDefaults.standard.set(true, forKey: "HapticState")
        }
        
        if UserDefaults.standard.object(forKey: "ResetState") == nil {
            UserDefaults.standard.set(false, forKey: "ResetState")
        }
    }
    
    
    //MARK: - Navigation Bar
    
    var originalAppearance: UINavigationBarAppearance?
    
    func loadNavBar() {
        originalAppearance = navigationController?.navigationBar.standardAppearance
        let customFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: customFont, .foregroundColor: UIColor.white]
        appearance.backgroundEffect = blurEffect
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func origAppear() {
        if let originalAppearance = originalAppearance {
            navigationController?.navigationBar.standardAppearance = originalAppearance
        }
    }
    
    @IBAction func ResetSettingsButtonOutlet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Reset settings?", message: "This will reset all parameters to default", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            self?.resetUserSettings()
            if let navigationController = self?.navigationController {
                navigationController.popViewController(animated: true)
            }
            
        }))
        present(alert, animated: true, completion: nil)
        
        guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func resetUserSettings() {
        UserDefaults.standard.removeObject(forKey: "selectedTint")
        UserDefaults.standard.removeObject(forKey: "SelectedPickerRow")
        UserDefaults.standard.removeObject(forKey: "SelectedPickerString")
        UserDefaults.standard.removeObject(forKey: "HapticState")
        UserDefaults.standard.removeObject(forKey: "ResetState")
        loadSavePicker()
        loadNavBar()
        setIcon(.icon1)
        mainView.resetMenuFunc()
        
        if let navController = self.navigationController as? NavigationController {
            navController.resButtonPill()
        }
            updatePreferences()
        }
    
    func rightNavBarButtonIcon() {
        if #available(iOS 17.0, *) {
            RightNavBarButton.image = UIImage(systemName: "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90")
        } else {
            RightNavBarButton.image = UIImage(systemName: "exclamationmark.arrow.circlepath")
        }
    }
    
    
    //MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickersModel.pickers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickersModel.pickers[row].0, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Row \(row) selected")
        let selectedItem = pickersModel.pickers[row].0
        selectedPickerText = selectedItem
        
        let selectedSegue = pickersModel.pickers[row].1
        UserDefaults.standard.set(selectedSegue, forKey: "SelectedPickerString")
        
        UserDefaults.standard.set(row, forKey: "SelectedPickerRow")
        tableView.reloadRows(at: [IndexPath(row: 0, section: Section.openLaunch.rawValue)], with: .none)
    }
    
    func loadSavePicker() {
        let savedRow = UserDefaults.standard.integer(forKey: "SelectedPickerRow")
        print("Loaded row: \(savedRow)")
        
        let savedSegue = UserDefaults.standard.string(forKey: "SelectedPickerString")
        let unwrappedSavedSegue = savedSegue.map { String(describing: $0) } ?? ""
        print("Loaded segue: \(unwrappedSavedSegue)")
        
        if savedRow >= 0 && savedRow < pickersModel.pickers.count {
            pickerView?.selectRow(savedRow, inComponent: 0, animated: false)
            selectedPickerText = pickersModel.pickers[savedRow].0
        } else {
            selectedPickerText = "None"
        }
    }
    
    
    //MARK: - TableView
    
    func loadTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        tableView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        tableView.separatorColor = .darkGray
        tableView.indicatorStyle = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ColorThemeCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PickerHeaderCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PickerDetailCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HapticCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResetCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResetMenuCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeleteCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DevInfoCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Color theme:"
        case 1:
            return "Open with launch:"
        case 2:
            return "Preferences:"
        case 3:
            return "Data:"
        case 4:
            return "Info:"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            if expandedSections.contains(section) {
                return 2
            } else {
                return 1
            }
        case 2, 3:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let items = CGFloat(iconModel.icons.count)
            let rows = ceil(items / 3.0)
            let height = rows * 110
            return height + 30
        case 1:
            switch indexPath.row {
            case 1:
                return 145
            default:
                return 44
            }
        case 2, 3, 4:
            return 44
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .colorTheme:
            let colorCell = tableView.dequeueReusableCell(withIdentifier: "ColorThemeCell", for: indexPath)
            layoutCollection(in: colorCell)
            return colorCell
        case .openLaunch:
            if indexPath.row == 0 {
                let headerCell = tableView.dequeueReusableCell(withIdentifier: "PickerHeaderCell", for: indexPath)
                headerCell.contentView.subviews.forEach { $0.removeFromSuperview() }
                pickerHeader(in: headerCell)
                return headerCell
            } else {
                let detailCell = tableView.dequeueReusableCell(withIdentifier: "PickerDetailCell", for: indexPath)
                if pickerView == nil {
                    pickerDetail(in: detailCell)
                }
                return detailCell
            }
        case .preferences:
            if indexPath.row == 0 {
                let hapticCell = tableView.dequeueReusableCell(withIdentifier: "HapticCell", for: indexPath)
                hapticButton(in: hapticCell)
                return hapticCell
            } else {
                let resetCell = tableView.dequeueReusableCell(withIdentifier: "ResetCell", for: indexPath)
                resetCalc(in: resetCell)
                return resetCell
            }
        case .data:
            if indexPath.row == 0 {
                let resetMenuCell = tableView.dequeueReusableCell(withIdentifier: "ResetMenuCell", for: indexPath)
                resetMenu(in: resetMenuCell)
                return resetMenuCell
            } else {
                let deleteCell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell", for: indexPath)
                deleteHistory(in: deleteCell)
                return deleteCell
            }
        case .info:
            let devCell = tableView.dequeueReusableCell(withIdentifier: "DevInfoCell", for: indexPath)
            developerInfo(in: devCell)
            return devCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0.1980375946, green: 0.1980375946, blue: 0.1980375946, alpha: 1)
        let customBackgroundView = UIView()
        customBackgroundView.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        cell.selectedBackgroundView = customBackgroundView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                if expandedSections.contains(indexPath.section) {
                    expandedSections.remove(indexPath.section)
                } else {
                    expandedSections.insert(indexPath.section)
                }
                tableView.reloadSections([indexPath.section], with: .fade)
                loadSavePicker()
            }
        case 3:
            switch indexPath.row {
            case 0:
                mainView.resetMenuFunc()
                resetButtonAlertFunc()
            case 1:
                deleteHistoryFunc()
            default:
                return
            }
        case 4:
            devGitFunc()
        default:
            return
        }
        guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0, 2:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = UIColor.darkGray
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    //MARK: - Color Theme
    
    private var collectionView: UICollectionView?
    private var iconModel = IconsModel()
    private var selectedIndexPath: IndexPath?
    
    private func layoutCollection(in cell: UITableViewCell) {
        if collectionView != nil {
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(IconCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        collectionView?.isScrollEnabled = false
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(collectionView!)
        
        NSLayoutConstraint.activate([
            collectionView!.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            collectionView!.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconModel.icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? IconCell else {
            return UICollectionViewCell()
        }
        let buttonRow = iconModel.icons[indexPath.row]
        collectionCell.configure(with: buttonRow.text, image: buttonRow.image)
        collectionCell.button.tag = indexPath.row

        if selectedIndexPath == indexPath {
            collectionCell.borderView.layer.borderWidth = 2
            collectionCell.borderView.layer.borderColor = #colorLiteral(red: 0.9000000358, green: 0.9000000358, blue: 0.9000000358, alpha: 1)
        } else {
            collectionCell.borderView.layer.borderWidth = 0
        }

        collectionCell.button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return collectionCell
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let buttonRow = iconModel.icons[sender.tag]
        buttonRow.action()
        
        selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        UserDefaults.standard.set(sender.tag, forKey: "selectedTint")
        UserDefaults.standard.synchronize()
        collectionView?.reloadData()
        
        selectedTintId = tintModel.tints[sender.tag].id /// Збереження вибраного id
        print("\(buttonRow.text) Button Pressed")
        
        guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    
    //MARK: - Open With Launch
    
    func pickerHeader(in cell: UITableViewCell) {
        let CalcTextLabel = UILabel()
        CalcTextLabel.text = "Calculator"
        CalcTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        CalcTextLabel.textColor = .white
        CalcTextLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(CalcTextLabel)
        
        NSLayoutConstraint.activate([
            CalcTextLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            CalcTextLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18)
        ])
        
        let choosedCalcTextLabel = UILabel()
        choosedCalcTextLabel.text = selectedPickerText
        choosedCalcTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        choosedCalcTextLabel.textColor = #colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1)
        choosedCalcTextLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(choosedCalcTextLabel)
        
        NSLayoutConstraint.activate([
            choosedCalcTextLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            choosedCalcTextLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18)
        ])
    }
    
    func pickerDetail(in cell: UITableViewCell) {
        pickerView = UIPickerView()
        pickerView?.dataSource = self
        pickerView?.delegate = self
        pickerView?.backgroundColor = .clear
        cell.contentView.addSubview(pickerView!)
        pickerView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView!.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            pickerView!.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            pickerView!.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: -40),
            pickerView!.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 40)
        ])
    }
    
    
    //MARK: - Preferences
    
    //haptic
    func hapticButton(in cell: UITableViewCell) {
        let hapticSwitch = UISwitch()
        hapticSwitch.onTintColor = #colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1)
        hapticSwitch.isOn = UserDefaults.standard.bool(forKey: "HapticState")
        hapticSwitch.addTarget(self, action: #selector(hapticSwitchChanged(_:)), for: .valueChanged)
        cell.accessoryView = hapticSwitch
        
        let hapticText = UILabel()
        hapticText.text = "Haptic feedback"
        hapticText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        hapticText.textColor = .white
        hapticText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(hapticText)
        NSLayoutConstraint.activate([
            hapticText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            hapticText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18)
        ])
    }
    
    @objc func hapticSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "HapticState")
        } else {
            UserDefaults.standard.set(false, forKey: "HapticState")
        }
    }
    
    //calc
    func resetCalc(in cell: UITableViewCell) {
        let resetSwitch = UISwitch()
        resetSwitch.onTintColor = #colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1)
        resetSwitch.isOn = UserDefaults.standard.bool(forKey: "ResetState")
        resetSwitch.addTarget(self, action: #selector(resetSwitchChanged(_:)), for: .valueChanged)
        cell.accessoryView = resetSwitch
        
        let resetCalcText = UILabel()
        resetCalcText.text = "Reset data with close"
        resetCalcText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        resetCalcText.textColor = .white
        resetCalcText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(resetCalcText)
        NSLayoutConstraint.activate([
            resetCalcText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            resetCalcText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18)
        ])
    }
    
    @objc func resetSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "ResetState")
            ///reset calc data logic
        } else {
            UserDefaults.standard.set(false, forKey: "ResetState")
        }
    }
    
    
    //MARK: - Data
    
    var coreData = CoreDataManager.shared
    
    //reset
    func resetMenu(in cell: UITableViewCell) {
        let resetText = UILabel()
        resetText.text = "Reset menu buttons positions"
        resetText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        resetText.textColor = #colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1)
        resetText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(resetText)
        NSLayoutConstraint.activate([
            resetText.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            resetText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
    }
    
    func resetButtonAlertFunc() {
        if let navController = self.navigationController as? NavigationController {
            navController.resButtonPill()
        }
    }
    
    //delete
    func deleteHistory(in cell: UITableViewCell) {
        let deleteText = UILabel()
        deleteText.text = "Delete all history"
        deleteText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        deleteText.textColor = .red
        deleteText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(deleteText)
        NSLayoutConstraint.activate([
            deleteText.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            deleteText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
    }
    
    func deleteHistoryFunc() {
        let alert = UIAlertController(title: "Delete history in all calculators?", message: "This action is irreversible", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            if let navController = self?.navigationController as? NavigationController {
                navController.delHistoryPill()
            }
            self?.coreData.deleteAllHistory()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Info
    
    func developerInfo(in cell: UITableViewCell) {
        //text
        let createdText = UILabel()
        createdText.numberOfLines = 0
        createdText.textColor = .white
        createdText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(createdText)
        NSLayoutConstraint.activate([
            createdText.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            createdText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        let attributedString = NSMutableAttributedString()
        let regularText = NSAttributedString(string: "Created by:   ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        attributedString.append(regularText)
        let boldText = NSAttributedString(string: "Daniel Husiuk", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedString.append(boldText)
        createdText.attributedText = attributedString
        
        //git image
        let developerImage = UIImageView()
        developerImage.image = UIImage(named: "GitHubIcon_small.png")
        developerImage.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(developerImage)
        NSLayoutConstraint.activate([
            developerImage.widthAnchor.constraint(equalToConstant: 44),
            developerImage.heightAnchor.constraint(equalToConstant: 44),
            developerImage.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            developerImage.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
        ])
        
        //app image
        let appImage = UIImageView()
        if let selectedImageRow = tintModel.tints.first(where: { $0.id == selectedTintId }) {
            appImage.image = selectedImageRow.image
        }
        appImage.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(appImage)
        NSLayoutConstraint.activate([
            appImage.widthAnchor.constraint(equalToConstant: 44),
            appImage.heightAnchor.constraint(equalToConstant: 44),
            appImage.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            appImage.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor)
        ])
    }
    
    func devGitFunc() {
        let alert = UIAlertController(title: "Open developer GitHub?", message: "https://github.com/DanielHusiuk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            
            if let gitURL = URL(string: "https://github.com/DanielHusiuk") {
                UIApplication.shared.open(gitURL, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
