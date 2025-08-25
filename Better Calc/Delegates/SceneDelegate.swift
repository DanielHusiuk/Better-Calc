//
//  SceneDelegate.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 31.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var pendingURL: Set<UIOpenURLContext>?
    
    let coreData = CoreDataManager.shared
    let settingsVC = SettingsViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(updateThemeBasedOnSystem), name: Notification.Name("ThemeChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleThemeChange), name: Notification.Name("GrayTheme"), object: nil)
        updateThemeBasedOnSystem()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        NotificationCenter.default.removeObserver(self)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        coreData.deleteCalculatorObjectDate(with: Date.now, value: UserDefaults.standard.integer(forKey: "autoDeleteValue"))
        coreData.deleteConverterObjectDate(with: Date.now, value: UserDefaults.standard.integer(forKey: "autoDeleteValue"))
        updateThemeBasedOnSystem()
        
        if let contexts = pendingURL {
            loadWidgetURLSegue(contexts)
            pendingURL = nil
            return
        }
        loadURLSegue()
        
        if !appDelegate.hasPerformedSegue {
            loadPickerSegue()
            appDelegate.hasPerformedSegue = true
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        updateThemeBasedOnSystem()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
    //MARK: - Picker Segue
    
    func loadPickerSegue() {
        let urlSegue = UserDefaults.standard.string(forKey: "SelectedURLString")
        let unwrappedURLSegue = urlSegue.map { String(describing: $0) } ?? ""
        guard let navigation = window?.rootViewController as? UINavigationController else { return }
        let mainVC = navigation.viewControllers.first
        
        let savedPickerSegue = UserDefaults.standard.string(forKey: "SelectedPickerString")
        let unwrappedPickerSegue = savedPickerSegue.map { String(describing: $0) } ?? ""
        
        if unwrappedURLSegue.isEmpty || unwrappedURLSegue == "None" || unwrappedURLSegue == "Menu" {
            if unwrappedPickerSegue.isEmpty || unwrappedPickerSegue == "None" { return }
            mainVC?.performSegue(withIdentifier: unwrappedPickerSegue, sender: self)
        }
    }
    
    
    //MARK: - Control Widget Segue
    
    func loadURLSegue() {
        let urlSegue = UserDefaults.standard.string(forKey: "SelectedURLString")
        let unwrappedURLSegue = urlSegue.map { String(describing: $0) } ?? ""
        guard let navigation = window?.rootViewController as? UINavigationController else { return }
        let mainVC = navigation.viewControllers.first
        
        if unwrappedURLSegue.isEmpty || unwrappedURLSegue == "None" { return }
        
        if unwrappedURLSegue == "Menu" {
            mainVC?.presentedViewController?.dismiss(animated: false, completion: nil)
            mainVC?.navigationController?.popToRootViewController(animated: true)
            UserDefaults.standard.set("None", forKey: "SelectedURLString")
            return
        }
        
        if navigation.viewControllers.count > 1 {
            mainVC?.presentedViewController?.dismiss(animated: false, completion: nil)
            mainVC?.navigationController?.popToRootViewController(animated: false)
        }
        
        mainVC?.performSegue(withIdentifier: unwrappedURLSegue, sender: self)
        UserDefaults.standard.set("None", forKey: "SelectedURLString")
    }
    
    
    //MARK: - Home Widget Segue
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        pendingURL = URLContexts
    }
    
    func loadWidgetURLSegue(_ contexts: Set<UIOpenURLContext>) {
        guard let url = contexts.first?.url else { return }
        
        if url.scheme == "bettercalc" {
            switch url.host {
            case "basic":
                UserDefaults.standard.set("BasicSegue", forKey: "SelectedURLString")
                loadURLSegue()
            case "length":
                UserDefaults.standard.set("LengthSegue", forKey: "SelectedURLString")
                loadURLSegue()
            case "area":
                UserDefaults.standard.set("AreaSegue", forKey: "SelectedURLString")
                loadURLSegue()
            case "volume":
                UserDefaults.standard.set("VolumeSegue", forKey: "SelectedURLString")
                loadURLSegue()
            case "temperature":
                UserDefaults.standard.set("TemperatureSegue", forKey: "SelectedURLString")
                loadURLSegue()
            case "time":
                UserDefaults.standard.set("TimeSegue", forKey: "SelectedURLString")
                loadURLSegue()
            case "speed":
                UserDefaults.standard.set("SpeedSegue", forKey: "SelectedURLString")
                loadURLSegue()
            case "mass":
                UserDefaults.standard.set("MassSegue", forKey: "SelectedURLString")
                loadURLSegue()
            case "data":
                UserDefaults.standard.set("DataSegue", forKey: "SelectedURLString")
                loadURLSegue()
            default:
                return
            }
        }
    }
    
    
    //MARK: - Theme Change
    
    @objc func updateThemeBasedOnSystem() {
        let isGrayTheme = UserDefaults.standard.bool(forKey: "isGrayTheme")
        if isGrayTheme {
            return
        }
        
        window?.overrideUserInterfaceStyle = .unspecified
        if let window = window {
            let isSystemDarkMode = window.traitCollection.userInterfaceStyle == .dark
            UserDefaults.standard.set(isSystemDarkMode, forKey: "isSystemDarkTheme")
            
            DispatchQueue.main.async {
                if self.settingsVC.isDarkTheme != isSystemDarkMode {
                    self.settingsVC.isDarkTheme = isSystemDarkMode
                    NotificationCenter.default.post(name: Notification.Name("DarkThemeNotification"), object: isSystemDarkMode)
                }
            }
        }
    }
    
    @objc func handleThemeChange() {
        if window?.overrideUserInterfaceStyle != .dark {
            window?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(true, forKey: "isSystemDarkTheme")
            NotificationCenter.default.post(name: Notification.Name("DarkThemeNotification"), object: true)
        }
    }
}

extension UIWindow {
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let isGrayTheme = UserDefaults.standard.bool(forKey: "isGrayTheme")
        if isGrayTheme {
            return
        }
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            let isSystemDarkMode = traitCollection.userInterfaceStyle == .dark
            UserDefaults.standard.set(isSystemDarkMode, forKey: "isSystemDarkTheme")
            NotificationCenter.default.post(name: Notification.Name("ThemeChanged"), object: nil)
        }
        
    }
}
