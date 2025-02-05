//
//  ViewController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 31.07.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var ButtonsViewOutlet: UIView!
    
    var originalAppearance: UINavigationBarAppearance?
    private var collectionView: UICollectionView?
    
    private var model = ButtonsModel()
    var pickerModel = PickerModel()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollection()
        loadButtons()
        overrideUserInterfaceStyle = .dark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !appDelegate.hasPerformedSegue {
            loadPickerSegue()
            appDelegate.hasPerformedSegue = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model = ButtonsModel()
        collectionView?.reloadData()
        loadNavBar()
        loadButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBarAppear()
    }
    
    
    //MARK: - Picker Segue
    
    func loadPickerSegue() {
        let savedSegue = UserDefaults.standard.string(forKey: "SelectedPickerString")
        let unwrappedSavedSegue = savedSegue.map { String(describing: $0) } ?? ""
        
        if unwrappedSavedSegue.isEmpty { return }
        performSegue(withIdentifier: unwrappedSavedSegue, sender: self)
    }
    
    
    //MARK: - Navigation Bar and Title
    
    func loadNavBar() {
        originalAppearance = navigationController?.navigationBar.standardAppearance
        let customFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: customFont, .foregroundColor: UIColor.white]
        appearance.backgroundEffect = blurEffect
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.setNeedsLayout()
    }
    
    func navBarAppear() {
        if let originalAppearance = originalAppearance {
            navigationController?.navigationBar.standardAppearance = originalAppearance
            navigationController?.navigationBar.setNeedsLayout()
        }
    }
    
    
    //MARK: - Collection View
    
    func loadButtons() {
        let loadedPositions = CoreDataManager.shared.loadCellPosition()
        if !loadedPositions.isEmpty {
            model.buttons = loadedPositions.compactMap { id in
                model.buttons.first { $0.id == id }
            }
        }
    }
    
    func resetMenuFunc() {
        CoreDataManager.shared.resetCellPosition()
        model = ButtonsModel()
        collectionView?.reloadData()
    }
    
    func layoutCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(ButtonCell.self, forCellWithReuseIdentifier: "buttonCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.allowsSelection = true
        collectionView?.indicatorStyle = .white
        collectionView?.backgroundColor = .clear
        collectionView?.contentMode = .scaleAspectFit
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        ButtonsViewOutlet.addSubview(collectionView!)
        
        NSLayoutConstraint.activate([
            collectionView!.topAnchor.constraint(equalTo: ButtonsViewOutlet.topAnchor),
            collectionView!.leadingAnchor.constraint(equalTo: ButtonsViewOutlet.leadingAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: ButtonsViewOutlet.trailingAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: ButtonsViewOutlet.bottomAnchor)
        ])
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView?.addGestureRecognizer(gesture)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as? ButtonCell else {
            return UICollectionViewCell()
        }
        
        let buttonRow = model.buttons[indexPath.row]
        cell.configure(with: buttonRow.text, image: buttonRow.image)
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 20
        let totalSpacing = (2 * spacingBetweenCells) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing: CGFloat = 20
        return UIEdgeInsets(top: 30, left: spacing, bottom: 10, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = model.buttons.remove(at: sourceIndexPath.row)
        model.buttons.insert(item, at: destinationIndexPath.row)
        
        var positions: [IndexPath: Int] = [:]
        for (index, button) in model.buttons.enumerated() {
            positions[IndexPath(row: index, section: 0)] = Int(button.id)
        }
        CoreDataManager.shared.saveCellPosition(positions: positions)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard let collectionView = collectionView else { return }
        let buttonPosition = sender.convert(sender.bounds.origin, to: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: buttonPosition) {
            let buttonRow = model.buttons[indexPath.row]
            let buttonSegue = buttonRow.segue
            let originalColor = sender.backgroundColor
            
            UIView.animate(withDuration: 0) {
                sender.backgroundColor = #colorLiteral(red: 0.1326085031, green: 0.1326085031, blue: 0.1326085031, alpha: 1)
            }
            UIView.animate(withDuration: 0.3) {
                sender.backgroundColor = originalColor
            }
            
            performSegue(withIdentifier: buttonSegue, sender: self)
            print("\(buttonRow.text) Button Pressed")
            
            guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
    
    //MARK: - Long Press Gesture
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else {
            return
        }
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
}
