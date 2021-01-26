//
//  RepeatDateViewController.swift
//  Alarm
//
//  Created by 陳郁勳 on 2021/1/14.
//

import UIKit

class EditAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    struct week
    {
        var weekDay : String
        var weekDone : Bool
    }
    
    let backgroundColor = UIColor( red: CGFloat(40.2/255), green: CGFloat(40.2/255), blue: CGFloat(40.2/255), alpha: 1)
    let fullSize = UIScreen.main.bounds.size
    var weekArray : [week] = [
        week(weekDay: "星期日", weekDone: false),
        week(weekDay: "星期一", weekDone: false),
        week(weekDay: "星期二", weekDone: false),
        week(weekDay: "星期三", weekDone: false),
        week(weekDay: "星期四", weekDone: false),
        week(weekDay: "星期五", weekDone: false),
        week(weekDay: "星期六", weekDone: false),
    ]
        
    let weekSetTableView = UITableView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Navigation title setting
        self.title = "重複"
        self.view.backgroundColor = UIColor( red: CGFloat(25.2/255), green: CGFloat(25.2/255), blue: CGFloat(25.2/255), alpha: 1)
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        //Navigation Title Text color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        loadData()

        weekSetTableView.translatesAutoresizingMaskIntoConstraints = false
        weekSetTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        weekSetTableView.delegate = self
        weekSetTableView.dataSource = self
        weekSetTableView.separatorStyle = .singleLine
        weekSetTableView.allowsSelection = true
        weekSetTableView.allowsMultipleSelection = false
        weekSetTableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(weekSetTableView)
        
        AutoLayout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weekArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = weekArray[indexPath.row].weekDay
        if weekArray[indexPath.row].weekDone == true
        {
            cell.accessoryType = .checkmark
        } else
        {
            cell.accessoryType = .none
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
        weekSetTableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        if weekArray[indexPath.row].weekDone == false
        {
            cell?.accessoryType = .checkmark
            weekArray[indexPath.row].weekDone = true
        }
        else
        {
            cell?.accessoryType = .none
            weekArray[indexPath.row].weekDone = false
        }
        saveData()
        
    }
    func AutoLayout() -> Void
    {
        var constrains = [NSLayoutConstraint]()
        
        constrains.append(weekSetTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constrains.append(weekSetTableView.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 300))
        constrains.append(weekSetTableView.widthAnchor.constraint(equalToConstant: fullSize.width))
        constrains.append(weekSetTableView.heightAnchor.constraint(equalToConstant: 308))
        NSLayoutConstraint.activate(constrains)
    }
    
    func saveData() -> Void
    {
        let weekArraySave = weekArray.map{ (week) -> [String : Any] in
            
            return ["weekDay" : week.weekDay, "weekDone" : week.weekDone ]
            
        }
        
        UserDefaults.standard.setValue(weekArraySave, forKey: "weekArraySave")
        
    }

    func loadData() -> Void
    {
        if let loadSuccess = UserDefaults.standard.array(forKey: "weekArraySave") as? [[String: Any]]{
            
            weekArray = []
            
            for loadInfo in loadSuccess
            {
                let weekDay = loadInfo["weekDay"] as? String ?? ""
                let weekDone = loadInfo["weekDone"] as? Bool ?? false
                
                weekArray.append(week(weekDay: weekDay, weekDone: weekDone))
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
