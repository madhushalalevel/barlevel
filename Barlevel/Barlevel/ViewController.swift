//
//  ViewController.swift
//  BottleScaning
//
//  Created by Admin on 23/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var startPos = 790
    var endPos = 258
    var ml = 750.0
    var persantageArray = [0:790,5:775, 88:408, 93:362, 98:307, 100:258]
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var lblPrsantage: UILabel!

    var data: [String: String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if data?["name"] == "southern Rye whiskey (750ml)" {
             startPos = 700
             endPos = 258
             persantageArray = [0:700,5:680, 85:471, 90:436, 100:403]
        }
        self.lblPrsantage.text = data?["name"]
        self.imgView.image = UIImage(named: data?["img"] ?? "")
        let text = calculation(currentPos: Float(indicatorView.center.y))
        self.title = text
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
      let translation = recognizer.translation(in: self.view)
      if let view = recognizer.view {
        view.center = CGPoint(x:view.center.x ,
                              y:view.center.y + translation.y)
      }
//      let reconX = view.center.x
      recognizer.setTranslation(CGPoint.zero, in: self.view)
      
        if recognizer.state == UIGestureRecognizer.State.ended {
            let finalPoint = getFinalpoint(recognizer: recognizer)
            let text = calculation(currentPos: Float(indicatorView.center.y))
            self.title = text
            UIView.animate(withDuration: Double(finalPoint.slideFactor * 2),
                           delay: 0,
                           // 6
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {recognizer.view!.center = finalPoint.fianlPoint },
              completion: nil)
      } else if recognizer.state == UIGestureRecognizer.State.changed {
//            let text = calculation(currentPos: Float(indicatorView.center.y))
//            print(text)
//            self.title = text
        }
        
    }
    
    func getFinalpoint(recognizer: UIPanGestureRecognizer) -> (fianlPoint: CGPoint, slideFactor: CGFloat) {
        print(self.imgView.frame)
        let velocity = recognizer.velocity(in: self.imgView)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200
//        print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
        
        // 2
        let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
        // 3
        var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                 y:recognizer.view!.center.y + (velocity.y * slideFactor))
        // 4
        finalPoint.x = self.imgView.center.x
        finalPoint.y = min(max(finalPoint.y, CGFloat(endPos)), CGFloat(startPos))
        print("YY: \(finalPoint.y)")
        return (fianlPoint: finalPoint, slideFactor: slideFactor)
    }

    func calculation(currentPos: Float) -> String {
        print(currentPos)
        var dicVal1: Float?
        var dicKey1: Float?
        var dicVal2: Float?
        var dicKey2: Float?
        var text = "NAN(%)"
        let arr = persantageArray.sorted { (val, val2) -> Bool in
            return val.key < val2.key
        }
        for dic in arr {
            if Float(dic.value) < currentPos {
                dicVal2 = Float(dic.value)
                dicKey2 = Float(dic.key)
                break
            }
            dicVal1 = Float(dic.value)
            dicKey1 = Float(dic.key)
        }
//        print(dicVal1)
//        print(dicKey1)
//        print(dicVal2)
//        print(dicKey2)
        if dicKey1 == 100 {
            text = "\(Int(100))% (\(Int(ml))ml)"
        }
        else if dicKey2 == 0 {
            text = "\(Int(0))% (\(Int(0))ml)"
        }
        else if let dicVal1 = dicVal1, let dicVal2 = dicVal2, let dicKey1 = dicKey1, let dicKey2 = dicKey2  {
            let diffrance = dicVal1 - currentPos // 23
            let diffrance2 = dicVal1 - dicVal2 // 55
            let persantage =  dicKey2 - dicKey1 // 5
            let calculated = ((persantage * diffrance) / diffrance2)
            let final = dicKey1 + calculated
            let finalML = (ml * Double(final)) / 100
//            print(diffrance)
//            print(diffrance2)
//            print(persantage)
//            print(calculated)
//            print(final)
//            print(finalML)
            text = "\(Int(final))% (\(Int(finalML))ml)"
        }
        return text
    }

}

