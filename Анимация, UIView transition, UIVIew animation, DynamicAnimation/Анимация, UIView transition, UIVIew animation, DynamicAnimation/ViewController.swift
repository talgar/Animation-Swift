//
//  ViewController.swift
//  Анимация, UIView transition, UIVIew animation, DynamicAnimation
//
//  Created by admin on 12/1/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firtsBTN: UIButton!
    @IBOutlet weak var secondBTN: UIButton!
    @IBOutlet weak var thirdBTN: UIButton!
    @IBOutlet weak var closeBTN: UIButton!
    @IBOutlet weak var startMoovingBTN: UIButton!
    @IBOutlet weak var dropViewBTN: UIButton!
    
    @IBOutlet weak var reklamView: UIImageView!
    
    @IBOutlet weak var animationView: UIView!
    
    private weak var timer : Timer?
    private weak var timer1 : Timer?
    
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var collider: UICollisionBehavior?
    var itemBehavior: UIDynamicItemBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - timer for 3 buttons . they're changing color
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [self] _ in
            firtsBTN.backgroundColor = randomColor()
            secondBTN.backgroundColor = randomColor()
            thirdBTN.backgroundColor = randomColor()
        }
        
        //MARK: - download reklam after 5.0 seconds
//        timer1 = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [self]_ in
//            if let url =
//                URL(string:"https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.facebook.com%2Fimagesibiu%2F%3Fref%3Dnf%26hc_ref%3DARR6_FegvFxc9lpAadrzafCL7trcoNW5HnxhZqj2aqs7DjkT0ImG8xYhS3TuRZpVdRM&psig=AOvVaw0D4mNVg_kScpmAp5Q_kzHO&ust=1610578488735000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCPijvse-l-4CFQAAAAAdAAAAABAD") , let data =  try? Data(contentsOf:url), let image = UIImage(data: data) {
//                let imageView = UIImageView(image: image)
//                reklamView = imageView
//            }
//        }
//
        //MARK: - dynamic animation
        animator = UIDynamicAnimator(referenceView: view)
        
        gravity = UIGravityBehavior()
        collider = UICollisionBehavior()         // отскакиваие баттонов
        itemBehavior = UIDynamicItemBehavior()
        
        collider?.translatesReferenceBoundsIntoBoundary = true // баттоны будут отскакивать от стен контроллерв
        collider?.collisionMode = .everything // объекты будут взаимодействовать со всеми
        
        collider?.addItem(dropViewBTN) // элементы будут соприкасаться и ударяться об dropViewBTN
       // gravity?.addItem(dropViewBTN)
        
        itemBehavior?.elasticity = 1  // соприкосновение баттонов с друг с другом эффект
        itemBehavior?.friction = 1   // трата энергии баттонов при соприкосновении
        itemBehavior?.allowsRotation = true // элементы смогут вращаться
        
        animator?.addBehavior(gravity!)
        animator?.addBehavior(collider!)
        animator?.addBehavior(itemBehavior!)
        
    }
    
    //MARK: - func for random colors
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

    func randomColor() -> UIColor {
        let r = randomCGFloat()
        let g = randomCGFloat()
        let b = randomCGFloat()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 20)
    }


    //MARK: - action to close reklam (x button)
    @IBAction func closeAct(_ sender: Any) {
        reklamView.isHidden = true
        closeBTN.isHidden = true
    }
    
    //MARK: - animation (the view is zooming )
    @IBAction func startMoovingACt(_ sender: Any) {
        let backgroundColor = animationView.backgroundColor
        let alpha = animationView.alpha
        let center = animationView.center
        let transform = animationView.transform
        
        UIView.animate(withDuration: 4) { [self] in
            animationView.backgroundColor = .gray
            animationView.alpha = 0
            animationView.center = CGPoint(x: 400, y: 600)
            animationView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        } completion: { [self] (isFinished) in
            if isFinished {
                UIView.animate(withDuration: 4, delay: 2, options: [.curveEaseOut], animations: {
                               animationView.backgroundColor = backgroundColor
                               animationView.alpha = alpha
                               animationView.center = center
                               animationView.transform = transform},
                               completion: nil)

            }
        }
    }
    
    //MARK: - transition (the view will change, turn the rigth left bottom.....)
    @IBAction func startTransformAct(_ sender: Any) {
        let label = UILabel(frame: CGRect(x: 20, y: 30, width: 100, height: 30))
        label.text = "front side"
        
        UIView.transition(with: self.animationView,
                          duration: 2.0,
                          options: .transitionCurlUp,
                          animations: {self.animationView.addSubview(label)},
                          completion: {(isFinished) in
                            UIView.transition(with: self.animationView,
                                                  duration: 2.0,
                                                  options: .transitionFlipFromRight,
                                                  animations: { label.removeFromSuperview()},
                                                  completion: nil)})
    }
    
    
    
    //MARK: - action for dynamic animation
    @IBAction func dropViewAct(_ sender: Any) {
        // создание нового view при нажатии на dropViewAct
        let view = UIView(frame: CGRect(x: dropViewBTN.frame.origin.x, y: 40, width: 30, height: 30))
        view.backgroundColor = randomColor()
        view.layer.cornerRadius = 12
        
        self.view.addSubview(view)
        
        gravity?.addItem(view)
        collider?.addItem(view)
        itemBehavior?.addItem(view)
    }
    
    
}

