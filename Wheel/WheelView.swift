//
//  WheelView.swift
//  Wheel
//
//  Created by andy on 2023/7/9.
//

import UIKit
import CoreGraphics

fileprivate let scale = UIScreen.main.scale

class WheelView: UIView {
    lazy var ani = CABasicAnimation()
    @IBAction func startBtnClicked(_ sender: UIButton) {
        ani.keyPath = "transform.rotation"
        ani.toValue = Double.pi * 4
        ani.duration  = 0.5
        ani.delegate = self
        self.contentview.layer.add(ani, forKey: "rotation")
    }
    
    @IBOutlet weak var contentview: UIImageView!
    @IBOutlet var view: UIView!
    var selectedBtn: MyButton?
    lazy var link: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(update))
        link.add(to: RunLoop.current, forMode: .default)
        return link
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
        setup()
    }
    
    func angle2Rad(_ angle: Double) -> CGFloat {
        return angle / 180 * .pi
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func initViewFromNib() {
        // 需要这句代码，不能直接写UINib(nibName: "MyView", bundle: nil)，不然不能在storyboard中显示
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WheelView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view.frame = bounds
        addSubview(view)
    }
    
    private func setup() {
        // 加载原图
        guard let originImage = UIImage(named: "LuckyAstrology") else { return }
        guard let originSelImage = UIImage(named: "LuckyAstrologyPressed") else { return }
        
        var imgX: CGFloat = 0
        var imgY: CGFloat = 0
        var imgW: CGFloat = originImage.size.width / 12.0 * 2 //* scale
        var imgH: CGFloat = originImage.size.height * 2 //* scale
        let w: CGFloat = 65
        let h: CGFloat = 143
        var angle: CGFloat = 0
        for i in 0..<12 {
            // 创建button
            let btn = MyButton(type: .custom)
            btn.bounds = CGRect(x: 0, y: 0, width: w, height: h)
            // 设置layer.position
            btn.layer.position = CGPoint.init(x: bounds.size.width*0.5, y: bounds.size.height*0.5)
            // 设置layer.anchorPoint
            btn.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            // 旋转button
            btn.transform = CGAffineTransform(rotationAngle: angle2Rad(angle))
            angle += 30
            btn.addTarget(self, action: #selector(clicked(_ :)), for: .touchUpInside)
            btn.setBackgroundImage(UIImage(named: "LuckyRototeSelected"), for: .selected)
            
            imgX = CGFloat(i) * imgW
            let imageRect = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
            // 剪切原图，获取button normal下要展示的image
            if let imageRef = originImage.cgImage?.cropping(to: imageRect) {
                btn.setImage(UIImage(cgImage: imageRef), for: .normal)
            }
            // 剪切原图，获取button selected下要展示的image
            if let imageSelRef = originSelImage.cgImage?.cropping(to: imageRect) {
                btn.setImage(UIImage(cgImage: imageSelRef), for: .selected)
            }
            contentview.addSubview(btn)
            if i == 0 {
                self.clicked(btn)
            }
            
        }
    }
    
    @objc private func clicked(_ sender: MyButton) {
        selectedBtn?.isSelected = false
        sender.isSelected = true
        selectedBtn = sender
    }

    @objc private func update() {
        contentview.transform = CGAffineTransformRotate(self.contentview.transform, .pi/300)
    }

}

//MARK: - 对外公开的方法
extension WheelView {
    
    public func rotation() {
        link.isPaused = false
    }
    
    
    public func stop() {
        link.isPaused = true
    }

}

extension WheelView: CAAnimationDelegate {
 
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let t = selectedBtn?.transform else { return }
        // 获取旋转的弧度
        let angle = atan2(t.b, t.a)
        // 父视图反向旋转相同的弧度
        contentview.transform = CGAffineTransform(rotationAngle: -angle)
    }
    
}
