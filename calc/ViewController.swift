//
//  ViewController.swift
//  calc
//
//  Created by Ivan Ermak on 8/29/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var firstValueField: UITextField!
    @IBOutlet weak var secondValueField: UITextField!
    @IBOutlet weak var operationOneButton: RadioButton!
    @IBOutlet weak var operationTwoButton: RadioButton!
    @IBOutlet weak var operationThreeButton: RadioButton!
    @IBOutlet weak var operationFourButton: RadioButton!
    @IBOutlet weak var signCheckBox: CheckBox!
    @IBOutlet weak var floatCheckBox: CheckBox!
    @IBOutlet weak var resultField: UITextField!
    var ACCEPTABLE_CHARACTERS = "0123456789.-"
    var error: CatchableErrors = .normal
    let uncheckedImage = UIImage(named: "UnchosenRadioButton")! as UIImage
    var buttonSet: [RadioButton]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSet = [operationOneButton,
                     operationTwoButton,
                     operationThreeButton,
                     operationFourButton]
        self.firstValueField.delegate = self
        self.secondValueField.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func deselectAll(_ sender: RadioButton) {
        for button in buttonSet! {
            button.setImage(uncheckedImage, for: UIControl.State.normal)
            button.isChecked = false
        }
        sender.isChecked = false
     }
    @IBAction func calculate(_ sender: UIButton) {
        guard let valueOne = Float(firstValueField.text ?? "0") else {return}
        guard let valueTwo = Float(secondValueField.text ?? "0") else {return}
        calculation(valueOne, valueTwo, completion: {result in
            switch self.error {
            case .normal:
                if !self.floatCheckBox.isChecked {
                    let res = Float(result)
                    self.resultField.text = String(Int(res!))
                }
                else {
                    self.resultField.text = result
                }
                break
            case .operationError:
                let localizedString = NSLocalizedString("Error. U did not choose any operation.", comment: "")
                self.resultField.text = localizedString
                break
            case .arithmeticalError:
                let localizedString = NSLocalizedString("Error. I can't count such equation.", comment: "")
                self.resultField.text = localizedString
            }
            
        })
    }
    @IBAction func signedChange(_ sender: CheckBox) {
        guard let index = ACCEPTABLE_CHARACTERS.firstIndex(of: "-") else {
            ACCEPTABLE_CHARACTERS.append("-")
            return
        }
        ACCEPTABLE_CHARACTERS.remove(at: index)
    }
    @IBAction func floatChanged(_ sender: CheckBox) {
        guard let index = ACCEPTABLE_CHARACTERS.firstIndex(of: ".") else {
            ACCEPTABLE_CHARACTERS.append(".")
            return
        }
        ACCEPTABLE_CHARACTERS.remove(at: index)
    }
    func calculation(_ valueOne: Float,_ valueTwo: Float, completion: @escaping (String) -> Void) {
        completion(String(findOperation(valueOne, valueTwo)))
    }
    func findOperation(_ valueOne: Float,_ valueTwo: Float) -> Float {
        guard let operations = buttonSet else {return 0}
        switch true {
        case operations[0].isChecked:
            return((valueOne + valueTwo))
        case operations[1].isChecked:
            return(valueOne - valueTwo)
        case operations[2].isChecked:
            if valueTwo != 0 {
            return(valueOne/valueTwo)
            }
            else {error = .arithmeticalError
                return 0
            }
        case operations[3].isChecked:
            return(valueOne * valueTwo)
        default:
            error = .operationError
            return 0
        }
    }
}
extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
}
enum CatchableErrors {
    case normal
    case operationError
    case arithmeticalError
}
