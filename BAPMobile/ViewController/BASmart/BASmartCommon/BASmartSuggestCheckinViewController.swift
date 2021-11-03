//
//  BASmartSuggestCheckinViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/4/21.
//

import UIKit

class BASmartSuggestCheckinViewController: BaseViewController {

    @IBOutlet weak var buttonPlan: UIButton!
    @IBOutlet weak var buttonCustomer: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var planLine: UIView!
    @IBOutlet weak var customerLine: UIView!
    @IBOutlet weak var footerLine: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: BASmartDoneCreateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "GỢI Ý VÀO ĐIỂM"
    }
    
    private func setupView() {
        
        view.setCornerRadiusPopover()
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(hexString: "969696").cgColor
        cancelButton.setViewCorner(radius: 10)
        
        footerLine.drawDottedLine(view: footerLine)
        
        scrollView.contentSize = CGSize(width: view.frame.width * 2 , height: 0)
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        let vc1 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartSuggestPlanViewController") as! BASmartSuggestPlanViewController
        let vc2 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartSuggestCustomerViewController") as! BASmartSuggestCustomerViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        vc1.blurDelegate = blurDelegate
        vc1.finishDelegate = finishDelegate
        
        vc2.blurDelegate = blurDelegate
        vc2.finishDelegate = finishDelegate
        
        self.addChild(vc1)
        self.addChild(vc2)
        scrollView.addSubview(vc1.view)
        scrollView.addSubview(vc2.view)
        
        selectState(isPlan: true)
    }

    private func selectState(isPlan: Bool) {
        
        let selectedColor = UIColor.white
        let unselectedColor = UIColor(hexString: "DCDCDC")
        
        buttonPlan.backgroundColor = isPlan == true ? selectedColor : unselectedColor
        buttonCustomer.backgroundColor = isPlan == true ? unselectedColor : selectedColor
        planLine.backgroundColor = isPlan == true ? .orange : unselectedColor
        customerLine.backgroundColor = isPlan == true ? unselectedColor : .orange
        
        let scrollTo = isPlan == true ? 0 : view.frame.width + 40
        scrollView.setContentOffset(CGPoint(x: scrollTo, y: 0), animated: true)
    }
    
    @IBAction func buttonPlanTap(_ sender: Any) {
        selectState(isPlan: true)
    }
    
    @IBAction func buttonCustomerTap(_ sender: Any) {
        selectState(isPlan: false)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension BASmartSuggestCheckinViewController: UIScrollViewDelegate {
    
}
