//
//  SceneDelegate.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 31.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let settingsVC = SettingsViewController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(updateThemeBasedOnSystem), name: Notification.Name("ThemeChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleThemeChange), name: Notification.Name("GrayTheme"), object: nil)
        updateThemeBasedOnSystem()
    }
    
    @objc func updateThemeBasedOnSystem() {
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
            settingsVC.isDarkTheme = true
            UserDefaults.standard.set(true, forKey: "isSystemDarkTheme")
            NotificationCenter.default.post(name: Notification.Name("DarkThemeNotification"), object: true)
        }
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
        updateThemeBasedOnSystem()
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
    
}

extension UIWindow {
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            
            let isSystemDarkMode = traitCollection.userInterfaceStyle == .dark
            UserDefaults.standard.set(isSystemDarkMode, forKey: "isSystemDarkTheme")
            NotificationCenter.default.post(name: Notification.Name("ThemeChanged"), object: nil)
        }
    }
}

