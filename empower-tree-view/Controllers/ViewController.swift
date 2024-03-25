//
//  ViewController.swift
//  empower-tree-view
//
//  Created by Erik Perez on 3/22/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    private let parentView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(parentView)
        
        // 30 = horizontal padding of 15
        let size: CGFloat = view.bounds.width - 30
        
        NSLayoutConstraint.activate([
            parentView.heightAnchor.constraint(equalToConstant: size),
            parentView.widthAnchor.constraint(equalToConstant: size),
            parentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let initialFrame = CGRect(origin: .zero,
                                  size: parentView.frame.size)
        
        createTreeView(integers: [3, 2, 1, 1, 1, 1, 1],
                       availableFrame: initialFrame,
                       parentView: parentView,
                       shouldSplitWidth: true)
    }
    
    // MARK: Methods
    
    private func createTreeView(
        integers: [Int],
        availableFrame: CGRect,
        parentView: UIView,
        shouldSplitWidth: Bool)
    {
        if integers.count <= 2 {
            addSubviews(integers: integers,
                        availableFrame: availableFrame,
                        parentView: parentView,
                        shouldSplitWidth: shouldSplitWidth)
            return
        }
        
        let middleIndex = (integers.count - 1) / 2
        let allIntegersSum = integers.sum
        
        let availableWidth = availableFrame.width / CGFloat(allIntegersSum)
        let availableHeight = availableFrame.height / CGFloat(allIntegersSum)
        
        let leftHalf = Array(integers[...middleIndex])
        let leftHalfSum = leftHalf.sum
        
        let newLeftHalfWidth = availableWidth * CGFloat(leftHalfSum)
        let newLeftHalfHeight = availableHeight * CGFloat(leftHalfSum)
        
        let newLeftHalfFrame = CGRect(
            x: availableFrame.origin.x,
            y: availableFrame.origin.y,
            width: shouldSplitWidth ? newLeftHalfWidth : availableFrame.width,
            height: !shouldSplitWidth ? newLeftHalfHeight : availableFrame.height)
        
        createTreeView(integers: leftHalf,
                       availableFrame: newLeftHalfFrame,
                       parentView: parentView,
                       shouldSplitWidth: !shouldSplitWidth)
        
        let rightHalf = Array(integers[(middleIndex + 1)...])
        let rightHalfSum = rightHalf.sum
        
        let newRightHalfWidth = availableWidth * CGFloat(rightHalfSum)
        let newRightHalfHeight = availableHeight * CGFloat(rightHalfSum)
        
        // offset with left half frame size
        let horizontalOffset = (shouldSplitWidth ? newLeftHalfWidth : 0)
        let verticalOffset = (!shouldSplitWidth ? newLeftHalfHeight : 0)
        
        let newRightHalfFrame = CGRect(
            x: availableFrame.origin.x + horizontalOffset,
            y: availableFrame.origin.y + verticalOffset,
            width: shouldSplitWidth ? newRightHalfWidth : availableFrame.width,
            height: !shouldSplitWidth ? newRightHalfHeight : availableFrame.height)
        
        createTreeView(integers: rightHalf,
                       availableFrame: newRightHalfFrame,
                       parentView: parentView,
                       shouldSplitWidth: !shouldSplitWidth)
    }
    
    private func addSubviews(
        integers: [Int],
        availableFrame: CGRect,
        parentView: UIView,
        shouldSplitWidth: Bool) 
    {
        let integersSum = integers.sum
        var previousView: UIView?
        
        for integer in integers {
            let newView = UIView()
            newView.backgroundColor = .random
            
            if shouldSplitWidth {
                let width = (availableFrame.width / CGFloat(integersSum)) * CGFloat(integer)
                
                newView.frame = CGRect(
                    x: previousView?.frame.maxX ?? availableFrame.origin.x,
                    y: previousView?.frame.minY ?? availableFrame.origin.y,
                    width: width,
                    height: availableFrame.height)
            } else {
                let height = (availableFrame.height / CGFloat(integersSum)) * CGFloat(integer)
                
                newView.frame = CGRect(
                    x: previousView?.frame.minX ?? availableFrame.origin.x,
                    y: previousView?.frame.maxY ?? availableFrame.origin.y,
                    width: availableFrame.width,
                    height: height)
            }
            
            previousView = newView
            parentView.addSubview(newView)
        }
    }
}

extension UIColor {
    /// Returns a random UIColor
    static var random: UIColor {
        .init(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0)
    }
}

extension Array where Element == Int {
    /// Returns sum of all integers in array.
    var sum: Int {
        self.reduce(0, +)
    }
}
