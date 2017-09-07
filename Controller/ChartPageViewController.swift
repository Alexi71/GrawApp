//
//  ChartPageViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 06.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit

class ChartPageViewController: UIPageViewController {
    let viewControllerIdentifiers : [String] = ["ProfileTimeChart","ProfileAltitudeChart"]
    var dataItems:InpuDataController?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        dataSource = self
        
        var pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.white
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

extension ChartPageViewController: UIPageViewControllerDataSource {
    
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
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
    }
    
}
