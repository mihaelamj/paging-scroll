//
//  PagingScrollView.swift
//  PagingScroll
//
//  Created by Mihaela Mihaljevic Jakic on 31/10/2017.
//  Copyright © 2017 Mihaela Mihaljevic Jakic. All rights reserved.
//

import Foundation
import UIKit

class PagingScrollView : UIView {
  
  //MARK: Properties -
  
  public lazy var scrollView: UIScrollView = {
    let sv = UIScrollView()
//    sv.backgroundColor = UIColor.clear
    sv.isPagingEnabled = true
    sv.accessibilityLabel = "Scroll View"
    return sv
  }()
  
  public lazy var pageControl: UIPageControl = {
    let pc = UIPageControl()
    pc.accessibilityLabel = "Page Control"
    pc.tintColor = UIColor.red
    pc.pageIndicatorTintColor = UIColor.black
    pc.currentPageIndicatorTintColor = UIColor.green
    return pc
  }()
  
  let pageTag = 666
  
  public var isHorizontal = true
  public var hasPages = false
  
  //MARK: Init -
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
    self.accessibilityLabel = "Paging-Scroll View"
  }
  
  public convenience init() {
    self.init(frame: .zero)
  }
  
//MARK: Setup -
  
  public func setupViews() {
    //scroll view
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(scrollView)
    alignAll(view: scrollView, superview: self)
    scrollView.delegate = self
    
    //page control
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(pageControl)
    let pageGap: CGFloat = 8.0
    self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: pageGap))
    self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: pageGap))
    self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -pageGap))
    self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 30))
    pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
  }
  
  @objc func changePage(sender: UIPageControl) {
    
    let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
    scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
  }
  
  private func alignAll(view: UIView, superview: UIView) {
    superview.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0))
    superview.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0))
    superview.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0))
    superview.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0))
  }
  
  private func alignPagesHorizontally(pages: [UIView]) {
    
    var horString = ""
    var vertString = ""
    var index = 0
    let parentName = "parent"
    var views: [String: UIView] = [parentName: self]
    
    for page in pages {
      index = index + 1
      
      //update dict
      let pageName = "page\(index)"
      views.updateValue(page, forKey: pageName)
      
      //update hor string
      horString += "[\(pageName)(==\(parentName))]"
      
      //update vert string
      if (index == 1) {
        vertString = "V:|[\(pageName)(==\(parentName))]|"
      }
    }
    
    let horPrefix = "H:|"; let horSuffix = "|"
    horString = horPrefix + horString + horSuffix
    
    let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: vertString, options: [], metrics: nil, views: views)
    let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horString, options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
    NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
  }
  
  private func alignPagesVertically(pages: [UIView]) {
    //TODO:
  }
  
  
//MARK: Pages -
  
  public func addPages(pages: [UIView]) {
    
    if (hasPages) {
      fatalError("Pages may be added only once!")
    }
    
    var index = 0
    for page in pages {
      page.tag = pageTag
      index += 1
      page.accessibilityLabel = "page \(index)"
      page.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview(page)
    }
    
    if (isHorizontal) {
      alignPagesHorizontally(pages: pages)
    } else {
      alignPagesVertically(pages: pages)
    }
    
    self.bringSubview(toFront: pageControl)
    pageControl.numberOfPages = pages.count
  }
}

//MARK: Extensions -

extension PagingScrollView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageWidth = scrollView.bounds.width
    let pageFraction = scrollView.contentOffset.x / pageWidth
    pageControl.currentPage = Int(round(pageFraction))
  }
}

