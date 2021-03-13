//
//  YBTextPicker.swift
//  YBTextPicker
//
//  Created by Yahya on 01/07/18.
//  Copyright © 2018 Yahya. All rights reserved.
//

import UIKit

public enum YBTextPickerAnimation:String{
    case FromBottom
    case Fade
}

public enum YBTextPickerCheckMarkPosition:String{
    case Left
    case Right
}

public struct YBTextPickerAppearanceManager {
    
 
    public  init(pickerTitle: String? = nil, titleFont: UIFont? = nil, titleTextColor: UIColor? = nil, titleBackground: UIColor? = nil, searchBarFont: UIFont? = nil, searchBarPlaceholder: String? = nil, closeButtonTitle: String? = nil, closeButtonColor: UIColor? = nil, closeButtonFont: UIFont? = nil, doneButtonTitle: String? = nil, doneButtonColor: UIColor? = nil, doneButtonFont: UIFont? = nil, checkMarkPosition: YBTextPickerCheckMarkPosition? = nil, itemCheckedImage: UIImage? = nil, itemUncheckedImage: UIImage? = nil, itemColor: UIColor? = nil, itemFont: UIFont? = nil) {
        self.pickerTitle = pickerTitle
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
        self.titleBackground = titleBackground
        self.searchBarFont = searchBarFont
        self.searchBarPlaceholder = searchBarPlaceholder
        self.closeButtonTitle = closeButtonTitle
        self.closeButtonColor = closeButtonColor
        self.closeButtonFont = closeButtonFont
        self.doneButtonTitle = doneButtonTitle
        self.doneButtonColor = doneButtonColor
        self.doneButtonFont = doneButtonFont
        self.checkMarkPosition = checkMarkPosition
        self.itemCheckedImage = itemCheckedImage
        self.itemUncheckedImage = itemUncheckedImage
        self.itemColor = itemColor
        self.itemFont = itemFont
    }

    var pickerTitle : String?
    var titleFont : UIFont?
    var titleTextColor : UIColor?
    var titleBackground : UIColor?
    
    var searchBarFont : UIFont?
    var searchBarPlaceholder : String?
    
    var closeButtonTitle : String?
    var closeButtonColor : UIColor?
    var closeButtonFont : UIFont?
    
    var doneButtonTitle : String?
    var doneButtonColor : UIColor?
    var doneButtonFont : UIFont?
    
    var checkMarkPosition : YBTextPickerCheckMarkPosition?
    var itemCheckedImage : UIImage?
    var itemUncheckedImage : UIImage?
    var itemColor : UIColor?
    var itemFont : UIFont?
    
}

public class YBTextPicker: UIViewController {

    //MARK:- Constants
    let animationDuration = 0.3
    let shadowAmount:CGFloat = 0.6
    let shadowColor = UIColor.black
    
    //MARK:- IBOutlets
    @IBOutlet var tapToDismissGesture: UITapGestureRecognizer!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK:- Constraints
    @IBOutlet weak var paddingToTop: NSLayoutConstraint!
    @IBOutlet weak var paddingToBottom: NSLayoutConstraint!
    @IBOutlet weak var paddingToLeft: NSLayoutConstraint!
    @IBOutlet weak var paddingToRight: NSLayoutConstraint!
    
    //MARK:- Properties
    var arrAllValues = [YBTextPickerDataModel]()
    var arrValues = [YBTextPickerDataModel]()
    
    public var selectedValues = [YBTextPickerDataModel]()
    
    public var preSelectedValues = [String]()
    
    public var allowMultipleSelection = false
    public var tapToDismiss = true
    var animation = YBTextPickerAnimation.FromBottom
    var appearanceManager : YBTextPickerAppearanceManager?
    
    var completionHandler : ((_ selectedIndexes:[Int], _ selectedValues:[String])->Void)?
    var cancelHandler : (()->Void)?
    
    public init (
        with items : [String],
        appearance : YBTextPickerAppearanceManager?,
        onCompletion : @escaping (_ selectedIndexes:[Int], _ selectedValues:[String]) -> Void,
        onCancel : @escaping () -> Void
        ){
        
        let bundle = Bundle(for: YBTextPicker.self)
        
        super.init(nibName: "YBTextPicker", bundle: bundle)
        
        for (index,textItem) in items.enumerated(){
            let dataModel = YBTextPickerDataModel.init(textItem, index)
            arrAllValues.append(dataModel)
        }
        
        self.arrValues = arrAllValues.map{$0}
        
        self.appearanceManager = appearance
        
        self.completionHandler = onCompletion
        self.cancelHandler = onCancel
        
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(withAnimation animationType:YBTextPickerAnimation){
        self.animation = animationType
        if let topController = UIApplication.topViewController() {
            var shouldAnimate = false
            if animation == .FromBottom{
                shouldAnimate = true
            }
            topController.present(self, animated: shouldAnimate, completion: nil)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: animationDuration, animations: {
            self.shadowView.backgroundColor = self.shadowColor.withAlphaComponent(self.shadowAmount)
            
            if self.animation == .Fade{
                self.containerView.alpha = 1
            }
            
        })
    }
    
    func setupLayout(){
        
        let bundle = Bundle(for: YBTextPicker.self)
        tableView.register(UINib.init(nibName: "YBTextPickerCell", bundle: bundle), forCellReuseIdentifier: "YBTextPickerCell")
        
        if animation == .Fade{
            containerView.alpha = 0
        }
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
        
        selectedValues = arrAllValues.filter{
            preSelectedValues.contains($0.title)
        }
        
        tapToDismissGesture.isEnabled = tapToDismiss
        
        if let appearance = self.appearanceManager{
            if let pTitle = appearance.pickerTitle{
                titleLabel.text = pTitle
            }
            
            if let tFont = appearance.titleFont{
                titleLabel.font = tFont
            }
            
            if let tBGColor = appearance.titleBackground{
                titleLabel.backgroundColor = tBGColor
            }
            
            if let tColor = appearance.titleTextColor{
                titleLabel.textColor = tColor
            }
            
            if let sFont = appearance.searchBarFont{
                if let textFieldInsideSearchBar = txtSearch.value(forKey: "searchField") as? UITextField{
                    textFieldInsideSearchBar.font = sFont
                }
            }
            
            if let sPlaceholder = appearance.searchBarPlaceholder{
                txtSearch.placeholder = sPlaceholder
            }
            
            if let cBtnTitle = appearance.closeButtonTitle{
                btnClose.setTitle(cBtnTitle, for: .normal)
            }
            
            if let cBtnColor = appearance.closeButtonColor{
                btnClose.setTitleColor(cBtnColor, for: .normal)
            }
            
            if let cBtnFont = appearance.closeButtonFont{
                btnClose.titleLabel?.font = cBtnFont
            }
            
            if let dBtnTitle = appearance.doneButtonTitle{
                btnDone.setTitle(dBtnTitle, for: .normal)
            }
            
            if let dBtnColor = appearance.doneButtonColor{
                btnDone.setTitleColor(dBtnColor, for: .normal)
            }
            
            if let dBtnFont = appearance.doneButtonFont{
                btnDone.titleLabel?.font = dBtnFont
            }
        }
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
        case .pad:
            paddingToTop.constant = 190
            paddingToBottom.constant = 180
            paddingToLeft.constant = 135
            paddingToRight.constant = 135
        case .phone:
            paddingToTop.constant = 50
            paddingToBottom.constant = 60
            paddingToLeft.constant = 16
            paddingToRight.constant = 16
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
    }
    
    //MARK:- Button Clicks
    @IBAction func closeAction(_ sender: Any) {
        cancelHandler?()
        closePicker()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        let indexes = selectedValues.map{$0.identity!}
        let values = selectedValues.map{$0.title!}
        completionHandler?(indexes, values)
        
        closePicker()
    }
    
    func closePicker(){
        UIView.animate(withDuration: animationDuration, animations: {
            self.shadowView.backgroundColor = .clear
            
            if self.animation == .Fade{
                self.containerView.alpha = 0
            }
            
        }) { (completed) in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

}

extension YBTextPicker : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            arrValues = arrAllValues.map{ $0 }
        }else{
            
            arrValues = arrAllValues.filter{
                $0.title.lowercased().contains(searchText.lowercased())
            }
            
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

extension YBTextPicker : UITableViewDataSource, UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YBTextPickerCell", for: indexPath) as! YBTextPickerCell
        
        let dataModel = arrValues[indexPath.row]
        
        
        cell.lblItem.text = dataModel.title
        
        var chkImage:UIImage? = nil
        
        let bundle = Bundle(for: YBTextPicker.self)
        
        if selectedValues.contains(dataModel)
        {
            chkImage = UIImage(named: "YBTextPicker_checked", in: bundle, compatibleWith: nil)
        }else{
            chkImage = UIImage(named: "YBTextPicker_unchecked", in: bundle, compatibleWith: nil)
        }
        
        cell.widthOfImgTrailingCheck.constant = 0.0
        
        if let appearance = self.appearanceManager{
            if let itFont = appearance.itemFont{
                cell.lblItem.font = itFont
            }
            if let itColor = appearance.itemColor{
                cell.lblItem.textColor = itColor
            }
            
            if let itCheckedImage = appearance.itemCheckedImage{
                if selectedValues.contains(dataModel)
                {
                    chkImage = itCheckedImage
                }
            }
            if let itUncheckedImage = appearance.itemUncheckedImage{
                if selectedValues.contains(dataModel) == false
                {
                    chkImage = itUncheckedImage
                }
            }
            if let checkMarkPosition = appearance.checkMarkPosition{
                let checkMarkWidth:CGFloat = 26.0
                if checkMarkPosition == .Right{
                    cell.widthOfImgTrailingCheck.constant = checkMarkWidth
                    cell.widthOfImgLeadingCheck.constant = 0
                }else{
                    cell.widthOfImgLeadingCheck.constant = checkMarkWidth
                    cell.widthOfImgTrailingCheck.constant = 0
                }
            }
        }
        
        cell.imgTrailingCheck.image = chkImage
        cell.imgLeadingCheck.image = chkImage
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrValues.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowMultipleSelection == false {
            selectedValues = [YBTextPickerDataModel]()
        }

        let dataModel = arrValues[indexPath.row]
        if selectedValues.contains(dataModel){
            selectedValues.removeAll{ $0 == dataModel }
        }else{
            selectedValues.append(dataModel)
        }
        
        var cellsToReload = [IndexPath]()
        if allowMultipleSelection == false {
            cellsToReload = tableView.indexPathsForVisibleRows!
            //RELOAD ALL VISIBLE CELLS SO THAT PREVIOUSLY SELECTED CELL GETS DE-SELECTED
        }else{
            cellsToReload = [indexPath]
            //SELECT OR DE-SELECT CURRENT CELL (NO NEED TO RELOAD OTHER CELLS)
        }
        tableView.reloadRows(at: cellsToReload, with: .fade)
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
