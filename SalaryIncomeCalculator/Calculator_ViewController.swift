//
//  Calculator_ViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 18..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//  여기서 Admob 을 구현한다. 계산기 기능은 Container view 안으로 들어가게 되었다.
//

import UIKit
import GoogleMobileAds


/// 메인 ViewController 클래스.
/// 여기를 부모로 하여 CalculatorMaster (계산하는 화면), CalculatorDetail (용어 설명 화면) 이 호출된다.
/// 이 클래스에서 코드는 구글 애드몹 관련 코드가 거의 다 이다...
class Calculator_ViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {
    let isDebug: Bool = false
    let isAdmobDebug: Bool = false
    var interstitialAD : GADInterstitial!
    var bannerADView: GADBannerView!
    let isEnabled_InterstitialAD: Bool = false
    let isEnabled_BannerAD: Bool = true
    var isLandscapeBefore = false
    var isRotatedAsHiddenStatus = false
    var isDisappear = false
    
    @IBOutlet weak var containerView: UIView!
    
    
    /// 화면에 로드 되어졌을 때 호출되는 메서드
    /// 로드 처음 한번만 호출됨.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Admob 에 관련된 코드.
        // Interstitial 은 전면광고, BannerAd 는 배너형 광고를 말한다.
        // 위에서 true/false 여부에 지정해준 것에 따라서 호출하게 한다. 둘 다 호출할 수도 있고..
        if(isEnabled_InterstitialAD) { interstitialAD = createWithLoadInterstitialGAD() }
        if(isEnabled_BannerAD) { bannerADView = createWithLoadGADBanner() }
        
        // rotate 될 때 동작
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotatedAdmobBanner), name: UIDevice.orientationDidChangeNotification, object: nil)

    }

    
    /// 화면에서 보여질 때 호출되는 메서드
    /// 화면에 draw 할 때마다 호출됨.
    /// - Parameter animated: bool
    override func viewDidAppear(_ animated: Bool) {
        isDisappear = false
        debugPrint("viewDidAppear")

        if(isRotatedAsHiddenStatus){
            rotatedAdmobBanner()
            isRotatedAsHiddenStatus = false
        }
    }

  
    /// 왜 추가했는지 기억 안 남. 테스트 하기 위해 넣은 듯...
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 화면에 안 보일 때 메서드
    ///
    /// - Parameter animated: 불린 값
    override func viewDidDisappear(_ animated: Bool) {
        //debugPrint("viewDidDisappear")
        isDisappear = true
    }
    
    
    // --------------------------
    // google Admob 공통
    // Googld Admob 의 Request 생성 관련
    // 테스트기기가 별개로 없으므로 주석처리함. 필요할 때 이용가능.
    func createRequestGAD() -> GADRequest{
        let request = GADRequest()
        
        // testdevices 목록
        //var testDevices : [Any] = []
        //testDevices += [kGADSimulatorID] // all simulators
        //testDevices += ["d73c08aad93622d32f26c3522eb69135"] // SHiPhone7
        //testDevices += ["4bac9987239aad2ff1b894917a15b4f3"] // SHiPhone7
        //request.testDevices = testDevices
        
        return request
    }

    
    // --------------------------
    // banner ads 관련
    // 배너형 광고.
    func createWithLoadGADBanner()->GADBannerView?
    {
        if(!isEnabled_BannerAD) { return nil }
        debugPrint_Admob("createWithLoadBannerGAD")
        
        // 기본적인 셋팅
        let bannerGAD = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
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
        showBanneAd(bannerView)
    }
    
    
    // [Admob Banner Type] 에러 발생시에 hide 시킴
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("adView")
        hideBannerAd(bannerView)
    }
    
    
    /// 배너를 화면에 표출한다.
    ///
    /// - Parameter bannerView: 배너 뷰 레퍼런스
    func showBanneAd(_ bannerView: GADBannerView){
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("showBanneAd")
        //let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        //bannerView.transform = translateTransform
        
        //UIView.animate(withDuration: 0.5) {
        //    bannerView.transform = CGAffineTransform.identity
        //}
        if UIDevice.current.orientation.isLandscape {
            bannerView.adSize = kGADAdSizeSmartBannerLandscape
        } else {
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
        }
        
        //UIView.beginAnimations("showBanner", context: nil)
        let rect = CGRect(x: view.frame.size.width/2 - bannerView.frame.size.width/2, y: view.bounds.height - bannerView.frame.size.height - CGFloat((self.tabBarController?.tabBar.frame.height)!), width: bannerView.frame.size.width, height: bannerView.frame.size.height)

        bannerView.frame = rect
        //UIView.commitAnimations()
        bannerView.isHidden = false
    }
    
    
    /// 배너를 숨김 처리하는 메서드.
    ///
    /// - Parameter bannerView: 배너 뷰 레퍼런스
    func hideBannerAd(_ bannerView: GADBannerView){
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("hideBannerAd")
        
        //UIView.beginAnimations("showBanner", context: nil)
        //bannerView.frame = CGRect(x: view.frame.size.width/2 - bannerView.frame.size.width/2, y: view.frame.size.height - bannerView.frame.size.height, width: bannerView.frame.size.width, height: bannerView.frame.size.height)
        
        //UIView.commitAnimations()
        bannerView.isHidden = true
    }
    
    
    /// 화면 가로/세로 전환이 있을 때, 배너를 재로드 해준다.
    @objc func rotatedAdmobBanner(){
        if(!isEnabled_BannerAD) { return }
        debugPrint_Admob("rotatedAdmobBanner")
        //debugPrint(String(isLandscape))
        
        // 사용안하는 상태에서 landscape 변경이 있을 시, 기록해두고, didappear 에서 가로세로 전환해줌
        if(isDisappear){
            isRotatedAsHiddenStatus = true
        } else {
            if(UIApplication.shared.statusBarOrientation.isLandscape != isLandscapeBefore){
                isLandscapeBefore = UIApplication.shared.statusBarOrientation.isLandscape
                debugPrint_Admob("rotatedAdmobBanner changed")
                hideBannerAd(bannerADView)
                showBanneAd(bannerADView)
            }
        }
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
    func debugPrint(_ message:String){
        if(isDebug){
            print("[CalculatorView]"+message)
        }
    }
    
    
    func debugPrint_Admob(_ message: String){
        if(isAdmobDebug){
            print("[CalculatorView][Admob]"+message)
        }
    }
}
