//
//  AddAlarmViewController.swift
//  Alarm
//
//  Created by 陳郁勳 on 2021/1/13.
//

import UIKit

protocol testDelegate
{
    func addNewAlarmMember(data: alarmInfo)
    
    func returnEditingData(data: alarmInfo, indexPathRow: Int)
}
class AddAlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, returnRepeatDelegate
{    
    var addStructure : alarmInfo?

    var delegate : testDelegate?
    let timeLabel = UILabel()
    let cancelButton = UIButton()
    let addCellButton = UIButton()
    let timeDatePicker = UIDatePicker()
    let anotherSettingTableView = UITableView()
    let fullSize = UIScreen.main.bounds.size
    let backgroundColor = UIColor(red: CGFloat(30.2/255), green: CGFloat(30.2/255), blue: CGFloat(30.2/255), alpha: 1)
    let tableViewtitle : [String] = ["重複","標籤","提示聲","稍後提醒"]

    var nowIsEditing : Bool = false
    var indexPathRowTemp : Int = 0
    {
        didSet
        {
            nowIsEditing = true
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        changeOrEdit()
        // Navigation title setting
        self.title = "加入鬧鐘"
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.view.backgroundColor = UIColor( red: CGFloat(15.2/255), green: CGFloat(15.2/255), blue: CGFloat(15.2/255), alpha: 1)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        
        //Cancelbutton 基本設定
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.systemOrange, for: .normal)
        cancelButton.isEnabled = true
        cancelButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        //AddCellButton 基本設定
        addCellButton.translatesAutoresizingMaskIntoConstraints = false
        addCellButton.setTitle("儲存", for: .normal)
        addCellButton.setTitleColor(UIColor.systemOrange, for: .normal)
        addCellButton.isEnabled = true
        addCellButton.addTarget(self, action: #selector(addCell), for: .touchUpInside)
        let rightButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addCell))
        rightButton.tintColor = .orange
        self.navigationItem.rightBarButtonItem = rightButton
        
        //timeLabel 基本設定
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "時間"
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 20)
        timeLabel.textAlignment = .left
        timeLabel.backgroundColor = .clear
        self.view.addSubview(timeLabel)
        
        timeDatePicker.translatesAutoresizingMaskIntoConstraints = false
        timeDatePicker.datePickerMode = .time
        timeDatePicker.preferredDatePickerStyle = .wheels
        timeDatePicker.setValue(UIColor.orange, forKeyPath: "textColor")
        timeDatePicker.locale = Locale(identifier: "en_GB")
        timeDatePicker.minuteInterval = 1
        
        // MARK: Date
        timeDatePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        self.view.addSubview(timeDatePicker)
        
        //anotherSettingTableView
        anotherSettingTableView.translatesAutoresizingMaskIntoConstraints = false
        anotherSettingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        anotherSettingTableView.delegate = self
        anotherSettingTableView.dataSource = self
        anotherSettingTableView.separatorStyle = .singleLine
        anotherSettingTableView.allowsSelection = true
        anotherSettingTableView.allowsMultipleSelection = false
        anotherSettingTableView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(anotherSettingTableView)
        
        // AutoLayout
        autoLayout()
    }
    
    func changeOrEdit()
    {
        if addStructure == nil
        {
            addStructure = alarmInfo(
                time: Date(),
                label: "鬧鐘",
                isDone: [])
        }
        else
        {
            timeDatePicker.date = addStructure!.time
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        anotherSettingTableView.reloadData()
    }
    @objc func returnDateValue()
    {
        
    }
    
    @objc func previousPage() -> Void
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addCell()
    {
        addStructure?.time = timeDatePicker.date
        
        if let addStructure = addStructure
        {
            if nowIsEditing == true
            {
                delegate?.returnEditingData(data: addStructure, indexPathRow: indexPathRowTemp)
            
            }
            else
            {
                delegate?.addNewAlarmMember(data: addStructure)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChange() -> Void
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableViewtitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = tableViewtitle[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0
        {
            cell.detailTextLabel?.text = (addStructure!.isDone.isEmpty ? "永不" : AlarmViewController().repeatDetailSet(weekStructure: addStructure!))
        }
        else if indexPath.row == 1
        {
            cell.detailTextLabel?.text = addStructure?.label
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.backgroundColor = backgroundColor
        cell.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        anotherSettingTableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0
        {
            let vc2 = RepeatDateViewController()
            vc2.delegate = self
            if let isDone = addStructure?.isDone
            {
                vc2.isDone = isDone
            }
            self.navigationController?.pushViewController(vc2, animated: true)
        }
        else if indexPath.row == 1
        {
            let vc2 = LabelViewController()
            vc2.delegate = self
            vc2.labelTextField.text = ( addStructure!.label.isEmpty ? "鬧鐘" : addStructure!.label)
            self.navigationController?.pushViewController(vc2, animated: true)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func returnRepeatDelegate(returnIsDoen: Set<WeeksProcedure>)
    {
        addStructure?.isDone = returnIsDoen
    }
    
    func autoLayout() -> Void
    {
        var constrains = [NSLayoutConstraint]()
        
        constrains.append(cancelButton.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 35))
        constrains.append(cancelButton.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 30))
        constrains.append(cancelButton.widthAnchor.constraint(equalToConstant: 40))
        constrains.append(cancelButton.heightAnchor.constraint(equalToConstant: 20))
        NSLayoutConstraint.activate(constrains)
                
        constrains.append(timeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constrains.append(timeLabel.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 125))
        constrains.append(timeLabel.widthAnchor.constraint(equalToConstant: fullSize.width - 30))
        constrains.append(timeLabel.heightAnchor.constraint(equalToConstant: 125))
        NSLayoutConstraint.activate(constrains)
        
        constrains.append(timeDatePicker.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100))
        constrains.append(timeDatePicker.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 125))
        constrains.append(timeDatePicker.widthAnchor.constraint(equalToConstant: 100))
        constrains.append(timeDatePicker.heightAnchor.constraint(equalToConstant: 60))
        NSLayoutConstraint.activate(constrains)
        
        constrains.append(anotherSettingTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constrains.append(anotherSettingTableView.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 300))
        constrains.append(anotherSettingTableView.widthAnchor.constraint(equalToConstant: fullSize.width))
        constrains.append(anotherSettingTableView.heightAnchor.constraint(equalToConstant: 175))
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

extension AddAlarmViewController : LabelValueReturn
{
    func labelValueReturn(data: String)
    {
        addStructure?.label = data
    }
}
