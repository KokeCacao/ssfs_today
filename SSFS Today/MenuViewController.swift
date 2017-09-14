//
//  MenuViewController.swift
//  SSFS Today
//
//  Created by Brian Wilkinson on 9/12/17.
//  Copyright © 2017 Brian Wilkinson. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var menu = Menu()
    
    var weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    @IBOutlet weak var lunchEntreeText: UILabel!
    
    
    
    @IBOutlet weak var vegetarianEntreeLabel: UILabel!
    
    @IBOutlet weak var vegetarianEntreeText: UILabel!
    
    
    
    
    @IBOutlet weak var sidesLabel: UILabel!
    @IBOutlet weak var sidesText: UILabel!
    
    
    @IBOutlet weak var downtownDeliLabel: UILabel!
    @IBOutlet weak var downtownDeliText: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var lunchMenuBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayOfWeek()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            lunchMenuBackground.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = lunchMenuBackground.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            lunchMenuBackground.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            lunchMenuBackground.layer.cornerRadius = 10.0
            lunchMenuBackground.clipsToBounds = true
        } else {
            lunchMenuBackground.backgroundColor = UIColor.white
        }
        
    }
    
    func dayOfWeek() {
        var dayString = String()
        var dayBool = Bool()
        let dayOfWeek = getCurrentDay()
        if dayOfWeek! == 2 {
            dayString = "MONDAY(.*?)TUESDAY"
            dayBool = false
        } else if dayOfWeek == 3 {
            dayString = "TUESDAY(.*?)WEDNESDAY"
            dayBool = false
        } else if dayOfWeek == 4 {
            dayString = "WEDNESDAY(.*?)THURSDAY"
            dayBool = false
        } else if dayOfWeek == 5 {
            dayString = "THURSDAY(.*?)FRIDAY"
            dayBool = false
        } else if dayOfWeek == 6 {
            dayString = "FRIDAY(.*)"
            dayBool = true
        }
        // This function links the return from the getCurrentDay function to the corresponding weekday and gets the information for the day by using the words in between that day and the following. Claire Youmans created this function, I edited the if statements to correspond with my getCurrentDay function.
        let day = DailyMenu(regExText: dayString, isFriday: dayBool)
        dateLabel.text = weekdays[dayOfWeek! - 2]
        // dayOfWeek starts at 2 (becuase Monday is returned as Optional(2) in the getCurrentDay function. So to make it correspond with the weekdays variable, there is a "- 2" so that the weekdays align.
        lunchEntreeText.text = day.lunchEntree
        vegetarianEntreeText.text = day.vegetarianEntree
        sidesText.text = day.sides
        downtownDeliText.text = day.downtownDeli
    }
    
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AfterSchoolViewController")
            self.present(vc, animated: false, completion: nil)
        }
    }
    func getCurrentDay()->Int?{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekday], from: date)
        let day = components.weekday
        
        return day
        // code from http://stackoverflow.com/questions/28861091/getting-the-current-day-of-the-week-in-swift .This function gets the current day of the week and returns it as Optional() with the corresponding number for the day of the week it is. For example Optional(2) is Monday and Optional(1) is Sunday.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
