//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Furkan Deniz Albaylar on 13.09.2023.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher


class SnapVC: UIViewController {
    
    var selectedSnap : Snap?
    
    var inputArray = [KingfisherSource]()

    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let snap = selectedSnap {
            timeLabel.text = "Hours Left : \(snap.timeDiffrence)"
        }
        if let snap = selectedSnap {
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
                
            }
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width*0.95, height: self.view.frame.height*0.9))
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.backgroundColor = UIColor.white
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
    }
    
    

    
}
