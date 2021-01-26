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
        
        // Configure the view for the selected state
    }
    //    func loadXib() -> Void
    //    {
    //        let bundle = Bundle(for: type(of: self))
    //        let nib = UINib(nibName: String(describing: self), bundle: bundle)
    //
    //        let xibViewCell = nib.instantiate(withOwner: self, options: nil)[0] as! UITableViewCell
    //        addSubview(xibViewCell)
    //
    //        xibViewCell.translatesAutoresizingMaskIntoConstraints = false
    //
    //        var constrains = [NSLayoutConstraint]()
    //
    //        constrains.append(xibViewCell.centerXAnchor.constraint(equalTo: self.leftAnchor, constant: 35))
    //        constrains.append(xibViewCell.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 30))
    //        constrains.append(xibViewCell.widthAnchor.constraint(equalToConstant: 40))
    //        constrains.append(xibViewCell.heightAnchor.constraint(equalToConstant: 20))
    //        NSLayoutConstraint.activate(constrains)
    //    }
    
}
