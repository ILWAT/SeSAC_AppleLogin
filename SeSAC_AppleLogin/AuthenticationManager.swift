//
//  AuthenticationManager.swift
//  SeSAC_AppleLogin
//
//  Created by 문정호 on 12/29/23.
//

import Foundation
import LocalAuthentication //FaceID, TouchID

/*
 - 권한 요청
 - FaceID가 없다면?
    - 다른 인증 방법 권장 혹은 FaceID 등록 권유(아이폰 잠금을 아예 사용하지 않거나, 비밀번호만 등록한 사람)
    - FaceID를 설정하려면 아이폰 암호가 먼저 설정되어야 함. 그래서 아이폰 암호만 없는 경우는 없음.
 
 - FaceID 변경!
    - domainStateData (안경, 마스크 등은 domainStateData가 변경 X: 한개의 Data에 통합되어 있음.)
    
 - FaceID 계속 실패할 때?
    - FallBack에 대한 처리가 필요. 다른 인증방법으로 처리가 필요.
 - FaceID 결과는 메인쓰레드 보장 X, DispatchQueue.main.async 필요
 - 한 화면에서, FaceID 인증을 성공하면, 해당 화면에 대해서는 success. (SwiftUI에서는 state가 변경되면 body 렌더링돼서 뷰가 다시 그려지고 그럼 초기화가 됨. 다시 인증필요.)
 
 - 실제 서비스 테스트 + LSLP 생체 인증 연동
 
*/

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    var selectedPolicy: LAPolicy = .deviceOwnerAuthentication //생체인증+비밀번호
    
    private init() { }
    
    //인증
    func auth() {
        
        let context = LAContext()
        context.localizedCancelTitle = "FaceID 인증 취소"
        context.localizedFallbackTitle = "비밀번호로 대신 인증하기"
        
        context.evaluatePolicy(selectedPolicy, localizedReason: "페이스 아이디 인증이 필요합니다.") { result, error in
            print(result) //Bool -> completionHandler
            
            if let error {
                let code = error._code
                let laError = LAError(LAError.Code(rawValue: code)!)
                print(laError)
            }
        }
        
    }
    
    //FaceID 쓸 수 있는 상태인지 여부 확인.
    func checkPolicy() -> Bool {
        let context = LAContext()
        let policy: LAPolicy = selectedPolicy
        return context.canEvaluatePolicy(policy, error: nil)
    }
    
    //변경 시
    func isFaceIDchanged() -> Bool {
        
        let context = LAContext()
        context.canEvaluatePolicy(selectedPolicy, error: nil)
        
        let state = context.evaluatedPolicyDomainState //생체 인증 정보
        
        //생체 인증 정보를 UserDefaults에 저장
        //기존 저장된 DomainState와 새롭게 변경된 DomainState를 비교 -> 다를 경우에 로직 처리 필요
        
        print(state)
        return false //지금이야 간단한 로직으로 구현 하지만, 실제에서는 로직 처리가 필요
    }
    
    
}
