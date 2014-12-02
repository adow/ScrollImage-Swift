//
//  ViewController.swift
//  ScrollImage
//
//  Created by 秦 道平 on 14/12/1.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var imageViewConstraintTop:NSLayoutConstraint!
    @IBOutlet weak var imageViewConstraintRight:NSLayoutConstraint!
    @IBOutlet weak var imageViewConstraintBottom:NSLayoutConstraint!
    @IBOutlet weak var imageViewConstraintLeft:NSLayoutConstraint!
    @IBOutlet weak var imageViewConstraintWidth:NSLayoutConstraint!
    @IBOutlet weak var imageViewConstraintHeight:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let image = imageView.image!
        let scrollViewSize = self.scrollView.frame.size
        let widthRatio = image.size.width / imageView.frame.size.width
        let heightRatio = image.size.height / imageView.frame.size.height
        var maxRatio = (widthRatio > heightRatio) ? heightRatio : widthRatio
        maxRatio = fmax(maxRatio, 1.0)
//        self.scrollView.maximumZoomScale = 10.0
        self.scrollView.maximumZoomScale = maxRatio ///最大就是图片的100%尺寸
        self.scrollView.zoomScale = 1.0
        self.updateConstraints()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///更新约束
    func updateConstraints(){
        let imageViewSize = self.imageView.frame.size
        let scrollViewSize = self.scrollView.frame.size
        let imageSize = self.imageView.image!.size
        
        NSLog("imageViewSize:%@,scrollViewSize:%@",
            NSStringFromCGSize(imageViewSize),NSStringFromCGSize(scrollViewSize))
        
        var left_margin : CGFloat = (scrollViewSize.width - imageViewSize.width) / 2.0
        var top_margin : CGFloat = (scrollViewSize.height - imageViewSize.height) / 2.0
        
        var scroll_x : CGFloat = 0.0
        if left_margin < 0 {
            scroll_x = -left_margin
            left_margin = 0.0
            
        }
        var scroll_y : CGFloat = 0.0
        if top_margin < 0.0 {
            scroll_y = -top_margin
            top_margin = 0.0
            
        }
        
        let right_margin : CGFloat = left_margin
        let bottom_margin : CGFloat = top_margin
        
        NSLog("top_margin:%@,right_margin:%@,bottom_margin:%@,left_margin:%@",
            top_margin,right_margin,bottom_margin,left_margin)
        
        self.imageViewConstraintTop.constant = top_margin
        self.imageViewConstraintRight.constant = right_margin
        self.imageViewConstraintBottom.constant = bottom_margin
        self.imageViewConstraintLeft.constant = left_margin
        
        self.view.layoutIfNeeded()
        //按道理设置约束条件就可以了，但是不解的是，如果现在的大小还是比scrollView小的话，就会看到contentSize是一个错误的值（实际的尺寸乘以缩放倍数），所以当图片还是很小的时候，还是把contentSize缩小倍数，如果 top_margin,left_margin 这些都是 0.0 的时候，contentSize 是正确的。现在还无法理解为什么。
        if top_margin > 0.0 && left_margin > 0.0 {
            let scale_contentsize = CGSizeMake(self.scrollView.contentSize.width / scrollView.zoomScale,
                self.scrollView.contentSize.height / scrollView.zoomScale)
            self.scrollView.contentSize = scale_contentsize
        }
        NSLog("imageViewConstraintWidth:%@,imageViewConstraintHeight:%@,imageViewConstraintTop:%@,imageViewConstraintRight:%@,imageViewConstraintBottom:%@,imageViewConstraintLeft:%@",
            self.imageViewConstraintWidth.constant,self.imageViewConstraintHeight.constant,
            self.imageViewConstraintTop.constant,self.imageViewConstraintRight.constant,
            self.imageViewConstraintBottom.constant,self.imageViewConstraintLeft.constant)
        NSLog("scrollViewContentSize:%@", NSStringFromCGSize(self.scrollView.contentSize))
        
        
        self.scrollView.contentOffset = CGPoint(x: scroll_x, y: scroll_y)
        
    }
    ///触摸控制，放大缩小
    @IBAction func onTapGesture(gesture:UITapGestureRecognizer){
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            if self.scrollView.zoomScale != self.scrollView.maximumZoomScale {
                self.scrollView.zoomScale = self.scrollView.maximumZoomScale
            }
            else{
                self.scrollView.zoomScale = 1.0
            }
        })
        
    }
    ///MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.updateConstraints()
    }
    
}

