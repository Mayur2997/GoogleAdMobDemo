//
//  ViewController.swift
//  GoogleMobileAdsDemo
//
//  Created by Mayur Parmar on 25/08/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    // MARK: - IBOutlet & Variables
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var buttonInterstitialAds: UIButton!
    @IBOutlet weak var buttonRewardedAd: UIButton!
    @IBOutlet weak var lblRewardAmount: UILabel!
    
    var interstitialAds: GADInterstitial!
    var rewardedAds: GADRewardedAd?
    var rewardAmount = 0
    
    // MARK: - Other Method
    func setupUI() {
        buttonInterstitialAds.addTarget(self, action: #selector(didTapButtonInterstitialAds), for: .touchUpInside)
        buttonRewardedAd.addTarget(self, action: #selector(didTapButtonRewardedAd), for: .touchUpInside)
        createAndLoadBanner()
        interstitialAds = createAndLoadInterstitial()
        rewardedAds = createAndLoadRewardedAd()
    }
    
    // Banner Ad
    func createAndLoadBanner() {
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    // Interstitial Ad
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") 
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    // Rewarded Ad
    func createAndLoadRewardedAd() -> GADRewardedAd {
        rewardedAds = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAds?.load(GADRequest()) { error in
            if let error = error {
                print("Loading failed: \(error)")
            } else {
                print("Loading Succeeded")
            }
        }
        return rewardedAds!
    }
    
    // Show Alert
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Ad Demo", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - View Life Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
}


//MARK:- IBAction
extension ViewController {
    @objc func didTapButtonInterstitialAds() {
        if interstitialAds.isReady {
            interstitialAds.present(fromRootViewController: self)
        } else {
            self.showAlert(message: "Ad wasn't ready")
        }
    }
    
    @objc func didTapButtonRewardedAd() {
        rewardedAds?.load(GADRequest()) { error in
            if error != nil {
                self.showAlert(message: "Ad wasn't ready")
            } else {
                self.rewardedAds?.present(fromRootViewController: self, delegate:self)
            }
        }
    }
}


// MARK: - GADBannerViewDelegate
extension ViewController : GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}


// MARK: - GADInterstitialDelegate
extension ViewController : GADInterstitialDelegate {
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAds = createAndLoadInterstitial()
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}


// MARK: - GADBannerViewDelegate
extension ViewController : GADRewardedAdDelegate {
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        self.rewardAmount += Int(truncating: reward.amount)
        self.lblRewardAmount.text = "\(self.rewardAmount)"
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        rewardedAds = createAndLoadRewardedAd()
        print("Rewarded ad dismissed.")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present.")
    }
}
