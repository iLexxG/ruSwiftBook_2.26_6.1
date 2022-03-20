//
//  WelcomeViewController.swift
//  ColorizedApp
//
//  Created by Alex Golyshkov on 18.03.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setBackgroundColor(_ color: UIColor)
}

class WelcomeViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.welcomeVCBackgroundColor = view.backgroundColor
        settingsVC.delegate = self
    }
}

// MARK: - SettingsViewControllerDelegate
extension WelcomeViewController: SettingsViewControllerDelegate {
    func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
