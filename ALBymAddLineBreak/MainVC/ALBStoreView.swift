//
//  ALBStoreView.swift
//  ALBymAddLineBreak
//
//  Created by JOJO on 2021/5/18.
//

import UIKit
import SwifterSwift
import NoticeObserveKit

class ALBStoreView: UIView {
    var upVC: ALBymMainVC?
    var collection: UICollectionView!
    private var pool = Notice.ObserverPool()
    let topLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateTopLabel()
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        .invalidated(by: pool)
    }
    
    func updateTopLabel() {
        self.topLabel.text = "Available gold coins: \(CoinManager.default.coinCount)"
    }
    
    func setupView() {
        //
        
        topLabel.font = UIFont(name: "Lexend-ExtraBold", size: 14)
        topLabel.textColor = UIColor(hexString: "#232323")
        
        addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(16)
            $0.top.equalTo(34)
            $0.height.greaterThanOrEqualTo(1)
            $0.width.greaterThanOrEqualTo(1)
        }
        updateTopLabel()
        
        let topIconImgV = UIImageView(image: UIImage(named: "store_coins_ic"))
        topIconImgV.contentMode = .scaleAspectFit
        addSubview(topIconImgV)
        topIconImgV.snp.makeConstraints {
            $0.centerY.equalTo(topLabel)
            $0.right.equalTo(topLabel.snp.left).offset(-8)
            $0.width.height.equalTo(25)
        }
        
        //
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
            $0.top.equalTo(70)
            $0.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: ALBStoreCell.self)
        
    }
    func selectCoinItem(item: StoreItem) {
        CoinManager.default.purchaseIapId(iap: item.iapId) { (success, errorString) in
            
            if success {
                CoinManager.default.addCoin(coin: item.coin)
                self.upVC?.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.upVC?.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
}

extension ALBStoreView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ALBStoreCell.self, for: indexPath)
        
        let item = CoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "\(item.coin) coins"
        cell.priceLabel.text = item.price
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension ALBStoreView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 312, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension ALBStoreView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = CoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class ALBStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        //
        bgImageV.backgroundColor = .clear
        bgImageV.contentMode = .scaleAspectFit
        bgImageV.image = UIImage(named: "store_bg_ic")
        bgImageV.layer.masksToBounds = true
//        bgImageV.layer.cornerRadius = 32
        bgView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(312)
            $0.height.equalTo(92)
        }
        //
        coverImageV.image = UIImage(named: "store_coins_ic")
        coverImageV.contentMode = .scaleAspectFit
        bgView.addSubview(coverImageV)
        coverImageV.snp.makeConstraints {
            $0.left.equalTo(24)
            $0.top.equalTo(24)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel.textColor = UIColor(hexString: "#232323")
        coinCountLabel.textAlignment = .center
        coinCountLabel.font = UIFont(name: "Lexend-ExtraBold", size: 20)
        coinCountLabel.adjustsFontSizeToFitWidth = true
        bgView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(1)
            $0.centerY.equalTo(coverImageV)
            $0.left.equalTo(coverImageV.snp.right).offset(10)
            $0.height.equalTo(34)
        }
        
        priceLabel.backgroundColor = .white
        priceLabel.textColor = UIColor(hexString: "#232323")
        priceLabel.font = UIFont(name: "Lexend-ExtraBold", size: 16)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        priceLabel.layer.cornerRadius = 22
        priceLabel.layer.masksToBounds = true
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.layer.borderWidth = 4
        priceLabel.layer.borderColor = UIColor.black.cgColor
        priceLabel.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.right.equalTo(-20)
            $0.width.equalTo(128)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                
            } else {
                
            }
        }
    }
}
