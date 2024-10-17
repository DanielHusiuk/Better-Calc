//
//  SettingsViewController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 30.09.2024.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var SettingsTableViewOutlet: UITableView!
    
    private var tintModel = TintModel()
    private var selectedTintId: Int16 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferences()
    }
    
    
    //MARK: - Preferences
    
    func updatePreferences() {
        SettingsTableViewOutlet.delegate = self
        SettingsTableViewOutlet.dataSource = self
        
        SettingsTableViewOutlet.rowHeight = UITableView.automaticDimension
        SettingsTableViewOutlet.estimatedRowHeight = UITableView.automaticDimension
        
        if UserDefaults.standard.object(forKey: "HapticState") == nil {
            UserDefaults.standard.set(true, forKey: "HapticState")
        }
        
        if UserDefaults.standard.object(forKey: "MenuState") == nil {
            UserDefaults.standard.set(false, forKey: "MenuState")
        }
    }
    
    
    //MARK: - Navigation Bar
    
    var originalAppearance: UINavigationBarAppearance?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originalAppearance = navigationController?.navigationBar.standardAppearance
        
        let customFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: customFont, .foregroundColor: UIColor.white]
        appearance.backgroundEffect = blurEffect
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let originalAppearance = originalAppearance {
            navigationController?.navigationBar.standardAppearance = originalAppearance
        }
    }
    
    @IBAction func ResetSettingsButtonOutlet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Reset settings?", message: "This will reset all parameters to default", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .cancel, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Table View
    
    func numberOfSections(in SettingsTableViewOutlet: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 2
        case 4:
            return 1
        default:
            return 1
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let items = CGFloat(model.icons.count)
            let rows = ceil(items / 3.0)
            let height = rows * 110
            return height + 32
        case 1:
            return 100
        case 2, 3, 4:
            return 44
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = UIColor.darkGray
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsTableViewOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        switch indexPath.section {
        case 0:
            layoutCollection(in: cell)
        case 1:
            openWithLaunch(in: cell)
        case 2:
            switch indexPath.row {
            case 0:
                hapticButton(in: cell)
            case 1:
                resetCalc(in: cell)
            default:
                return cell
            }
        case 3:
            switch indexPath.row {
            case 0:
                resetMenu(in: cell)
            case 1:
                deleteHistory(in: cell)
            default:
                return cell
            }
        case 4:
            developerInfo(in: cell)
        default:
            return cell
        }
        return cell
    }
    
    
    //MARK: - Color Theme
    
    private var collectionView: UICollectionView?
    private var model = IconsModel()
    
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
        return model.icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? IconCell else {
            return UICollectionViewCell()
        }
        let buttonRow = model.icons[indexPath.row]
        cell.configure(with: buttonRow.text, image: buttonRow.image)
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let buttonRow = model.icons[sender.tag]
        buttonRow.action()
        
        selectedTintId = tintModel.tints[sender.tag].id // Збереження вибраного id
        print("\(buttonRow.text) Button Pressed")
        
        guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    
    //MARK: - Open with launch
    
    private let pickersModel = PickerModel()
    private let pickerOptions = PickerModel().pickers.map { $0.text }

    var selectedSegueIdentifier: String?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerOptions[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSegueIdentifier = pickersModel.pickers[row].segue
        print("Selected segue: \(String(describing: selectedSegueIdentifier))")
        //write in viewDidAppear:
        //if pickerModel.id == 0 {return} else { performSegue(withIdentifier: pickersModel.pickers[row].segue) }
        
    }
    
    func openWithLaunch(in cell: UITableViewCell) {
        let calcPicker = UIPickerView()
        calcPicker.dataSource = self
        calcPicker.delegate = self
        calcPicker.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(calcPicker)
        NSLayoutConstraint.activate([
            calcPicker.topAnchor.constraint(equalTo: cell.topAnchor),
            calcPicker.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            calcPicker.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            calcPicker.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
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
        let hapticSwitch = UISwitch()
        hapticSwitch.onTintColor = #colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1)
        hapticSwitch.isOn = UserDefaults.standard.bool(forKey: "ResetState")
        hapticSwitch.addTarget(self, action: #selector(hapticSwitchChanged(_:)), for: .valueChanged)
        cell.accessoryView = hapticSwitch
        
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
        let resetMenuButton = UIButton(type: .system)
        resetMenuButton.backgroundColor = .clear
        resetMenuButton.setTitleColor(#colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1), for: .normal)
        resetMenuButton.setTitle("Reset menu button positions", for: .normal)
        resetMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        resetMenuButton.translatesAutoresizingMaskIntoConstraints = false
        resetMenuButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        cell.contentView.addSubview(resetMenuButton)
        NSLayoutConstraint.activate([
            resetMenuButton.topAnchor.constraint(equalTo: cell.topAnchor),
            resetMenuButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            resetMenuButton.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            resetMenuButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
        ])
    }
    
    @objc func resetButtonPressed() {
        ///reset menu button positions logic
    }
    
    //delete
    func deleteHistory(in cell: UITableViewCell) {
        let deleteButton = UIButton(type: .system)
        deleteButton.backgroundColor = .clear
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.setTitle("Delete all history", for: .normal)
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(delButtonPressed), for: [.touchUpInside, .touchUpOutside])
        cell.contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: cell.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
        ])
    }
    
    @objc func delButtonTouch(_ sender: UIButton) {
        sender.backgroundColor = .gray
    }
    
    @objc func delButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = .clear
        let alert = UIAlertController(title: "Delete history in all calculators?", message: "This action is irreversible", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            
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
            createdText.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
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
        
        //button
        let developerButton = UIButton(type: .system)
        developerButton.backgroundColor = .clear
        developerButton.translatesAutoresizingMaskIntoConstraints = false
        developerButton.addTarget(self, action: #selector(devButtonPressed), for: .touchUpInside)
        cell.contentView.addSubview(developerButton)
        NSLayoutConstraint.activate([
            developerButton.topAnchor.constraint(equalTo: cell.topAnchor),
            developerButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            developerButton.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            developerButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
        ])
    }
    
    @objc func devButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Open developer GitHub?", message: "https://github.com/DanielHusiuk", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            
            if let gitURL = URL(string: "https://github.com/DanielHusiuk") {
                UIApplication.shared.open(gitURL, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
