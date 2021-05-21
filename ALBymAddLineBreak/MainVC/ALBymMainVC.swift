//
//  ALBymMainVC.swift
//  ALBymAddLineBreak
//
//  Created by JOJO on 2021/5/18.
//

import UIKit

class ALBymMainVC: UIViewController {

    let topBgView = UIView()
    let settingView = ALBymSettingView()
    let storeView = ALBStoreView()
    let homeView = ALBymHomeView()
    let storeBtn = ALBymBottomBtn(frame: .zero, icon: UIImage(named: "store_s_ic")!, name: "Store")
    let homeBtn = ALBymBottomBtn(frame: .zero, icon: UIImage(named: "home_s_ic")!, name: "Home")
    let settingBtn = ALBymBottomBtn(frame: .zero, icon: UIImage(named: "setting_s_ic")!, name: "Setting")
    
    let coinAlertBgview = UIView()
    var loginAppleView: UIView?
    let successCopyBgView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContentView()
        setupAPLoginView()
        setupCoinCostAlertView()
        setupCopySuccessView()
    }
     
}

extension ALBymMainVC {
    func setupView() {
        view.backgroundColor = UIColor(hexString: "#DFFE04")
        //
        let bottomBar = UIView()
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            $0.width.equalTo(312)
            $0.height.equalTo(74)
            $0.centerX.equalToSuperview()
        }
        let bottomBarBgImgV = UIImageView(image: UIImage(named: "store_bg_ic"))
        bottomBarBgImgV.contentMode = .scaleToFill
        bottomBar.addSubview(bottomBarBgImgV)
        bottomBarBgImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        //
        storeBtn.updateStatus(isSelect: false)
        bottomBar.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(35)
        }
        storeBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.storeBtn.updateStatus(isSelect: true)
            self.homeBtn.updateStatus(isSelect: false)
            self.settingBtn.updateStatus(isSelect: false)
            self.storeView.isHidden = false
            self.homeView.isHidden = true
            self.settingView.isHidden = true
        }
        //
        
        homeBtn.updateStatus(isSelect: true)
        bottomBar.addSubview(homeBtn)
        homeBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(40)
            $0.width.equalTo(50)
            $0.height.equalTo(35)
        }
        homeBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.storeBtn.updateStatus(isSelect: false)
            self.homeBtn.updateStatus(isSelect: true)
            self.settingBtn.updateStatus(isSelect: false)
            self.storeView.isHidden = true
            self.homeView.isHidden = false
            self.settingView.isHidden = true
        }
        
        settingBtn.updateStatus(isSelect: false)
        bottomBar.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-40)
            $0.width.equalTo(50)
            $0.height.equalTo(35)
        }
        settingBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.storeBtn.updateStatus(isSelect: false)
            self.homeBtn.updateStatus(isSelect: false)
            self.settingBtn.updateStatus(isSelect: true)
            self.storeView.isHidden = true
            self.homeView.isHidden = true
            self.settingView.isHidden = false
        }
        
        //
        
        
        view.addSubview(topBgView)
        topBgView.backgroundColor = .clear
        topBgView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top).offset(-10)
        }
        
    }
    
    func setupContentView() {
        
        settingView.upVC = self
        topBgView.addSubview(settingView)
        settingView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        settingView.isHidden = true
        settingView.showLoginViewBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.loginAppleView?.alpha = 1
        }
        //

        storeView.upVC = self
        topBgView.addSubview(storeView)
        storeView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        storeView.isHidden = true
        //

        homeView.upVC = self
        topBgView.addSubview(homeView)
        homeView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        homeView.setupSpecialToolView(fsuperView: self.view)
         
        homeView.showCoinViewBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35) {
                    self.coinAlertBgview.alpha = 1
                }
            }
        }
        homeView.showCopySuccessStatusBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showCopySuccessStatus()
            }
        }
         
    }

    
    func setupAPLoginView() {
        let loginVC = LoginManage.shared.obtainVC()
        LoginManage.shared.loginCompletionBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.loginAppleView?.alpha = 0
            self.settingView.updateUserAccountStatus()
        }
        self.addChild(loginVC)
        self.view.addSubview(loginVC.view)
        loginAppleView = loginVC.view
        loginVC.view.alpha = 0
        loginVC.view.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        if let vc = loginVC as? APLoginVC {
            vc.coinAlertCloseBtnClickBlock = {
                [weak self] in
                guard let `self` = self else {return}
                self.loginAppleView?.alpha = 0
            }
        }
        
    }

    func setupCoinCostAlertView() {
        coinAlertBgview.alpha = 0
        view.addSubview(coinAlertBgview)
        coinAlertBgview.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        coinAlertBgview.backgroundColor = .clear
        //
        let closebuttonf = UIButton()
        closebuttonf.alpha = 1
        closebuttonf.setImage(UIImage(named: "splash_icon_close"), for: .normal)
        closebuttonf.addTarget(self, action: #selector(closebuttonfClickClick(sender:)), for: .touchUpInside)
        coinAlertBgview.addSubview(closebuttonf)
        closebuttonf.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        //
        let coinAlertBottomView = UIView()
        coinAlertBgview.addSubview(coinAlertBottomView)
        coinAlertBottomView.backgroundColor = .white
        coinAlertBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        //
        let label = UILabel()
        label.font = UIFont(name: "Lexend-Bold", size: 16)
        label.textColor = UIColor(hexString: "#232323")

        label.text = "Copy the text, \(CoinManager.default.coinCostCount) coins will be deducted."
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        coinAlertBottomView.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalTo(45)
            $0.height.equalTo(44)
            
        }
        //
        let icon = UIImageView(image: UIImage(named: "popup_vip_ic"))
        icon.contentMode = .scaleAspectFit
        coinAlertBottomView.addSubview(icon)
        icon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(label.snp.top).offset(-16)
            $0.width.height.equalTo(64)
        }
        //
        let closeBtn = UIButton(type: .custom)
        coinAlertBottomView.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named: "popup_down_ic"), for: .normal)
        closeBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-4)
            $0.top.equalToSuperview().offset(4)
            $0.width.height.equalTo(34)
        }
        closeBtn.addTarget(self, action: #selector(coinAlertCloseBtnClick(sender:)), for: .touchUpInside)
        //
        let okBtn = UIButton(type: .custom)
        coinAlertBottomView.addSubview(okBtn)
        okBtn.layer.cornerRadius = 23
        okBtn.setTitle("OK", for: .normal)
        okBtn.setTitleColor(UIColor(hexString: "#232323"), for: .normal)
        okBtn.layer.borderWidth = 4
        okBtn.layer.borderColor = UIColor.black.cgColor
        okBtn.snp.makeConstraints {
            $0.width.equalTo(178)
            $0.height.equalTo(46)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(33)
        }
        okBtn.addTarget(self, action: #selector(coinAlertOKBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    @objc func coinAlertOKBtnClick(sender: UIButton) {
        UIView.animate(withDuration: 0.35) {
            self.coinAlertBgview.alpha = 0
        }
        if CoinManager.default.coinCount >= CoinManager.default.coinCostCount {
            
            UIPasteboard.general.string = homeView.contentTextView.text
            showCopySuccessStatus()
            CoinManager.default.costCoin(coin: CoinManager.default.coinCostCount)
        } else {
            showAlert(title: "", message: "Coins shortage, please buy coins first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) {[weak self] index in
                
                guard let `self` = self else {return}
                
                DispatchQueue.main.async {
                    self.storeBtn.updateStatus(isSelect: true)
                    self.homeBtn.updateStatus(isSelect: false)
                    self.settingBtn.updateStatus(isSelect: false)
                    self.storeView.isHidden = false
                    self.homeView.isHidden = true
                    self.settingView.isHidden = true
                }
            }
            
        }
    }
    @objc func coinAlertCloseBtnClick(sender: UIButton) {
        UIView.animate(withDuration: 0.35) {
            self.coinAlertBgview.alpha = 0
        }
    }
    @objc func closebuttonfClickClick(sender: UIButton) {
        UIView.animate(withDuration: 0.35) {
            self.coinAlertBgview.alpha = 0
        }
    }
    
    
    func setupCopySuccessView() {
        
        successCopyBgView.alpha = 0
        view.addSubview(successCopyBgView)
        successCopyBgView.backgroundColor = UIColor(hexString: "#2DC3FE")
        successCopyBgView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(56)
            
        }
        let successCopyLabel = UILabel()
        successCopyLabel.font = UIFont(name: "Lexend-SemiBold", size: 16)
        successCopyLabel.textColor = UIColor(hexString: "#232323")
        successCopyLabel.text = "Copy successfully!"
        successCopyBgView.addSubview(successCopyLabel)
        successCopyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-17)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
    }
    func showCopySuccessStatus() {
        UIView.animate(withDuration: 0.35) {
            self.successCopyBgView.alpha = 1
        } completion: { finished in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    UIView.animate(withDuration: 0.35) {
                        self.successCopyBgView.alpha = 0
                    }
                }
                
            }
        }
    }
    
}




class ALBymBottomBtn: UIButton {
    var icon: UIImage
    var name: String
    var isSetupSelect: Bool = false
    let nameLabel = UILabel()
    let iconImgV = UIImageView()
    var clickBlock: (()->Void)?
    
    init(frame: CGRect, icon: UIImage, name: String) {
        self.icon = icon
        self.name = name
        super.init(frame: frame)
        setupView()
        updateStatus(isSelect: false)
        addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickAction(sender: UIButton) {
        clickBlock?()
    }
    
    func setupView() {

        nameLabel.alpha = 0.5
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 10)
        nameLabel.text = name
        nameLabel.textColor = UIColor(hexString: "#232323")
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.width.greaterThanOrEqualTo(1)
        }
        
        iconImgV.image = icon
        iconImgV.contentMode = .scaleAspectFit
        iconImgV.alpha = 0.5
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top).offset(-1)
            $0.width.height.equalTo(20)
        }
        
    }
    
    func updateStatus(isSelect: Bool) {
        isSetupSelect = isSelect
        if isSelect {
            iconImgV.alpha = 1
            nameLabel.alpha = 1
        } else {
            iconImgV.alpha = 0.5
            nameLabel.alpha = 0.5
        }
    }
    
}
