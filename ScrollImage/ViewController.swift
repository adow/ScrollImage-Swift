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
    var initRatio : CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupImageConstraint()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupImageConstraint(){
        ///初始化约束条件设置，让图片的一边撑满，另一边缩放
        let image = imageView.image!
        let imageSize = image.size
        let scrollViewSize = self.scrollView.frame.size
        var target_image_width : CGFloat = 0.0
        var target_image_height : CGFloat = 0.0
        if imageSize.width < imageSize.height {
            target_image_width = 100.0
            target_image_height = imageSize.height / imageSize.width * target_image_width
        }
        else{
            target_image_height = 178.0
            target_image_width = imageSize.width * target_image_height / imageSize.height
        }
        ///不但要修改约束条件，还要修改 imageView 的尺寸
        var imageViewFrame = self.imageView.frame
        imageViewFrame.size.width = target_image_width
        imageViewFrame.size.height = target_image_height
        self.imageView.frame = imageViewFrame
        let left_margin : CGFloat = (scrollViewSize.width - target_image_width ) / 2.0
        let right_margin = left_margin
        let top_margin : CGFloat = (scrollViewSize.height - target_image_height) / 2.0
        let bottom_margin = top_margin
        self.imageViewConstraintTop.constant = top_margin
        self.imageViewConstraintRight.constant = right_margin
        self.imageViewConstraintBottom.constant = bottom_margin
        self.imageViewConstraintLeft.constant = left_margin
        self.imageViewConstraintWidth.constant = target_image_width
        self.imageViewConstraintHeight.constant = target_image_height
        
        ///maxZoom，放到最大就是图片的大小
        let maxWidthRatio = imageSize.width / target_image_width
        let maxHeightRatio = imageSize.height / target_image_height
        var maxRatio = (maxWidthRatio > maxHeightRatio) ? maxHeightRatio : maxWidthRatio
        maxRatio = fmax(maxRatio, 1.0)
        self.scrollView.maximumZoomScale = maxRatio
        
        ///initZoom,初始大小，依照一边撑满
        let initWidthRatio = scrollViewSize.width / target_image_width
        let initHeightRatio = scrollViewSize.height / target_image_height
        initRatio = (initWidthRatio > initHeightRatio) ? initHeightRatio : initWidthRatio
        initRatio = fmax(initRatio, 1.0)
        self.scrollView.zoomScale = initRatio
        ///
//        self.scrollView.zoomScale = 1.0
        self.updateConstraints()
        
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
        UIView.animateWithDuration(0.1, animations: { [unowned self]() -> Void in
            if self.scrollView.zoomScale != self.scrollView.maximumZoomScale {
                self.scrollView.zoomScale = self.scrollView.maximumZoomScale
            }
            else{
                self.scrollView.zoomScale = self.initRatio
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

