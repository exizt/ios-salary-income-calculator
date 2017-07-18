//
//  Calculator_ViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 18..
//  Copyright © 2017년 SH.Hong. All rights reserved.
// 여기서 Admob 을 구현한다. 계산기 기능은 Container view 안으로 들어가게 되었다.
//

import UIKit
import GoogleMobileAds

class Calculator_ViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {
    var interstitialAD : GADInterstitial!
    var bannerViewAD: GADBannerView!
    let isEnabled_InterstitialAD: Bool = false
    let isEnabled_BannerAD: Bool = true
    let isDebugAdmob: Bool = false
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Admob
        if(isEnabled_InterstitialAD) { interstitialAD = createWithLoadInterstitialGAD() }
        if(isEnabled_BannerAD) { bannerViewAD = createWithLoadBannerGAD() }
        // rotate 될 때 동작
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotatedAdmobBanner), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // --------------------------
    // google Admob 공통
    // Googld Admob 의 Request 생성 관련
    func createRequestGAD() -> GADRequest{
        let request = GADRequest()
        
        // testdevices 목록
        var testDevices : [Any] = []
        testDevices += [kGADSimulatorID] // all simulators
        //testDevices += ["d73c08aad93622d32f26c3522eb69135"] // SHiPhone7
        //testDevices += ["4bac9987239aad2ff1b894917a15b4f3"] // SHiPhone7
        request.testDevices = testDevices
        
        return request
    }
    
    func debugPrint_Admob(_ msg: String){
        if(isDebugAdmob){
            print(msg)
        }
    }
    
    // --------------------------
    // banner ads 관련
    // 배너형 광고.
    func createWithLoadBannerGAD()->GADBannerView?
    {
        if(!isEnabled_BannerAD) { return nil }
        debugPrint_Admob("createWithLoadBannerGAD")
        
        // 기본적인 셋팅
        let bannerGAD = GADBannerView(adSize: kGADAdSizeFullBanner)
        //bannerViewAD = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerGAD.adUnitID = "ca-app-pub-6702794513299112/8753530183"
        bannerGAD.delegate = self
        bannerGAD.rootViewController = self
        
        
        // 애드몹을 사용하려면, 콘텐츠 스크롤 하단부에 여백을 추가로 넣어줌
        //scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
      
        bannerGAD.load(createRequestGAD())
        //self.tableView.tableFooterView?.addSubview(bannerViewAD)
        //self.navigationController?.toolbar.addSubview(bannerViewAD)
        //self.scrollview
        self.view.addSubview(bannerGAD)
        containerView.frame.size.height -= bannerGAD.frame.size.height
        return bannerGAD
        
    }
    
    // [Admob Banner Type] 로딩이 되면 화면에 보여줌
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("adViewDidReceiveAd")
        showBanner(bannerView)
    }
    
    // [Admob Banner Type] 에러 발생시에 hide 시킴
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("adView")
        hideBanner(bannerView)
    }
    
    func showBanner(_ bannerView: GADBannerView){
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("showBanner")
        //let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        //bannerView.transform = translateTransform
        
        //UIView.animate(withDuration: 0.5) {
        //    bannerView.transform = CGAffineTransform.identity
        //}
        
        //UIView.beginAnimations("showBanner", context: nil)
        let rect = CGRect(x: view.frame.size.width/2 - bannerView.frame.size.width/2, y: view.bounds.height - bannerView.frame.size.height - CGFloat((self.tabBarController?.tabBar.frame.height)!), width: bannerView.frame.size.width, height: bannerView.frame.size.height)

        bannerView.frame = rect
        //UIView.commitAnimations()
        bannerView.isHidden = false
    }
    
    func hideBanner(_ bannerView: GADBannerView){
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("hideBanner")
        
        //UIView.beginAnimations("showBanner", context: nil)
        //bannerView.frame = CGRect(x: view.frame.size.width/2 - bannerView.frame.size.width/2, y: view.frame.size.height - bannerView.frame.size.height, width: bannerView.frame.size.width, height: bannerView.frame.size.height)
        
        //UIView.commitAnimations()
        bannerView.isHidden = true
    }
    
    
    func rotatedAdmobBanner(){
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("rotatedAdmobBanner")
        hideBanner(bannerViewAD)
        showBanner(bannerViewAD)
        
    }
    
    // END of [[banner ads 관련]]
    // --------------------------
    
    
    // --------------------------
    // [[Admob 전면광고 관련]]
    // Admob 전면광고 생성 메서드
    func createWithLoadInterstitialGAD() -> GADInterstitial?{
        if(!isEnabled_InterstitialAD) { return nil }
        
        //Admob Unit ID
        let interstitialGAD = GADInterstitial(adUnitID: "ca-app-pub-6702794513299112/1093139381")
        interstitialGAD.delegate = self
        interstitialGAD.load(createRequestGAD())
        
        return interstitialGAD
    }

    
    //Admob 전면광고
    func viewInterstitial(){
        if(!isEnabled_InterstitialAD) { return }
        
        // 준비가 완료되었다면 화면에 활성 present
        if interstitialAD.isReady {
            interstitialAD.present(fromRootViewController: self)
        } else {
            //print("Ad wasn't ready")
        }
    }
    
    //로드가 완료되었을때 의 처리.
    // 화면에 보여주기
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if(!isEnabled_InterstitialAD) { return }
        
        //print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    //실패했을때의 처리
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        if(!isEnabled_InterstitialAD) { return }
        
        //print("Fail to receive interstitial")
    }

    // End of [[Admob 전면광고 관련]]
    // --------------------------

}
