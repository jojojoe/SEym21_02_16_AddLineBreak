//
//  ALBymHomeView.swift
//  ALBymAddLineBreak
//
//  Created by JOJO on 2021/5/18.
//

import UIKit
import Alertift
import SwifterSwift
import DeviceKit

enum ALBymTextFontStyle {
    case regular
    case bold
    case italic
}

class ALBymHomeView: UIView, UITextFieldDelegate {
    var upVC: ALBymMainVC?
    let contentBgView = UIView()
    let contentBgImgV = UIImageView(image: UIImage(named: "home_text_bg_ic"))
    let copyBtn = UIButton(type: .custom)
    let contentTextView = CustomTextField()
    
    var isEditingStatus: Bool = false
    
    
    let textToolBar = ALBymTextToolBar()
    let specialTextView = ALBymSpecailTextView()
    
    var fontType: ALBymTextFontStyle = .regular
    var currentRegularText: String = ""
    var currentStyleText: String = ""
    
    var isShowingSpecialTextBar: Bool = false
    var startPosition: UITextPosition?
    var showCoinViewBlock: (()->Void)?
    var showCopySuccessStatusBlock: (()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupDefaultGuideTextStatus()
        registKeyboradNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        clipsToBounds = true
        addSubview(contentBgView)
        
        let width: CGFloat = 318
            //(UIScreen.main.bounds.width - left * 2)
        contentBgView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo((44.0/30.0) * width)
        }
        //
        contentBgImgV.contentMode = .scaleAspectFill
        contentBgView.addSubview(contentBgImgV)
        contentBgImgV.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        //
        
        copyBtn.setTitle("Copy", for: .normal)
        copyBtn.setTitleColor(.black, for: .normal)
        copyBtn.titleLabel?.font = UIFont(name: "Lexend-ExtraBold", size: 16)
        copyBtn.backgroundColor = .white
        copyBtn.layer.cornerRadius = 24
        copyBtn.layer.masksToBounds = true
        copyBtn.layer.borderWidth = 4
        copyBtn.layer.borderColor = UIColor.black.cgColor
        contentBgView.addSubview(copyBtn)
        copyBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-30)
            $0.width.equalTo(182)
            $0.height.equalTo(48)
        }
        copyBtn.addTarget(self, action: #selector(copyBtnClick(sender:)), for: .touchUpInside)
        //
        contentTextView.isUserInteractionEnabled = true
        contentTextView.delegate = self
        contentTextView.backgroundColor = .clear
        contentBgView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(40)
            $0.left.equalTo(24)
            $0.right.equalTo(-30)
            $0.bottom.equalTo(copyBtn.snp.top).offset(-24)
        }
        contentTextView.textAlignment = .left
        contentTextView.textColor = UIColor(hexString: "#232323")
        //
         
        
        //
        
        
        textToolBar.alpha = 0
        addSubview(textToolBar)
        textToolBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(80)
        }
        textToolBar.boldBtnClickBlock = {
            [weak self] isOpen in
            guard let `self` = self else {return}
            if isOpen {
                self.fontType = .bold
            } else {
                self.fontType = .regular
            }
//            self.specialTextView.alpha = 0
            self.changeTextViewFontType()
            
            
        }
        textToolBar.italicBtnClickBlock = {
            [weak self] isOpen in
            guard let `self` = self else {return}
            if isOpen {
                self.fontType = .italic
            } else {
                self.fontType = .regular
            }
//            self.specialTextView.alpha = 0
            self.changeTextViewFontType()
        }
        textToolBar.specialBtnClickBlock = {
            [weak self] isOpen in
            guard let `self` = self else {return}
            if isOpen == true {
                self.specialTextView.alpha = 1
                self.isShowingSpecialTextBar = true
                self.contentTextView.resignFirstResponder()
                
            } else {
                 
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    UIView.animate(withDuration: 0.35) {
                        self.specialTextView.alpha = 0
                    }
                }
                
                self.isShowingSpecialTextBar = false
                self.contentTextView.becomeFirstResponder()
            }
            
        }
        textToolBar.keyboradOffBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            if self.isShowingSpecialTextBar {
                
                self.isShowingSpecialTextBar = false
                self.textToolBar.snp.remakeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(56)
                    $0.bottom.equalToSuperview().offset(80)
                }
                self.specialTextView.snp.remakeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.top.equalTo(self.textToolBar.snp.bottom)
                    
                    $0.bottom.equalTo(self.specialTextView.superview!.snp.bottom)
                }
                UIView.animate(withDuration: 0.35) {
                    self.specialTextView.alpha = 0
                    self.textToolBar.alpha = 0
                    self.layoutIfNeeded()
                }
                
            } else {
                self.endInputText()
            }
            
        }

        
    }
    func setupSpecialToolView(fsuperView: UIView) {
        
        specialTextView.alpha = 0
        fsuperView.addSubview(specialTextView)
        specialTextView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(textToolBar.snp.bottom)
            $0.bottom.equalTo(fsuperView.snp.bottom)
        }
        specialTextView.didClickSpecialStrBlock = {
            [weak self] string in
            guard let `self` = self else {return}
            let location = self.contentTextView.selectedRange.location
            if let content = self.contentTextView.text {
                let leftStr = content.slicing(from: 0, length: location) ?? ""
                let rightStr = content.slicing(from: location, length: content.count - location) ?? ""
                let result = "\(leftStr)\(string)\(rightStr)"
                self.contentTextView.text = result
            }
            
        }
        
    }
    
    func setupDefaultGuideTextStatus() {
        isEditingStatus = false
        contentTextView.isUserInteractionEnabled = false
        copyBtn.setTitle("Edit", for: .normal)
        contentTextView.font = UIFont(name: "Lexend-SemiBold", size: 16)
        contentTextView.text = """
            How to Use:
            
            1. Enter the caption;
            2. Choose your favorite font style, italic or bold, etc;
            3. Click  "Copy"  button, successfully copied to the clipboard;
            4. Paste your text into Instagram!
            """
        
        //
         
        
    }
    
    func setupEditingStatus() {
        isEditingStatus = true
        contentTextView.isUserInteractionEnabled = true
        copyBtn.setTitle("Copy", for: .normal)
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.text = ""
        contentTextView.becomeFirstResponder()
        
    }
    
    func endInputText() {
        contentTextView.resignFirstResponder()
    }
    
    func changeTextViewFontType() {
        
        let content = ALFontManager.default.processReplaceText(contentStr: contentTextView.text, targetType: fontType)
        contentTextView.text = content
        
    }
    
    
}

extension ALBymHomeView {
    
    func registKeyboradNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        print(keyboardHeight)
        
        /*
         case .iPhoneX: return 5.8
         case .iPhoneXS: return 5.8
         case .iPhoneXSMax: return 6.5
         case .iPhoneXR: return 6.1
         case .iPhone11: return 6.1
         case .iPhone11Pro: return 5.8
         case .iPhone11ProMax: return 6.5
         case .iPhoneSE2: return 4.7
         case .iPhone12: return 6.1
         case .iPhone12Mini: return 5.4
         case .iPhone12Pro: return 6.1
         case .iPhone12ProMax: return 6.7
         
         */
        var offSetDevice: CGFloat = 0
        
        if Device.current.diagonal == 4.7 {
            // 6s
            offSetDevice = 10
        } else if Device.current.diagonal == 5.4 {
            //iPhone12Mini
            offSetDevice = 0
        } else if Device.current.diagonal == 5.5 {
            // plus
            offSetDevice = 0
        } else if Device.current.diagonal == 5.8 {
            // iPhoneX
            offSetDevice = 5
        }else if Device.current.diagonal == 6.1  {
            // iPhone11
            offSetDevice = 28
        } else if Device.current.diagonal == 6.5  {
            // iPhone11ProMax
            offSetDevice = 28
        } else if Device.current.diagonal == 6.7  {
            // iPhone12ProMax
            offSetDevice = 28
        } else if Device.current.diagonal >= 7.9 {
            // iPad
            offSetDevice = 10
        } else {
            offSetDevice = 0
        }
        
        
        let bottomOffset = UIScreen.main.bounds.size.height - self.frame.maxY - offSetDevice
        
        debugPrint("bottomOffset = \(bottomOffset)")
        textToolBar.alpha = 1
        textToolBar.snp.remakeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-bottomOffset)
        }
        
        textToolBar.specialBtn.isSelected = false
        
        specialTextView.snp.remakeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(textToolBar.snp.bottom)
            $0.bottom.equalTo(self.specialTextView.superview!.snp.bottom)
        }
        UIView.animate(withDuration: 0.35) {
            self.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.animate(withDuration: 0.35) {
                self.specialTextView.alpha = 0
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if !isShowingSpecialTextBar {
            let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
            print(keyboardHeight)
            textToolBar.alpha = 0
            textToolBar.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(56)
                $0.bottom.equalToSuperview().offset(80)
            }
            specialTextView.alpha = 0
            specialTextView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(textToolBar.snp.bottom)
                $0.bottom.equalTo(self.specialTextView.superview!.snp.bottom)
            }
            UIView.animate(withDuration: 0.35) {
                self.layoutIfNeeded()
            }
        }
        
        
    }
}

extension ALBymHomeView {
    
    
}

extension ALBymHomeView {
    @objc func copyBtnClick(sender: UIButton) {
        if isEditingStatus == true {
            if contentTextView.text == "" {
                Alertift.alert(title: "Nothing at all.", message: "Please enter text first.")
                    .action(.cancel("OK"))
                    .show(on: self.upVC, completion: nil)
                return
            }
            
            if textToolBar.boldBtn.isSelected == false && textToolBar.italicBtn.isSelected == false {
                // free
                UIPasteboard.general.string = contentTextView.text
                showCopySuccessStatusBlock?()
            } else {
                // paid
                showCoinViewBlock?()
                
            }
            
            
            
        } else {
            setupEditingStatus()
        }
    }
    
}

extension ALBymHomeView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        debugPrint("range = \(range)")
        debugPrint("replacementText = \(text)")
        debugPrint("textView.text = \(String(describing: textView.text))")
//        if text == "\n" {
//            textView.resignFirstResponder()
//            if let contentText = contentTextView.text {
//
//            }
//            return false
//        }
        startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location + text.count)
        
        
        
        
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        debugPrint("textViewDidChange = \(textView.text)")
        self.changeTextViewFontType()
        debugPrint("textViewDidChange after = \(textView.text)")
        if let start = startPosition, let end = textView.position(from: start, offset: 0) {
//            textView.textRange(from: start, to: end)
            textView.selectedTextRange = textView.textRange(from: start, to: end)
        }
        
         
        
    }
    
}


class ALBymTextToolBar: UIView {
    let boldBtn = UIButton(type: .custom)
    let italicBtn = UIButton(type: .custom)
    let specialBtn = UIButton(type: .custom)
    let keyboradOffBtn = UIButton(type: .custom)
    
    var boldBtnClickBlock: ((Bool)->Void)?
    var italicBtnClickBlock: ((Bool)->Void)?
    var specialBtnClickBlock: ((Bool)->Void)?
    var keyboradOffBtnClickBlock: (()->Void)?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.white
        // bold btn
        //    𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇
        //    𝒶𝒷𝒸𝒹𝑒𝒻𝑔𝒽𝒾𝒿𝓀𝓁𝓂𝓃𝑜𝓅𝓆𝓇𝓈𝓉𝓊𝓋𝓌𝓍𝓎𝓏
        //    𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭
        //    𝒜𝐵𝒞𝒟𝐸𝐹𝒢𝐻𝐼𝒥𝒦𝐿𝑀𝒩𝒪𝒫𝒬𝑅𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵
        // 𝐼𝓁𝒶𝓁𝒾𝒸
        addSubview(boldBtn)
        boldBtn.setTitle("𝗕𝗼𝗹𝗱", for: .normal)
        boldBtn.addTarget(self, action: #selector(boldBtnClick(sender:)), for: .touchUpInside)
        boldBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(22)
            $0.width.equalTo(80)
            $0.height.equalTo(34)
        }
        boldBtn.setTitleColor(UIColor.black, for: .normal)
        boldBtn.setTitleColor(UIColor.white, for: .selected)
        boldBtn.setBackgroundImage(UIImage(color: UIColor.white, size: CGSize(width: 80, height: 34)), for: .normal)
        boldBtn.setBackgroundImage(UIImage(color: UIColor.black, size: CGSize(width: 80, height: 34)), for: .selected)
        
        boldBtn.layer.borderWidth = 2
        boldBtn.layer.borderColor = UIColor.black.cgColor
        boldBtn.layer.masksToBounds = true
        boldBtn.layer.cornerRadius = 17
        let boldVipImgV = UIImageView(image: UIImage(named: "right_up_pro_ic"))
        addSubview(boldVipImgV)
        boldVipImgV.snp.makeConstraints {
            $0.right.equalTo(boldBtn).offset(5)
            $0.top.equalTo(boldBtn).offset(-5)
            $0.width.height.equalTo(20)
        }
        
        // italicBtn
        addSubview(italicBtn)
        italicBtn.setTitle("𝐼𝓁𝒶𝓁𝒾𝒸", for: .normal)
        italicBtn.addTarget(self, action: #selector(italicBtnClick(sender:)), for: .touchUpInside)
        italicBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(boldBtn.snp.right).offset(18)
            $0.width.equalTo(80)
            $0.height.equalTo(34)
        }
        italicBtn.setTitleColor(UIColor.black, for: .normal)
        italicBtn.setTitleColor(UIColor.white, for: .selected)
        italicBtn.setBackgroundImage(UIImage(color: UIColor.white, size: CGSize(width: 80, height: 34)), for: .normal)
        italicBtn.setBackgroundImage(UIImage(color: UIColor.black, size: CGSize(width: 80, height: 34)), for: .selected)
        
        italicBtn.layer.borderWidth = 2
        italicBtn.layer.borderColor = UIColor.black.cgColor
        italicBtn.layer.masksToBounds = true
        italicBtn.layer.cornerRadius = 17
        let italicVipImgV = UIImageView(image: UIImage(named: "right_up_pro_ic"))
        addSubview(italicVipImgV)
        italicVipImgV.snp.makeConstraints {
            $0.right.equalTo(italicBtn).offset(5)
            $0.top.equalTo(italicBtn).offset(-5)
            $0.width.height.equalTo(20)
        }
        //
        addSubview(specialBtn)
        specialBtn.setTitle("∴☆…·", for: .normal)
        specialBtn.addTarget(self, action: #selector(specialBtnClick(sender:)), for: .touchUpInside)
        specialBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(italicBtn.snp.right).offset(18)
            $0.width.equalTo(80)
            $0.height.equalTo(34)
        }
        specialBtn.setTitleColor(UIColor.black, for: .normal)
        specialBtn.setTitleColor(UIColor.white, for: .selected)
        specialBtn.setBackgroundImage(UIImage(color: UIColor.white, size: CGSize(width: 80, height: 34)), for: .normal)
        specialBtn.setBackgroundImage(UIImage(color: UIColor.black, size: CGSize(width: 80, height: 34)), for: .selected)
        
        specialBtn.layer.borderWidth = 2
        specialBtn.layer.borderColor = UIColor.black.cgColor
        specialBtn.layer.masksToBounds = true
        specialBtn.layer.cornerRadius = 17
        let specialVipImgV = UIImageView(image: UIImage(named: "right_up_pro_ic"))
        addSubview(specialVipImgV)
        specialVipImgV.snp.makeConstraints {
            $0.right.equalTo(specialBtn).offset(5)
            $0.top.equalTo(specialBtn).offset(-5)
            $0.width.height.equalTo(20)
        }
        
        // keyboradOffBtn
        addSubview(keyboradOffBtn)
        keyboradOffBtn.setImage(UIImage(named: "keyboard_down_ic"), for: .normal)
        keyboradOffBtn.snp.makeConstraints {
            $0.right.equalTo(-18)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        keyboradOffBtn.addTarget(self, action: #selector(keyboradOffBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    @objc func boldBtnClick(sender: UIButton) {
        boldBtn.isSelected = !boldBtn.isSelected
        italicBtn.isSelected = false
//        specialBtn.isSelected = false
        
        boldBtnClickBlock?(boldBtn.isSelected)
    }
    @objc func italicBtnClick(sender: UIButton) {
        italicBtn.isSelected = !italicBtn.isSelected
        boldBtn.isSelected = false
//        specialBtn.isSelected = false
        
        italicBtnClickBlock?(italicBtn.isSelected)
    }
    @objc func specialBtnClick(sender: UIButton) {
        specialBtn.isSelected = !specialBtn.isSelected
//        boldBtn.isSelected = false
//        italicBtn.isSelected = false
        
        specialBtnClickBlock?(specialBtn.isSelected)
    }
    @objc func keyboradOffBtnClick(sender: UIButton) {
        specialBtn.isSelected = false
        keyboradOffBtnClickBlock?()
    }
    
}

class ALBymSpecailTextView: UIView {
    
    var collection: UICollectionView!
    var didClickSpecialStrBlock: ((String)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: ALBymSpecailTextViewCell.self)
    }
    
     
    
    class ALBymSpecailTextViewCell: UICollectionViewCell {
        let contentImgV = UIImageView()
        let contentTextLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupView() {
            contentImgV.contentMode = .scaleAspectFill
            contentImgV.clipsToBounds = true
            contentView.addSubview(contentImgV)
            contentImgV.snp.makeConstraints {
                $0.top.right.bottom.left.equalToSuperview()
            }
            //
            contentTextLabel.font = UIFont.systemFont(ofSize: 14)
            contentTextLabel.textColor = .black
            contentTextLabel.textAlignment = .center
            contentTextLabel.adjustsFontSizeToFitWidth = true
            contentTextLabel.numberOfLines = 1
            contentView.addSubview(contentTextLabel)
            contentTextLabel.snp.makeConstraints {
                $0.left.right.bottom.top.equalToSuperview()
            }
            
        }
    }
    
}

extension ALBymSpecailTextView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ALBymSpecailTextViewCell.self, for: indexPath)
        let item = ALFontManager.default.specialStringList[indexPath.item]
        cell.contentTextLabel.text = item
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ALFontManager.default.specialStringList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension ALBymSpecailTextView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ALBymSpecailTextView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = ALFontManager.default.specialStringList[indexPath.item]
        
        didClickSpecialStrBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class CustomTextField: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
