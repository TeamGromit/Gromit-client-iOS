//
//  ParticipatingListView.swift
//  Gromit-client-iOS
//
//  Created by juhee on 2023/01/21.
//

import SwiftUI

struct ParticipatingListView: View {
    @State var tag : Int? = nil
    @State private var showCreation = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    NavigationLink(destination: ChallengeListView(), tag: 1, selection: $tag) {
                        HStack {
                        }
                        .navigationTitle("참여 챌린지")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("전체 챌린지") {
                                    tag = 1
                                }
                                .font(.system(size: 16))
                                .foregroundColor(Color(.gray))
                                .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 0))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color(.gray))
                                )
                            }
                            ToolbarItem {
                                Button("챌린지 생성") {
                                    showCreation.toggle()
                                }
                                .sheet(isPresented: $showCreation) {
                                    CreationView()
                                }
                                .font(.system(size: 16))
                                .foregroundColor(Color(.gray))
                                .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color(.gray))
                                )
                            }
                        }
                    }
                    ParticipatingCell()
                }
            }
        }
    }
}

struct ParticipatingListView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipatingListView()
    }
}

struct ParticipatingCell: View {
    var challenges: [Challenge] = ChallengeList.participatingList
    
    var body: some View {
            List(challenges, id: \.id) { challenge in
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(challenge.title)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                        HStack {
                            Spacer()
                            Text(challenge.startDate)
                        }
                        HStack {
                            Text("10 / 100")
                        }
                        ProgressBar()
                    }
                    .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
                    .background(Color("yellow500"))
                    .cornerRadius(20)
                    .shadow(color: Color("gray500"), radius: 5, y: 5)
                    NavigationLink(destination: ParticipatingDetailView(challenge: challenge)) {
                        EmptyView()
                    }
                    .opacity(0.0)
                }
            }
            .listStyle(PlainListStyle())
//        }
        //.navigationTitle("참여 챌린지")
    }
}

struct CompletedCell: View {
    var challenges: [Challenge] = ChallengeList.participatingList
    
    var body: some View {
        NavigationView(content: {
            List(challenges, id: \.id) { challenge in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(challenge.title)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    }
                    HStack {
                        Spacer()
                        Text("챌린지 기한 마감")
                    }
                    HStack {
                        Text("100 커밋")
                        HStack {
                            Text("성공")
                                .padding(EdgeInsets(top: 1, leading: 10, bottom: 1, trailing: 10))
                        }
                        .background(Color("green500"))
                        .cornerRadius(CGFloat(20))
                        
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
                .background(Color("yellow500"))
                .cornerRadius(20)
                .shadow(color: Color("gray500"), radius: 5, y: 5)
            }
            .listStyle(PlainListStyle())
        })
    }
}

struct SizePreferenceKey: PreferenceKey{
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct ProgressBar: View {
    @State private var containerWidth: CGFloat = 0
    @State private var step = 8
    private let goal = 10
    
    var maxWidth: Double {
        return min((containerWidth / CGFloat(goal) * CGFloat(step)), containerWidth)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.clear)
                    .onAppear {
                        containerWidth = geo.size.width
                    }
            }
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.white))
                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("green500"))
                .frame(width: maxWidth, height: 29)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
