//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Alex Golyshkov on 04.03.2022.
//
import Foundation
import UIKit

class SettingsViewController: UIViewController {
    //MARK: - IB Outlets
    @IBOutlet var resultColorView: UIView!
    
    @IBOutlet var colorValueSliders: [UISlider]!
    
    @IBOutlet var colorValueLabels: [UILabel]!
    
    @IBOutlet var colorValueTextFields: [UITextField]!
    
    //MARK: - Public properties
    var welcomeVCBackgroundColor: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        resultColorView.layer.cornerRadius = 10
        
        colorValueSliders[0].minimumTrackTintColor = UIColor.red
        colorValueSliders[1].minimumTrackTintColor = UIColor.green
        
        updateSlider(withTag: 0, byValue: Float(CIColor(color: welcomeVCBackgroundColor).red))
        updateSlider(withTag: 1, byValue: Float(CIColor(color: welcomeVCBackgroundColor).green))
        updateSlider(withTag: 2, byValue: Float(CIColor(color: welcomeVCBackgroundColor).blue))
        
        colorValueTextFields.forEach { textField in
            textField.inputAccessoryView = addToolBarToNumKeyboard()
        }
    }
    
    //MARK: - IB Actions
    @IBAction func colorSlidersChangeValue(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            colorValueLabels[0].text = String(format: "%.2f", colorValueSliders[0].value)
            colorValueTextFields[0].text = String(format: "%.2f", colorValueSliders[0].value)
        case 1:
            colorValueLabels[1].text = String(format: "%.2f", colorValueSliders[1].value)
            colorValueTextFields[1].text = String(format: "%.2f", colorValueSliders[1].value)
        default:
            colorValueLabels[2].text = String(format: "%.2f", colorValueSliders[2].value)
            colorValueTextFields[2].text = String(format: "%.2f", colorValueSliders[2].value)
        }
        
        setColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate.setBackgroundColor(resultColorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
}

//MARK: - Private functions
extension SettingsViewController {
    private func updateSlider(withTag tag: Int, byValue value: Float) {
        colorValueSliders[tag].value = value
        colorSlidersChangeValue(colorValueSliders[tag])
    }
    
    private func setColor() {
        resultColorView.backgroundColor = UIColor(
            red: CGFloat(colorValueSliders[0].value),
            green: CGFloat(colorValueSliders[1].value),
            blue: CGFloat(colorValueSliders[2].value),
            alpha: 1
        )
    }
}

// MARK: - Keyboard
extension SettingsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func addToolBarToNumKeyboard() -> UIToolbar{
        let toolBar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let buttonTitle = "Done"
        let doneButton = UIBarButtonItem(
            title: buttonTitle,
            style: .done,
            target: self,
            action: #selector(onClickDoneButton)
        )
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func onClickDoneButton() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        
        guard let textFieldValue = textField.text else { return }
        
        if textFieldValue.isEmpty {
            updateSlider(withTag: tag, byValue: 0)
        } else if !(0...1).contains(Float(textFieldValue) ?? 2) {
            showAlert(tag: tag)
        } else {
            guard let enteredValue = Float(textFieldValue) else { return }
            updateSlider(withTag: tag, byValue: enteredValue)
        }
    }
}

// MARK: - Alert Controller
extension SettingsViewController {
    func showAlert(tag: Int) {
        let alertMessage = UIAlertController(
            title: "Error",
            message: "Please, enter value in range 0.0 to 1.0",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.colorValueTextFields[tag].text = ""
            self.colorValueTextFields[tag].becomeFirstResponder()
        }
        
        alertMessage.addAction(okAction)
        present(alertMessage, animated: true)
    }
}
