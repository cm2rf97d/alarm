//
//  RepeatDateViewController.swift
//  Alarm
//
//  Created by 陳郁勳 on 2021/1/14.
//

import UIKit

protocol returnRepeatDelegate
{
    func returnRepeatDelegate(returnIsDoen : [Bool])
}
class RepeatDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var delegate : returnRepeatDelegate?
    let backgroundColor = UIColor( red: CGFloat(40.2/255), green: CGFloat(40.2/255), blue: CGFloat(40.2/255), alpha: 1)
    let fullSize = UIScreen.main.bounds.size
    var weeks : [String] = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    var isDone : [Bool] = []
//    func saveData() -> Void
//    {
//        let weekArraySave = weeks.map{ (week) -> [String : Any] in
//
//            return ["weekDay" : week.weekDay, "weekDone" : week.weekDone ]
//
//        }
//
//        UserDefaults.standard.setValue(weekArraySave, forKey: "weekArraySave")
//
//    }
//
//    func loadData() -> Void
//    {
//        if let loadSuccess = UserDefaults.standard.array(forKey: "weekArraySave") as? [[String: Any]]{
//
//            weeks = []
//
//            for loadInfo in loadSuccess
//            {
//                let weekDay = loadInfo["weekDay"] as? String ?? ""
//                let weekDone = loadInfo["weekDone"] as? Bool ?? false
//
//                weeks.append(AlarmViewController.Week(weekDay: weekDay, weekDone: weekDone))
//            }
//        }
//    }

    
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
        
//        loadData()
        
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
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        delegate?.returnRepeatDelegate(returnIsDoen: isDone)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = weeks[indexPath.row]
        cell.accessoryType = (isDone[indexPath.row]) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.backgroundColor = backgroundColor
        cell.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
        isDone[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
//        let cell = tableView.cellForRow(at: indexPath)
//        if weeks[indexPath.row].weekDone == false
//        {
//            cell?.accessoryType = .checkmark
//            weeks[indexPath.row].weekDone = true
//        }
//        else
//        {
//            cell?.accessoryType = .none
//            weeks[indexPath.row].weekDone = false
//        }
       
//        saveData()
        
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
