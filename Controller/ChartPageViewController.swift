//
//  ChartPageViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 06.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit

class ChartPageViewController: UIPageViewController {
    var pageControl = UIPageControl()
    let viewControllerIdentifiers : [String] = ["ProfileTimeChart","ProfileAltitudeChart"]
    var dataItems:InpuDataController?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        dataSource = self
        delegate = self
        configurePageControl()
      
        let firstViewController = getViewControllerByIndex(index: 0)
        if let vc = firstViewController as? ChartBaseViewController {
            vc.dataItems = dataItems
            setViewControllers([vc],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func getViewControllerByIndex(index: Int) -> UIViewController {
        if let contentVC =  UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: viewControllerIdentifiers[index]) as? ChartBaseViewController {
            contentVC.index = index
            return contentVC
        }
        return ChartViewController()
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

extension ChartPageViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContent = viewController as! ChartBaseViewController
        var index = pageContent.index
        if (index == NSNotFound || index == 0) {
            return nil
        }
        index -= 1
        return getViewControllerByIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContent = viewController as! ChartBaseViewController
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
    func setupPageConrol () {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.blue
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
    
    /*
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let count = viewControllerIdentifiers.count
        print (count)
        setupPageConrol()
        return viewControllerIdentifiers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        if  let firstVC = viewControllers?.first {
            if let identifier = firstVC.restorationIdentifier {
                if let vcIndex = viewControllerIdentifiers.index(of: identifier) {
                    return vcIndex
                }
            }
        }
        return 0
    }*/
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0].restorationIdentifier!
        self.pageControl.currentPage = viewControllerIdentifiers.index(of: pageContentViewController)!
    }
    
    
    
}
