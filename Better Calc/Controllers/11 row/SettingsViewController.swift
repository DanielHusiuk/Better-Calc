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
    case preferences2
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
    var selectedPickerText: String = NSLocalizedString("settings_none", comment: "")
    var selectedAutoDeleteText: String = NSLocalizedString("never", comment: "")
    
    var pickerView: UIPickerView?
    let pickersModel = PickerModel()
    private var expandedSections: Set<Int> = []
    
    private var model = ButtonsModel()
    private var mainView = ViewController()
    
    private var tintModel = TintModel()
    private var selectedTintId: Int64 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferences()
        loadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RightNavBarButton.image = UIImage(named: "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90.svg")
        loadSavePicker()
        loadNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        origAppear()
    }
    
    //MARK: - Update
    
    func updatePreferences() {
        let savedIndex = UserDefaults.standard.integer(forKey: "selectedTintID")
        let indexToUse = savedIndex
        selectedIndexPath = IndexPath(row: indexToUse, section: 0)
        selectedTintId = Int64(UserDefaults.standard.integer(forKey: "selectedTintID"))
        
        if UserDefaults.standard.object(forKey: "HapticState") == nil {
            UserDefaults.standard.set(true, forKey: "HapticState")
        }
        if UserDefaults.standard.object(forKey: "KeepState") == nil {
            UserDefaults.standard.set(true, forKey: "KeepState")
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
        let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")
        let alert = UIAlertController(title: NSLocalizedString("settings_reset_settings", comment: ""), message: NSLocalizedString("settings_this_will_reset_all_parameters_to_default", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        cancelAction.setValue(selectedTintColor, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: NSLocalizedString("settings_reset", comment: ""), style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            self?.resetUserSettings()
        }))
        present(alert, animated: true, completion: nil)
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    func resetUserSettings() {
        if UserDefaults.standard.color(forKey: "selectedTintColor") == tintModel.tints[1].color,
           UserDefaults.standard.integer(forKey: "selectedTintID") == 1,
           UserDefaults.standard.integer(forKey: "SelectedPickerRow") == 0,
           UserDefaults.standard.object(forKey: "SelectedPickerString") == nil,
           UserDefaults.standard.bool(forKey: "HapticState") == true,
           UserDefaults.standard.bool(forKey: "KeepState") == true {
            (self.navigationController as? NavigationController)?.resetError()
        } else {
            let secondTintColor = tintModel.tints[1].color
            UserDefaults.standard.setColor(secondTintColor, forKey: "selectedTintColor")
            UserDefaults.standard.set(1, forKey: "selectedTintID")
            UserDefaults.standard.removeObject(forKey: "SelectedPickerRow")
            UserDefaults.standard.removeObject(forKey: "SelectedPickerString")
            UserDefaults.standard.removeObject(forKey: "HapticState")
            UserDefaults.standard.removeObject(forKey: "KeepState")
            loadSavePicker()
            loadNavBar()
            setIcon(.icon1)
            mainView.resetMenuFunc()
            
            (self.navigationController as? NavigationController)?.didSelectTintColor()
            (self.navigationController as? NavigationController)?.resButtonPill()
            
            collectionView?.reloadData()
            UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
            updatePreferences()
            
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
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
            selectedPickerText = NSLocalizedString("settings_none", comment: "")
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "KeepCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AutoDeleteCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChangeLangCell")
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
            return NSLocalizedString("settings_color_theme", comment: "")
        case 1:
            return NSLocalizedString("settings_open_after_launch", comment: "")
        case 2:
            return NSLocalizedString("settings_preferences", comment: "")
        case 4:
            return NSLocalizedString("settings_data", comment: "")
        case 5:
            return NSLocalizedString("settings_info", comment: "")
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 2:
            return " "
        case 5:
            return "© Better Calc  v\(String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""))"
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
        case 2:
            return 2
        case 3:
            return 2
        case 4:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 360
        case 1:
            switch indexPath.row {
            case 1:
                return 145
            default:
                return 44
            }
        case 2, 3, 4, 5:
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
                let keepCell = tableView.dequeueReusableCell(withIdentifier: "KeepCell", for: indexPath)
                keepData(in: keepCell)
                return keepCell
            }
        case .preferences2:
            if indexPath.row == 0 {
                let autoDeleteCell = tableView.dequeueReusableCell(withIdentifier: "AutoDeleteCell", for: indexPath)
                autoDelete(in:  autoDeleteCell)
                return  autoDeleteCell
            } else {
                let changeLangCell = tableView.dequeueReusableCell(withIdentifier: "ChangeLangCell", for: indexPath)
                changeLanguage(in: changeLangCell)
                return changeLangCell
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
                autoDeleteFunc()
            case 1:
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            default:
                return
            }
        case 4:
            switch indexPath.row {
            case 0:
                resetButtonFunc()
            case 1:
                deleteHistoryFunc()
            default:
                return
            }
        case 5:
            devGitFunc()
        default:
            return
        }
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
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
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = UIColor.darkGray
        (view as? UITableViewHeaderFooterView)?.textLabel?.textAlignment = .center
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: headerView.textLabel?.font.pointSize ?? 17)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 10
        default:
            return 35
        }
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
        UserDefaults.standard.set(sender.tag, forKey: "selectedTintID")
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
        collectionView?.reloadData()
        
        selectedTintId = Int64(tintModel.tints[sender.tag].id)
        if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
            UserDefaults.standard.setColor(selectedTintColor, forKey: "selectedTintColor")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            (self.navigationController as? NavigationController)?.didSelectTintColor()
        }
        
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
    
    //MARK: - Open With Launch
    
    func pickerHeader(in cell: UITableViewCell) {
         let CalcTextLabel = UILabel()
         CalcTextLabel.text = NSLocalizedString("settings_o_w_l_calculator", comment: "")
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
         if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
             choosedCalcTextLabel.textColor = selectedTintColor
         }
         choosedCalcTextLabel.translatesAutoresizingMaskIntoConstraints = false
         cell.contentView.addSubview(choosedCalcTextLabel)
         
         NSLayoutConstraint.activate([
             choosedCalcTextLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
             choosedCalcTextLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -40)
         ])
         
         let choosedCalcIcon = UIImageView()
        choosedCalcIcon.image = UIImage(systemName: "chevron.up.chevron.down")
         choosedCalcIcon.image?.withRenderingMode(.alwaysOriginal)
         if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
             choosedCalcIcon.tintColor = selectedTintColor
         }
         choosedCalcIcon.translatesAutoresizingMaskIntoConstraints = false
         cell.contentView.addSubview(choosedCalcIcon)
         
         NSLayoutConstraint.activate([
             choosedCalcIcon.widthAnchor.constraint(equalToConstant: 16),
             choosedCalcIcon.heightAnchor.constraint(equalToConstant: 22),
             choosedCalcIcon.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
             choosedCalcIcon.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18)
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
        if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
            hapticSwitch.onTintColor = selectedTintColor
        }
        hapticSwitch.isOn = UserDefaults.standard.bool(forKey: "HapticState")
        hapticSwitch.addTarget(self, action: #selector(hapticSwitchChanged(_:)), for: .valueChanged)
        cell.accessoryView = hapticSwitch
        
        let hapticText = UILabel()
        hapticText.text = NSLocalizedString("settings_p_haptic_feedback", comment: "")
        hapticText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        hapticText.textColor = .white
        hapticText.adjustsFontSizeToFitWidth = true
        hapticText.minimumScaleFactor = 0.6
        hapticText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(hapticText)
        NSLayoutConstraint.activate([
            hapticText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            hapticText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            hapticText.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -40)
        ])
    }
    
    @objc func hapticSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "HapticState")
        } else {
            UserDefaults.standard.set(false, forKey: "HapticState")
        }
    }
    
    //keep
    func keepData(in cell: UITableViewCell) {
        let keepSwitch = UISwitch()
        if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
            keepSwitch.onTintColor = selectedTintColor
        }
        keepSwitch.isOn = UserDefaults.standard.bool(forKey: "KeepState")
        keepSwitch.addTarget(self, action: #selector(keepSwitchChanged(_:)), for: .valueChanged)
        cell.accessoryView = keepSwitch
        
        let keepDataText = UILabel()
        keepDataText.text = NSLocalizedString("settings_p_keep_data_after_close", comment: "")
        keepDataText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        keepDataText.textColor = .white
        keepDataText.adjustsFontSizeToFitWidth = true
        keepDataText.minimumScaleFactor = 0.6
        keepDataText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(keepDataText)
        NSLayoutConstraint.activate([
            keepDataText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            keepDataText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            keepDataText.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -40)
        ])
    }
    
    @objc func keepSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "KeepState")
        } else {
            UserDefaults.standard.set(false, forKey: "KeepState")
            coreData.resetBasicState()
            coreData.resetConverterState(with: 1)
        }
    }
    
    
    //MARK: - Preferences 2
    
    //autodelete
    func autoDelete(in cell: UITableViewCell) {
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let changeLangText = UILabel()
        changeLangText.text = NSLocalizedString("settings_p_auto_delete", comment: "")
        changeLangText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        changeLangText.textColor = .white
        changeLangText.adjustsFontSizeToFitWidth = true
        changeLangText.minimumScaleFactor = 0.6
        changeLangText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(changeLangText)
        NSLayoutConstraint.activate([
            changeLangText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            changeLangText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            changeLangText.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -140)
        ])
        
        let settingsTextLabel = UILabel()
        settingsTextLabel.text = selectedAutoDeleteText
        settingsTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
            settingsTextLabel.textColor = selectedTintColor
        }
        settingsTextLabel.adjustsFontSizeToFitWidth = true
        settingsTextLabel.minimumScaleFactor = 0.6
        settingsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(settingsTextLabel)
        
        NSLayoutConstraint.activate([
            settingsTextLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            settingsTextLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -40)
        ])
        
        let chevronIcon = UIImageView()
        chevronIcon.image = UIImage(systemName: "chevron.right")
        chevronIcon.image?.withRenderingMode(.alwaysOriginal)
        if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
            chevronIcon.tintColor = selectedTintColor
        }
        chevronIcon.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(chevronIcon)
        
        NSLayoutConstraint.activate([
            chevronIcon.widthAnchor.constraint(equalToConstant: 14),
            chevronIcon.heightAnchor.constraint(equalToConstant: 20),
            chevronIcon.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            chevronIcon.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18)
        ])
    }
    
    func autoDeleteFunc() {
        let indexPath = IndexPath(row: 0, section: 3)
        let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")
        let alert = UIAlertController(title: "\(NSLocalizedString("settings_p_auto_delete", comment: "")):", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        cancelAction.setValue(selectedTintColor, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("older_than_1_week", comment: ""), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            self!.selectedAutoDeleteText = NSLocalizedString("auto_delete_1_week", comment: "")
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self!.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("older_than_1_month", comment: ""), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            self!.selectedAutoDeleteText = NSLocalizedString("auto_delete_1_month", comment: "")
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self!.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("older_than_3_months", comment: ""), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            self!.selectedAutoDeleteText = NSLocalizedString("auto_delete_3_months", comment: "")
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self!.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("never", comment: ""), style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            self!.selectedAutoDeleteText = NSLocalizedString("never", comment: "")
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self!.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //language
    func changeLanguage(in cell: UITableViewCell) {
        let changeLangText = UILabel()
        changeLangText.text = NSLocalizedString("settings_p_change_language", comment: "")
        changeLangText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        changeLangText.textColor = .white
        changeLangText.adjustsFontSizeToFitWidth = true
        changeLangText.minimumScaleFactor = 0.6
        changeLangText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(changeLangText)
        NSLayoutConstraint.activate([
            changeLangText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            changeLangText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            changeLangText.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -100)
        ])
        
        let settingsTextLabel = UILabel()
        settingsTextLabel.text = NSLocalizedString("button_settings", comment: "")
        settingsTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
            settingsTextLabel.textColor = selectedTintColor
        }
        settingsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(settingsTextLabel)
        
        NSLayoutConstraint.activate([
            settingsTextLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            settingsTextLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -40)
        ])
        
        let chevronIcon = UIImageView()
        chevronIcon.image = UIImage(systemName: "chevron.right")
        chevronIcon.image?.withRenderingMode(.alwaysOriginal)
        if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
            chevronIcon.tintColor = selectedTintColor
        }
        chevronIcon.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(chevronIcon)
        
        NSLayoutConstraint.activate([
            chevronIcon.widthAnchor.constraint(equalToConstant: 14),
            chevronIcon.heightAnchor.constraint(equalToConstant: 20),
            chevronIcon.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            chevronIcon.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18)
        ])
    }
    
    
    //MARK: - Data
    
    var coreData = CoreDataManager.shared
    
    //reset
    func resetMenu(in cell: UITableViewCell) {
        let resetText = UILabel()
        resetText.text = NSLocalizedString("settings_d_reset_menu_buttons_positions", comment: "")
        resetText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        resetText.translatesAutoresizingMaskIntoConstraints = false
        resetText.textAlignment = .center
        resetText.adjustsFontSizeToFitWidth = true
        resetText.minimumScaleFactor = 0.6
        if let selectedTintColor = tintModel.tints.first(where: { $0.id == selectedTintId })?.color {
            resetText.textColor = selectedTintColor
        }
        cell.contentView.addSubview(resetText)
        NSLayoutConstraint.activate([
            resetText.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            resetText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            resetText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            resetText.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18)
        ])
    }
    
    func resetButtonFunc() {
        let savedPositions = CoreDataManager.shared.loadCellPosition()
        let defaultPositions = model.buttons.map { Int($0.id) }
        
        if savedPositions == [] || savedPositions == defaultPositions {
            (self.navigationController as? NavigationController)?.positionsError()
        } else if savedPositions != defaultPositions {
            mainView.resetMenuFunc()
            (self.navigationController as? NavigationController)?.resButtonPill()
        }
    }
    
    //delete
    func deleteHistory(in cell: UITableViewCell) {
        let deleteText = UILabel()
        deleteText.text = NSLocalizedString("settings_d_delete_all_history", comment: "")
        deleteText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        deleteText.textColor = .systemRed
        deleteText.textAlignment = .center
        deleteText.adjustsFontSizeToFitWidth = true
        deleteText.minimumScaleFactor = 0.6
        deleteText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(deleteText)
        NSLayoutConstraint.activate([
            deleteText.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            deleteText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            deleteText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            deleteText.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18)
        ])
    }
    
    func deleteHistoryFunc() {
        let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")
        let alert = UIAlertController(title: "\(NSLocalizedString("settings_delete_history_in_all_calculators", comment: ""))\n\(NSLocalizedString("this_action_is_irreversible", comment: ""))", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        cancelAction.setValue(selectedTintColor, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            self?.deleteHistoryFetch(entityName: "CalculatorHistoryItem", context: context)
            self?.deleteHistoryFetch(entityName: "ConverterHistoryItem", context: context)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteHistoryFetch(entityName: String, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                (self.navigationController as? NavigationController)?.historyError()
                coreData.resetBasicState()
                coreData.resetConverterState(with: 1)
            } else {
                (self.navigationController as? NavigationController)?.delHistoryPill()
                coreData.deleteAllCalculatorHistory()
                coreData.deleteAllConverterHistory()
                
                coreData.resetBasicState()
                coreData.resetConverterState(with: 1)
            }
        } catch {
            print("deleteHistoryFetch: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: - Info
    
    func developerInfo(in cell: UITableViewCell) {
        //text
        let createdText = UILabel()
        createdText.numberOfLines = 1
        createdText.textColor = .white
        createdText.textAlignment = .center
        createdText.adjustsFontSizeToFitWidth = true
        createdText.minimumScaleFactor = 0.6
        createdText.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(createdText)
        NSLayoutConstraint.activate([
            createdText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            createdText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 50),
            createdText.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -50)
        ])
        
        let attributedString = NSMutableAttributedString()
        let regularText = NSAttributedString(string: NSLocalizedString("settings_created_by", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
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
        let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")
        let alert = UIAlertController(title: NSLocalizedString("open_developer_github", comment: ""), message: "https://github.com/DanielHusiuk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            
            if let gitURL = URL(string: "https://github.com/DanielHusiuk") {
                UIApplication.shared.open(gitURL, options: [:], completionHandler: nil)
            }
        })
        confirmAction.setValue(selectedTintColor, forKey: "titleTextColor")
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
}


//MARK: - Extensions

extension UserDefaults {
    func setColor(_ color: UIColor, forKey key: String) {
        let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        set(colorData, forKey: key)
    }
    
    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key),
              let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) else {
            return nil
        }
        return color
    }
}
