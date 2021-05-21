//
//  ALBymSettingVC.swift
//  ALBymAddLineBreak
//
//  Created by JOJO on 2021/5/18.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit


let AppName: String = "Like Font"
let purchaseUrl = ""
let TermsofuseURLStr = "http://industrious-noise.surge.sh/Terms_of_use.html"
let PrivacyPolicyURLStr = "http://profuse-parent.surge.sh/Privacy_Agreement.html"

let feedbackEmail: String = "jus7just1n@yandex.com"
let AppAppStoreID: String = ""




class ALBymSettingView: UIView {

    var upVC: ALBymMainVC?
    
    let contentBgView = UIView()
    let contentBgImgV = UIImageView(image: UIImage(named: "home_text_bg_ic"))
    let privacyBtn = UIButton(type: .custom)
    let termsBtn = UIButton(type: .custom)
    let feedbackBtn = UIButton(type: .custom)
    let loginBtn = UIButton(type: .custom)
    let logoutBtn = UIButton(type: .custom)
    let userNameLabel = UILabel()
    let userIconImgV = UIImageView(image: UIImage(named: "profile_user_ic"))
    var showLoginViewBlock: (()->Void)?
    
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateUserAccountStatus()
    }

    func setupView() {
        backgroundColor = .clear

        addSubview(contentBgView)
        let left: CGFloat = 38
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
        // login
        loginBtn.setTitleColor(UIColor(hexString: "#232323"), for: .normal)
        loginBtn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 16)
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.backgroundColor = UIColor(hexString: "#FFFFFF")
        loginBtn.layer.cornerRadius = 25
        loginBtn.layer.borderWidth = 4
        loginBtn.layer.borderColor = UIColor.black.cgColor
        
        contentBgView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.width.equalTo(182)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-38)
        }
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        // log out
        logoutBtn.setTitleColor(UIColor(hexString: "#232323"), for: .normal)
        logoutBtn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 16)
        logoutBtn.setTitle("Log out", for: .normal)
        logoutBtn.backgroundColor = UIColor(hexString: "#FFFFFF")
        logoutBtn.layer.cornerRadius = 25
        logoutBtn.layer.borderWidth = 4
        logoutBtn.layer.borderColor = UIColor.black.cgColor
        
        contentBgView.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints {
            $0.width.equalTo(182)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-38)
        }
        logoutBtn.addTarget(self, action: #selector(logoutBtnClick(sender:)), for: .touchUpInside)
        
        // privacyBtn
        privacyBtn.backgroundColor = .clear
        privacyBtn.setTitleColor(UIColor(hexString: "#232323"), for: .normal)
        privacyBtn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        privacyBtn.setTitle("Privacy Policy", for: .normal)
        contentBgView.addSubview(privacyBtn)
        privacyBtn.snp.makeConstraints {
            $0.width.equalTo(155)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(loginBtn.snp.top).offset(-32)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        //
        // termsBtn
        termsBtn.backgroundColor = .clear
        termsBtn.setTitleColor(UIColor(hexString: "#232323"), for: .normal)
        termsBtn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        termsBtn.setTitle("Term of use", for: .normal)
        contentBgView.addSubview(termsBtn)
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(155)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(privacyBtn.snp.top).offset(-28)
        }
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
        // termsBtn
        feedbackBtn.backgroundColor = .clear
        feedbackBtn.setTitleColor(UIColor(hexString: "#232323"), for: .normal)
        feedbackBtn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        feedbackBtn.setTitle("Feedback", for: .normal)
        contentBgView.addSubview(feedbackBtn)
        feedbackBtn.snp.makeConstraints {
            $0.width.equalTo(155)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(termsBtn.snp.top).offset(-28)
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        //
        // user name label
        contentBgView.addSubview(userNameLabel)
        userNameLabel.textAlignment = .center
        userNameLabel.text = ""
        userNameLabel.textColor = UIColor(hexString: "#232323")
        userNameLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(35)
            $0.bottom.equalTo(feedbackBtn.snp.top).offset(-20)
        }
        // user icon imgV
        
        contentBgView.addSubview(userIconImgV)
        userIconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(40)
            $0.bottom.equalTo(userNameLabel.snp.top).offset(-8)
        }
        userIconImgV.contentMode = .scaleAspectFit
        
    }

}


extension ALBymSettingView {
    @objc func privacyBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
    }
    
    @objc func termsBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: TermsofuseURLStr)
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
        
    }
    
    @objc func logoutBtnClick(sender: UIButton) {
        LoginManage.shared.logout()
        updateUserAccountStatus()
    }
    
    func showLoginVC() {
        if LoginManage.currentLoginUser() == nil {
            showLoginViewBlock?()
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginManage.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : "Tourist"
            userNameLabel.isHidden = false
            logoutBtn.isHidden = false
            loginBtn.isHidden = true
            userIconImgV.isHidden = false
            privacyBtn.snp.remakeConstraints {
                $0.width.equalTo(155)
                $0.height.equalTo(45)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(loginBtn.snp.top).offset(-32)
            }
        } else {
            userNameLabel.text = ""
            userNameLabel.isHidden = true
            userIconImgV.isHidden = true
            logoutBtn.isHidden = true
            loginBtn.isHidden = false
            privacyBtn.snp.remakeConstraints {
                $0.width.equalTo(155)
                $0.height.equalTo(45)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(loginBtn.snp.top).offset(-64)
            }
        }
    }
}

extension ALBymSettingView: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
        controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
           
           //打开界面
        self.upVC?.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}

extension UIDevice {
  
   ///The device model name, e.g. "iPhone 6s", "iPhone SE", etc
   var modelName: String {
       var systemInfo = utsname()
       uname(&systemInfo)
      
       let machineMirror = Mirror(reflecting: systemInfo.machine)
       let identifier = machineMirror.children.reduce("") { identifier, element in
           guard let value = element.value as? Int8, value != 0 else {
               return identifier
           }
           return identifier + String(UnicodeScalar(UInt8(value)))
       }
      
       switch identifier {
           case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iphone 4"
           case "iPhone4,1":                               return "iPhone 4s"
           case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
           case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
           case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
           case "iPhone7,2":                               return "iPhone 6"
           case "iPhone7,1":                               return "iPhone 6 Plus"
           case "iPhone8,1":                               return "iPhone 6s"
           case "iPhone8,2":                               return "iPhone 6s Plus"
           case "iPhone8,4":                               return "iPhone SE"
           case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
           case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
           case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
           case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
           case "iPhone10,3", "iPhone10,6":                return "iPhone X"
           case "iPhone11,2":                              return "iPhone XS"
           case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
           case "iPhone11,8":                              return "iPhone XR"
           case "iPhone12,1":                              return "iPhone 11"
           case "iPhone12,3":                              return "iPhone 11 Pro"
           case "iPhone12,5":                              return "iPhone 11 Pro Max"
           case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
           case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
           case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
           case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
           case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
           case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
           case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
           case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
           case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
           case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
           case "AppleTV5,3":                              return "Apple TV"
           case "i386", "x86_64":                          return "Simulator"
           default:                                        return identifier
       }
   }
}
