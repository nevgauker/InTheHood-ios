//
//  OnboardingViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 26/10/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

// MARK: UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
 
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count

            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
        return orderedViewControllers[nextIndex]
    }
    
}

class OnboardingViewController: UIPageViewController {
    
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)ViewController")
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(color: "Green"),
                self.newColoredViewController(color: "Red"),
                self.newColoredViewController(color: "Blue")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
          if let firstViewController = orderedViewControllers.first {
              setViewControllers([firstViewController],
                                 direction: .forward,
                  animated: true,
                  completion: nil)
          }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
