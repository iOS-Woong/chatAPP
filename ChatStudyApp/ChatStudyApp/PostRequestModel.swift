//
//  PostRequestModel.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import Foundation

struct PostRequestModel: Encodable {
    let id: Int? = nil
    let imageURL: String
    let description: String
    let name: String
}

extension PostRequestModel {
    static let mock: PostRequestModel = PostRequestModel(
        imageURL: "www.naver.com",
        description: "안녕하심니까",
        name: "woong Message")
}
