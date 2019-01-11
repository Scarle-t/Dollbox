//
//  noticeEnlargeViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class noticeEnlargeViewController: UIViewController, UIScrollViewDelegate {
    
    deinit {
        print("Deinit noticeEnlargeViewController")
    }
    
    var selectedImg: UIImage?
    var initialTouchPoint = CGPoint.zero
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
    }
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var imgScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        AppDelegate.AppUtility.lockOrientation(.all)
        imgScroll.delegate = self
        imgScroll.minimumZoomScale = 1.0
        imgScroll.maximumZoomScale = 6.0
        cover.contentMode = .scaleAspectFit
        cover.image = selectedImg
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cover
    }

}
