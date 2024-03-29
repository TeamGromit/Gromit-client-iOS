//
//  SearchGitUserViewModel.swift
//  Gromit-client-iOS
//
//  Created by juhee on 2023/01/31.
//

import Foundation
import Combine
import Alamofire


class SearchGitUserViewModel: ObservableObject {
    
    enum OutputEvent {
        case isExistGitUser, isNotExistGitUser, requestError, nextViewPage
    }
    
    @Published var outputEvent: OutputEvent? = nil
    @Published var responseGithubNickName: String? = nil
    @Published var responseGithubImg: String? = nil

//    var subscription = Set<AnyCancellable>()
//    var requestGitName = ""
//    @Published var responseGitName = String()
//    @Published var responseMessage = String()
//    @Published var responseImg = String()
//
//    init() {
//        print(#fileID, #function, #line, "")
//        getGitUserName(rGitName: self.requestGitName)
//    }
//
//    func getGitUserName(rGitName: String) {
//        print(#fileID, #function, #line, "")
//        AF.request("\(GeneralAPI.baseURL)/users/github/\(rGitName)")
//            .publishDecodable(type: SearchGitUserEntity.self)
//            .compactMap { $0.value }
//            .sink(receiveCompletion: { complete in
//                print("데이터스트림 완료")
//            }, receiveValue: { receivedValue in
//                print("받은 값: \(receivedValue.description)")
//                if (receivedValue.code == 1000) { // 성공
//                    self.responseGitName = receivedValue.result.nickname
//                    self.responseImg = receivedValue.result.img
//                } else { // 실패: 중복/통신실패
//                    self.responseMessage = receivedValue.message
//                }
//                print("code: \(receivedValue.code) / message: \(receivedValue.message)")
//            }).store(in: &subscription)
//    }
    func requestCheckGitUserName(_ gitUserName: String) {
        
//        guard let token = AppDataService.shared.getData(appData: .accessToken) else {
//            print("requestCheckGitUserName Error token is nil")
//            return
//        }
                
     
        NetworkingClinet.shared.request(serviceURL: .requestGetGitUser, pathVariable: [gitUserName], httpMethod: .get, type: SearchGitUserEntity.self) { responseData, error in
            if let error = error {
                self.outputEvent = .requestError

            } else {
                if let responseData = responseData, let responseMessage = responseData.1, let code = responseMessage.code {
                    if(code == 1000) {
                        if let reponseMessageResult = responseMessage.result {
                            guard let githubUserName = reponseMessageResult.nickname else {
                                print("Guard Error githubUserName is nil")
                                return
                            }
                            self.responseGithubNickName = githubUserName
                            
                            guard let githubProfileImage = reponseMessageResult.img else {
                                print("Guard Error githubUserName is nil")
                                return
                            }
                            self.responseGithubImg = githubProfileImage
                            LoginService.shared.setLoginInfo(githubUserName: githubUserName, githubUserImageUrl: githubProfileImage)
                            //UserDefaults.standard.set(self.responseGithubNickName, forKey: "githubUserName")
                            //UserDefaults.standard.set(self.responseGithubImg, forKey: "githubImage")
                            //AppDataService.shared.setData(appData: .githubUserName, value: githubUserName)
                            //AppDataService.shared.setData(appData: .githubProfileImage, value: githubProfileImage)
                            self.outputEvent = .isExistGitUser
                        }

                    } else {
                        self.outputEvent = .isNotExistGitUser
                    }
                }
            }
        }
    }
    
    func confirmGitUser(isConfirm: Bool) {
        if(isConfirm) {
            self.outputEvent = .nextViewPage
        } else {
            //            UserDefaults.standard.set("", forKey: "githubUserName")
            //            UserDefaults.standard.set("", forKey: "githubImage")
            AppDataService.shared.setData(appData: .githubUserName, value: "")
            AppDataService.shared.setData(appData: .githubProfileImage, value: "")
        }
    }
}
