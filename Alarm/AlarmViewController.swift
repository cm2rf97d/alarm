//
//  AlarmViewController.swift
//  Alarm
//
//  Created by 陳郁勳 on 2021/1/13.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, testDelegate
{
    let fullSize = UIScreen.main.bounds.size
    var newTableView = UITableView()
    let dateFormat = DateFormatter()
    let backgroundColor = UIColor(red: CGFloat(40.2/255), green: CGFloat(40.2/255), blue: CGFloat(40.2/255), alpha: 1)
    
    //var weekDays : [String] = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    
    var alarmInfos : [alarmInfo] = []
    {
        didSet
        {
            newTableView.reloadData()
            saveData()
            alarmInfos.sort { (alarmInfo1, alarmInfo2) -> Bool in
                return alarmInfo1.time < alarmInfo2.time
                
            }
        }
    }
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // set Navigation Controller Title, Color,
        self.view.backgroundColor = .black
        self.title = "鬧鐘"
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        loadData()
        // Notification Observer 增加
        //NotificationCenter.default.addObserver(forName: NSNotification.Name("returnDateValue"), object: nil, queue: nil, using: getReturnDateValue)
        
        //Table View
        newTableView.translatesAutoresizingMaskIntoConstraints = false
        newTableView = UITableView(frame: CGRect(x: 0, y: 20, width: fullSize.width, height: fullSize.height), style: .grouped)
        //newTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        newTableView.register(UINib(nibName: "AlarmTableViewCell", bundle: nil), forCellReuseIdentifier: "AlarmTableViewCell")
        newTableView.delegate = self
        newTableView.dataSource = self
        newTableView.separatorStyle = .singleLine
        newTableView.separatorColor = backgroundColor
        newTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        newTableView.allowsSelection = false
        newTableView.allowsSelectionDuringEditing = true
        newTableView.allowsMultipleSelection = false
        newTableView.backgroundColor = .black
        newTableView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(newTableView)
        
        //Right Button
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlarm))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = .orange
        
        //Edit Button
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.title = "編輯"
        self.navigationItem.leftBarButtonItem?.tintColor = .orange
        
        //timeDataPicker
        dateFormat.dateFormat = "HH:mm"
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title = section == 0 ? "鬧鐘" : "其他"
        
        if section == 0
        {
            title = "鬧鐘"
        }
        else if section == 1
        {
            title = "鬧鐘888"
        }
        else
        {
            title = "其他"
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            return 0
        case 1:
            return 1
        default:
            return alarmInfos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
            case 0 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AlarmTableViewCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
                cell.alarmTimeLabel.text = "12:34"
                cell.detalLabel?.text = "鬧鐘1234,永不"
                let alarmSwitch = UISwitch(frame: .zero)
                alarmSwitch.isOn = true
                cell.accessoryView = alarmSwitch
                cell.editingAccessoryType = .disclosureIndicator
                return cell
            case 2:
                let alarmCell = alarmInfos[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
                cell.detalLabel.text = alarmInfos[indexPath.row].label + "," + repeatDetailSet(weekStructure: alarmCell)
                cell.alarmTimeLabel.text = dateFormat.string(from: alarmCell.time)
                let alarmSwitch = UISwitch(frame: .zero)
                alarmSwitch.isOn = true
                cell.accessoryView = alarmSwitch
                cell.editingAccessoryType = .disclosureIndicator
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1",for: indexPath )
                return cell
        }
       
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        newTableView.deselectRow(at: indexPath, animated: true)
        let addVC =  AddAlarmViewController()
        let nav = UINavigationController(rootViewController: addVC)
        
        addVC.delegate = self
        addVC.addStructure = alarmInfos[indexPath.row]
        addVC.indexPathRowTemp = indexPath.row
        self.present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.backgroundColor = .black
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        switch editingStyle
        {
            case .delete:
                alarmInfos.remove(at: indexPath.row)
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        if let headerView = view as? UITableViewHeaderFooterView
        {
            headerView.textLabel?.textColor = .white
            if section == 0
            {
                headerView.textLabel?.font = UIFont.systemFont(ofSize: 40)
            }
            else
            {
                headerView.textLabel?.font = UIFont.systemFont(ofSize: 20)
            }
        }
        view.tintColor = .black
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 80
        }
        else if section  == 1
        {
            return 10
        }
        else
        {
            return 40
        }
    }

    @objc func addAlarm() -> Void
    {
        let nav = UINavigationController(rootViewController: AddAlarmViewController())
        let addVC = nav.viewControllers.first as! AddAlarmViewController
        addVC.delegate = self
        self.present(nav, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool)
    {
        super.setEditing(editing, animated: animated)
        newTableView.setEditing(editing, animated: true)
    }
    
    func addNewAlarmMember(data: alarmInfo)
    {
        alarmInfos.append(data)
    }
    
    func returnEditingData(data: alarmInfo, indexPathRow: Int)
    {
        alarmInfos[indexPathRow] = data
        newTableView.reloadData()
        saveData()
    }
    
    func repeatDetailSet(weekStructure: alarmInfo) -> String
    {
        var weekDetail: String = ""
        switch weekStructure.isDone
        {
            case [.星期日,.星期六]:
                weekDetail = "假日"
            case [.星期一,.星期二,.星期三,.星期四,.星期五]:
                weekDetail = "平日"
            case [.星期一,.星期二,.星期三,.星期四,.星期五,.星期六,.星期日]:
                weekDetail = "每天"
            case []:
                weekDetail = "永不"
            default:
                weekDetail = weekStructure.isDone
                    .sorted(by: {$0.rawValue < $1.rawValue})
                    .map({ $0.weeKdays}).joined(separator: " ")
        }
        return weekDetail
    }
    
    func saveData()
    {
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(alarmInfos), forKey: "alarmInfos")
        print("savedata")
    }


    func loadData()
    {
        if let data = UserDefaults.standard.value(forKey: "alarmInfos") as? Data
        {
            let alarmInfos2 = try? PropertyListDecoder().decode(Array<alarmInfo>.self, from: data)
            if let alarmInfos2 = alarmInfos2
            {
                alarmInfos = alarmInfos2
            }
        }
        print("loadData")
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
