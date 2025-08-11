//
//  ViewController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 31.07.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var ButtonsViewOutlet: UIView!
    
    var originalAppearance: UINavigationBarAppearance?
    private var collectionView: UICollectionView?
    let searchController = UISearchController(searchResultsController: nil)
    var model = ButtonsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollection()
        loadButtons()
        tipLabel()
        enablePopGesture()
        overrideUserInterfaceStyle = .dark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchController()
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
        searchController.isActive = false
    }
    
    
    //MARK: - Swipe Gesture
    
    func enablePopGesture() {
        guard let navigationController = self.navigationController,
              let gestureRecognizer = navigationController.interactivePopGestureRecognizer,
              let gestureView = gestureRecognizer.view else { return }
        
        gestureView.gestureRecognizers?.forEach { recognizer in
            if recognizer is UIScreenEdgePanGestureRecognizer {
                gestureView.removeGestureRecognizer(recognizer)
            }
        }
        
        let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        
        if let targets = gestureRecognizer.value(forKey: "_targets") as? [NSObject],
           let targetObj = targets.first,
           let target = targetObj.value(forKey: "target"),
           let action = Selector(("handleNavigationTransition:")) as Selector? {
            pan.addTarget(target, action: action)
            gestureView.addGestureRecognizer(pan)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = self.navigationController else { return false }
        return navigationController.viewControllers.count > 1
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
    
    //MARK: - Search Bar
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString( "search", comment: "")
        searchController.searchBar.searchTextField.leftView?.tintColor = .gray
        searchController.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
        searchController.searchBar.barStyle = .black
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.model.updateSearchController(searchBarText: searchController.searchBar.text)
        collectionView?.reloadData()
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
        let inSearchMode = self.model.inSearchMode(searchController)
        return inSearchMode ? self.model.filteredButtons.count : self.model.buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as? ButtonCell else {
            return UICollectionViewCell()
        }
        
        let inSearchMode = self.model.inSearchMode(searchController)
        let buttonRow = inSearchMode ? self.model.filteredButtons[indexPath.row] : self.model.buttons[indexPath.row]
        
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
        return UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
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
            let inSearchMode = self.model.inSearchMode(searchController)
            let buttonRow = inSearchMode ? self.model.filteredButtons[indexPath.row] : self.model.buttons[indexPath.row]
            let buttonSegue = buttonRow.segue
            let originalColor = sender.backgroundColor
            
            UIView.animate(withDuration: 0) {
                sender.backgroundColor = #colorLiteral(red: 0.1326085031, green: 0.1326085031, blue: 0.1326085031, alpha: 1)
            }
            UIView.animate(withDuration: 0.3) {
                sender.backgroundColor = originalColor
            }
            
            performSegue(withIdentifier: buttonSegue, sender: self)
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
    
    //MARK: - Tip Label
    
    func tipLabel() {
        let tipText = UILabel()
        
        tipText.text = NSLocalizedString("Tip_long_press_rearrange", comment: "")
        tipText.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tipText.textColor = #colorLiteral(red: 0.3789286613, green: 0.3789286017, blue: 0.3789286613, alpha: 1)
        tipText.textAlignment = .center
        tipText.numberOfLines = 3
        tipText.adjustsFontSizeToFitWidth = true
        tipText.minimumScaleFactor = 0.6
        tipText.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView?.layoutIfNeeded()
        let bottomY = collectionView?.contentSize.height
        let inSearchMode = self.model.inSearchMode(searchController)
        if inSearchMode {
            return
        } else {
            collectionView!.addSubview(tipText)
        }
        
        NSLayoutConstraint.activate([
            tipText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tipText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tipText.bottomAnchor.constraint(equalTo: collectionView!.bottomAnchor, constant: bottomY! + 85)
        ])
        
    }
}
