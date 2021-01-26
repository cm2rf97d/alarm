//
//  LabelViewController.swift
//  Alarm
//
//  Created by 陳郁勳 on 2021/1/19.
//

import UIKit

protocol LabelValueReturn
{
    func labelValueReturn(data : String)
}
class LabelViewController: UIViewController
{
    var delegate : LabelValueReturn?
    let labelTextField = UITextField()
    let fullSize = UIScreen.main.bounds.size

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Navigation title setting
        self.title = "標籤"
        self.view.backgroundColor = UIColor( red: CGFloat(25.2/255), green: CGFloat(25.2/255), blue: CGFloat(25.2/255), alpha: 1)
        self.navigationController?.navigationBar.barTintColor = AddAlarmViewController().backgroundColor
        //Navigation Title Text color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.orange

        labelTextField.translatesAutoresizingMaskIntoConstraints = false
        labelTextField.clearButtonMode = .whileEditing
        labelTextField.keyboardType = .emailAddress
        labelTextField.returnKeyType = .done
        labelTextField.backgroundColor = .white
        labelTextField.becomeFirstResponder()
        view.addSubview(labelTextField)
        
        autoLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        delegate?.labelValueReturn(data: (labelTextField.text!.isEmpty ? "鬧鐘" : labelTextField.text) ?? "Book能" )
    }
    
    func autoLayout() -> Void
    {
        var constrains = [NSLayoutConstraint]()
        
        constrains.append(labelTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constrains.append(labelTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        constrains.append(labelTextField.widthAnchor.constraint(equalToConstant: fullSize.width))
        constrains.append(labelTextField.heightAnchor.constraint(equalToConstant: 50))
        NSLayoutConstraint.activate(constrains)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
