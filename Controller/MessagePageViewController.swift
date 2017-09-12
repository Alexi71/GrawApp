//
//  MessagePageViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 12.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit

class MessagePageViewController: UIPageViewController {

    var pageControl = UIPageControl()
    let viewControllerIdentifiers : [String] = ["temp100","tempEnd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        dataSource = self
        delegate = self
        configurePageControl()
        
        let firstViewController = getViewControllerByIndex(index: 0)
        if let vc = firstViewController as? MessageBaseViewController {
            //vc.dataItems = dataItems
            setViewControllers([vc],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func getViewControllerByIndex(index: Int) -> UIViewController {
        if let contentVC =  UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: viewControllerIdentifiers[index]) as? MessageBaseViewController{
            contentVC.index = index
            return contentVC
        }
        return MessageBaseViewController()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MessagePageViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContent = viewController as! MessageBaseViewController
        var index = pageContent.index
        if (index == NSNotFound || index == 0) {
            return nil
        }
        index -= 1
        return getViewControllerByIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContent = viewController as! MessageBaseViewController
        var index = pageContent.index
        if (index == NSNotFound) {
            return nil
        }
        
        index += 1
        if index == viewControllerIdentifiers.count {
            return nil
        }
        
        return getViewControllerByIndex(index: index)
        
    }
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        
        
        pageControl = UIPageControl(frame: CGRect(x: 0,y: self.view.bounds.minX ,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = viewControllerIdentifiers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0].restorationIdentifier!
        self.pageControl.currentPage = viewControllerIdentifiers.index(of: pageContentViewController)!
    }
    
    
    
}
