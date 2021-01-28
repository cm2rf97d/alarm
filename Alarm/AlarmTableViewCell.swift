//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by 陳郁勳 on 2021/1/17.
//

import UIKit

class AlarmTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var detalLabel: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
