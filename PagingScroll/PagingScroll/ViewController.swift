//
//  ViewController.swift
//  PagingScroll
//
//  Created by Mihaela Mihaljevic Jakic on 31/10/2017.
//  Copyright © 2017 Mihaela Mihaljevic Jakic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.translatesAutoresizingMaskIntoConstraints = false
    addScrollview()
  }

  func addScrollview() {
    
    let psv  = PagingScrollView()
    psv.frame = CGRect(x: 10, y: 60, width: 360, height: 600)
    self.view.addSubview(psv)
    
    //add pages
    let v1 = UIView()
    v1.backgroundColor = UIColor.red
    let v2 = UIView()
    v2.backgroundColor = UIColor.blue
    let v3 = UIView()
    v3.backgroundColor = UIColor.gray
    psv.addPages(pages: [v1, v2, v3])
  }


}

