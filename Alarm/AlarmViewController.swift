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
    
    struct alarmInfo
    {
        var time : String = ""
        var label : String = ""
        var isDone : [Bool] = []
    }
    
    var weekDays : [String] = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    
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
        newTableView.frame = CGRect(x: 0, y: 20, width: fullSize.width, height: fullSize.height)
        //newTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        newTableView.register(UINib(nibName: "AlarmTableViewCell", bundle: nil), forCellReuseIdentifier: "AlarmTableViewCell")
        newTableView.delegate = self
        newTableView.dataSource = self
        newTableView.separatorStyle = .singleLine
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
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let title = section == 0 ? "鬧鐘" : "其他"
        return title
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            return 1
        default:
            return alarmInfos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
                cell.alarmTimeLabel.text = "12:34"
                cell.detalLabel?.text = "鬧鐘1234,永不"
                let alarmSwitch = UISwitch(frame: .zero)
                alarmSwitch.isOn = true
                cell.accessoryView = alarmSwitch
                cell.editingAccessoryType = .disclosureIndicator
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
                cell.alarmTimeLabel.text = alarmInfos[indexPath.row].time
                cell.detalLabel.text = alarmInfos[indexPath.row].label + "," + repeatDetailSet(weekStructure: alarmInfos[indexPath.row])
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
    
    func repeatDetailSet( weekStructure : alarmInfo ) -> String
    {
        //"星期一" "星期二" "星期三" "星期四" "星期五" "星期六" "星期日"
        var test : String = "永不"
        var sortArray : [String] = []
        
        if !weekStructure.isDone.isEmpty
        {
            print(weekStructure.isDone)
            if weekStructure.isDone == [true, false, false, false, false, false, true]
            {
                test = "週末"
            }
            else if weekStructure.isDone == [false, true, true, true, true, true, false]
            {
                test = "平日"
            }
            else if weekStructure.isDone == [true, true, true, true, true, true, true]
            {
                test = "每天"
            }
            else if weekStructure.isDone == [false, false, false, false, false, false, false]
            {
                test = "永不"
            }
            else
            {
                test = ""
                for memberNum in 0..<weekDays.count
                {
                    if weekStructure.isDone[memberNum] == true
                    {
                        sortArray.append(weekDays[memberNum])
                    }
                    if memberNum == weekDays.count-1
                    {
                        let weekDayNumbers = [
                            "星期一": 0,
                            "星期二": 1,
                            "星期三": 2,
                            "星期四": 3,
                            "星期五": 4,
                            "星期六": 5,
                            "星期七": 6,
                        ]
                        sortArray.sort(by: { (weekDayNumbers[$0] ?? 7) < (weekDayNumbers[$1] ?? 7) })
                    }
                }
                for i in 0..<sortArray.count
                {
                    test += "\(sortArray[i])" + " "
                }
            }
        }
        return test
    }
    
    func saveData()
    {

        let alarmInfosSave = alarmInfos.map{ (alarmInfo) -> [String : Any] in
            return ["time" : alarmInfo.time, "label" : alarmInfo.label,"isDone": Array(alarmInfo.isDone)]
        }

        UserDefaults.standard.setValue(alarmInfosSave, forKey: "alarmInfoSave")
        print("savedata")
    }


    func loadData()
    {
        if let loadSuccess = UserDefaults.standard.array(forKey: "alarmInfoSave") as? [[String:Any]]
        {
            alarmInfos = []
    
            for loadInfo in loadSuccess
            {
                let time = loadInfo["time"] as? String ?? ""
                let label = loadInfo["label"] as? String ?? ""
                let isDone = loadInfo["isDone"] as? [Bool] ?? [false]

                alarmInfos.append(alarmInfo(time: time, label: label, isDone: isDone))
            }
        }

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
