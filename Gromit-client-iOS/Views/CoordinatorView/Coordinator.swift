//
//  Coordinator.swift
//  Gromit-client-iOS
//
//  Created by 김태성 on 2023/02/17.
//

import Foundation
import SwiftUI

// Page
// 일반 View

enum RootPage: String, Identifiable {
    case signInView, homeView, collectionView, settingView, challengeListView, participatingListView
    var id: String {
        self.rawValue
    }
}

enum Page: String, Identifiable {
    case signInView, gitHubNameCheckView, inputUserNameView, challengeListView, participatingListView, participatingDetailView, homeView, settingView, changeGromitUserNameView, collectionView
    var id: String {
        self.rawValue
    }
}

// Sheet
// Modal과 흡사
// 호출 뷰와 상속 관계가 아닌..?
enum Sheet: String, Identifiable {
    case test, creationView, collectionView
    var id: String {
        self.rawValue
    }
}

// FullScreenCover
// Modal과 흡사 FullScreen으로 호출 View를 모두 덮는다.
// 호출 뷰와 상속 관계가 아닌..?
enum FullScreenCover: String, Identifiable {
    case collectionListView, challengeCreateView, nickNameCreateView, checkGitUserPopup
    var id: String {
        self.rawValue
    }
}

enum AlertPopup: String, Identifiable {
    case test
    //case signInError, emptyUserName, isNotExistGitUser, isExistGitUser, isExistGromitUser, isNotExistGromitUser, requesetServerError
    var id: String {
        self.rawValue
    }
}

enum Popup: String, Identifiable {
    case isCheckGitUser, requestServerError, emptyUserName, isNotExistGitUser, isExistGromitUser, isNotExistGromitUser, signInError, changeGromitUserName, failAppleSignIn, timeOutNetwork
    var id: String {
        self.rawValue
    }
}

// 객체의 변화를 감지하기 위해서는 ObservableObject 프로토콜을 채택해야한다.
class Coordinator: ObservableObject {
    // signInView, homeView, participatingListView, settingView, challengeListView, participatingListView
    // @Published @ObservableObject 프로토콜 준수해야 사용 가능
    @Published var sigInViewPath: NavigationPath
    @Published var homeViewPath: NavigationPath
    
    @Published var settingViewPath: NavigationPath
    @Published var collectionViewPath: NavigationPath
    
    @Published var challengeListViewPath: NavigationPath
    @Published var participatingListViewPath: NavigationPath
    
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    @Published var alertPopup: AlertPopup?
    @Published var popup: Popup?
    
    @Published var isLoading: Bool
    @Published var isPopuping: Bool
    
    @Published var tabSelection: Int
    @Published var rootPage: RootPage
    
    var alertOKAction: (() -> Void)?
    var popupOKAction: (() -> Void)?
    var popupCancleAction: (() -> Void)?
    
    var selectChallenge: Challenge?
    
    init(isExistLoginHistory: Bool) {
        self.sigInViewPath = NavigationPath()
        self.homeViewPath = NavigationPath()
        self.collectionViewPath = NavigationPath()
        self.settingViewPath = NavigationPath()
        self.challengeListViewPath = NavigationPath()
        self.participatingListViewPath = NavigationPath()
        
        self.isLoading = false
        self.isPopuping = false
        self.tabSelection = 2
        
        if(isExistLoginHistory) {
            self.rootPage = .homeView
        } else {
            self.rootPage = .signInView
        }
        print("Coordinator Init!! \(rootPage)")
    }
    
    
    func push(_ rootPage: RootPage, page: Page, challenge: Challenge? = nil) {
        switch rootPage {
        case .signInView:
            sigInViewPath.append(page)
        case .homeView:
            homeViewPath.append(page)
        case .collectionView:
            collectionViewPath.append(page)
        case .settingView:
            settingViewPath.append(page)
        case .challengeListView:
            challengeListViewPath.append(page)
        case .participatingListView:
            participatingListViewPath.append(page)
        }
        
        if let challenge = challenge {
            selectChallenge = challenge
        }
    }
    
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func present(alertPopup: AlertPopup, okAction: (() -> Void)? = nil) {
        self.alertPopup = alertPopup
        self.alertOKAction = okAction
    }
    
    
    func pop(_ rootPage: RootPage) {
        switch rootPage {
        case .signInView:
            if(sigInViewPath.isEmpty == false) {
                sigInViewPath.removeLast()
            }
        case .homeView:
            if(homeViewPath.isEmpty == false) {
                homeViewPath.removeLast()
            }
        case .collectionView:
            if(collectionViewPath.isEmpty == false) {
                collectionViewPath.removeLast()
            }
        case .settingView:
            if(settingViewPath.isEmpty == false) {
                settingViewPath.removeLast()
            }
        case .challengeListView:
            if(challengeListViewPath.isEmpty == false) {
                challengeListViewPath.removeLast()
            }
        case .participatingListView:
            if(participatingListViewPath.isEmpty == false) {
                participatingListViewPath.removeLast()
            }
        }
    }
    func popToRoot() {
        self.tabSelection = 2
        switch rootPage {
        case .signInView:
            sigInViewPath.removeLast(sigInViewPath.count)
        case .homeView:
            homeViewPath.removeLast(homeViewPath.count)
        case .collectionView:
            collectionViewPath.removeLast(collectionViewPath.count)
        case .settingView:
            settingViewPath.removeLast(settingViewPath.count)
        case .challengeListView:
            challengeListViewPath.removeLast(challengeListViewPath.count)
        case .participatingListView:
            participatingListViewPath.removeLast(participatingListViewPath.count)
        }
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    func startLoading() {
        self.isLoading = true
    }
    
    func stopLoading() {
        self.isLoading = false
    }
    
    func openPopup(popup: Popup, okAction: (() -> Void)? = nil, cancleAction: (() -> Void)? = nil) {
        self.popup = popup
        popupOKAction = okAction
        popupCancleAction = cancleAction
        isPopuping = true
    }
    
    func closePopup() {
        isPopuping = false
    }
    
    //    @ViewBuilder
    //    func rootBuild() -> some View {
    //        switch rootPage {
    //        case .homeView
    //            HomeView()
    //        case .participatingListView
    //
    //        case .signInView:
    //            SignInView()
    //        }
    //    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .signInView:
            SignInView()
        case .gitHubNameCheckView:
            SearchGitUserView()
        case .inputUserNameView:
            InputUserNameView()
        case .challengeListView:
            ChallengeListView()
        case .participatingListView:
            ParticipatingListView()
        case .homeView:
            HomeView()
        case .collectionView:
            CollectionListView()
        case .settingView:
            SettingView()
        case .participatingDetailView:
            if let selectChallenge = selectChallenge {
                ParticipatingDetailView(challenge: selectChallenge)
            } else {
                EmptyView()
            }
        case .changeGromitUserNameView:
            ChangeNameView()
        }
    }
    
    
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .test:
            NavigationStack {
                CreationView()
            }
        case .creationView:
            CreationView()
        case .collectionView:
            CollectionListView()
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .checkGitUserPopup: NavigationStack {
            let userName = LoginService.shared.getGithubUserName()
            let userImage = LoginService.shared.getGithubUserImageUrl()
            
            GromitPopupView(popupType: .gitProfileView, buttonType: .twoButton, userName: userName ?? "" , urlString: userImage ?? "",  okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
            
        }
        case .nickNameCreateView: NavigationStack {
            InputUserNameView()
        }
        case .challengeCreateView: NavigationStack {
            CreationView()
        }
        case .collectionListView: NavigationStack {
            CollectionListView()
        }
        }
    }
    
    //    func build(alert: AlertPopup) -> Alert {
    //        switch alert {
    //        case .signInError:
    //            return Alert(
    //                title: Text("로그인 실패!"),
    //                message: Text("애플리케이션 관리자에게 보고해주세요.")
    //                //               ,dismissButton: .default(Text("확인")) {
    //                //                    // 아래 코드 작동 안됨...
    //                //                    UserDefaults.standard.set(userNickname, forKey: "nickname")
    //                //                    guard let nickname = UserDefaults.standard.string(forKey: "nickname") else { return }
    //                //                    guard let githubName = UserDefaults.standard.string(forKey: "githubName") else { return }
    //                //                    guard let email = UserDefaults.standard.string(forKey: "email") else { return }
    //                //                    guard let provider = UserDefaults.standard.string(forKey: "provider") else { return }
    //                //                    print("userName: \(nickname) / githubName: \(githubName) / email: \(email) / provider: \(provider)")
    //                //                    inputUserNameViewModel.postSignUp(rNickname: nickname, rgithubName: githubName, rEmail: email, rProvider: provider)
    //                //                }
    //            )
    //        case .requesetServerError:
    //            return Alert(
    //                title: Text("로그인 실패!"),
    //                message: Text("애플리케이션 관리자에게 보고해주세요.")
    //            )
    //        case .emptyUserName:
    //            return Alert(title: Text("유저명을 입력해주세요!"))
    //        case .isNotExistGitUser:
    //            return Alert(title: Text("유저명 오류!") , message: Text("Git 유저명을 다시 한번 확인해주세요."))
    //        case .isExistGitUser:
    //            return Alert(title: Text("유저명 확인!"), message: Text("해당 유저로 등록하시겠습니까?"),
    //                         primaryButton: .default(Text("확인"), action: {
    //                if let alertOKAction = self.alertOKAction {
    //                    alertOKAction()
    //                }
    //            }), secondaryButton: .cancel(Text("취소"))
    //            )
    //        case .isExistGromitUser:
    //            return Alert(title: Text("유저명 중복!") , message: Text("다른 Gromit 유저명을 시도해주세요."))
    //        case .isNotExistGromitUser:
    //            return Alert(title: Text("유저명 확인!"), message: Text("해당 Gromit 유저명으로 등록하시겠습니까?"),
    //                         primaryButton: .default(Text("확인"), action: {
    //                if let alertOKAction = self.alertOKAction {
    //                    alertOKAction()
    //                }
    //            }), secondaryButton: .cancel(Text("취소"))
    //            )
    //        }
    //    }
    
    @ViewBuilder
    func buildLoadingView() -> some View {
        ZStack {
            Color(.darkGray)
                .opacity(0.5)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .scaleEffect(3)
        }
    }
    
    
    // 이 방법 밖에 없나.....
    @ViewBuilder
    func buildPopupView() -> some View {

        switch self.popup{
        case .isCheckGitUser:
            let userName = LoginService.shared.getGithubUserName()
            let userImage = LoginService.shared.getGithubUserImageUrl()
            
            GromitPopupView(popupType: .gitProfileView, buttonType: .twoButton, userName: userName ?? "" , urlString: userImage ?? "",  okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
            
        case .isNotExistGitUser:
            GromitPopupView(popupType: .message, title: "존재하지 않는 유저명!", message: "유저명을 확인해주세요.", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .requestServerError:
            GromitPopupView(popupType: .message, title: "네트워크 서버 오류!", message: "관리자에게 오류를 보고해주세요.", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .emptyUserName:
            GromitPopupView(popupType: .message, title: "입력 오류!", message: "값을 입력해주세요!", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .none:
            GromitPopupView(popupType: .message, title: "", message: "", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .isExistGromitUser:
            let gromitUserName = LoginService.shared.getGromitUserName() ?? ""
            GromitPopupView(popupType: .message, title: "유저명 중복!", message: "\(gromitUserName) 이외 유저명을 입력해주세요!", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .isNotExistGromitUser:
            let gromitUserName = LoginService.shared.getGromitUserName() ?? ""
            GromitPopupView(popupType: .message, buttonType: .twoButton, title: "유저명 확인!", message: "\(gromitUserName)으로 가입하시겠습니까!", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .signInError:
            GromitPopupView(popupType: .message, title: "가입 오류!", message: "관리자에게 오류를 보고해주세요!", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .changeGromitUserName:
            GromitPopupView(popupType: .message, title: "닉네임 변경 완료!", message: "", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .failAppleSignIn:
            GromitPopupView(popupType: .message, title: "애플 로그인 오류!", message: "관리자에게 오류를 보고해주세요!", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        case .timeOutNetwork:
            GromitPopupView(popupType: .message, title: "요청 시간 초과!", message: "관리자에게 오류를 보고해주세요!", okDelegate:  popupOKAction, cancleDelegate: popupCancleAction)
        }
    }
}
