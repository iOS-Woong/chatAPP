//
//  MockSocket.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import Foundation
import Moya
import Alamofire

// 1.소켓

struct Certificates {
    static let certificate: SecCertificate = Certificates.certificate(filename: "certificateFileName")

    private static func certificate(filename: String) -> SecCertificate {
        let filePath = Bundle.main.path(forResource: filename, ofType: "cer") ?? ""
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!
        return certificate
  }
}

final class MockSocket {
    
    let session = Session(
        configuration: URLSessionConfiguration.default,
        startRequestsImmediately: false,
        serverTrustManager: ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: ["https://127.0.0.1:8080": PinnedCertificatesTrustEvaluator()])
    )
    
    lazy var provider = MoyaProvider<DefaultAPI>(session: session)
    
    func requestGet() {
        provider.request(.get) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestPost() {
        provider.request(.post(PostRequestModel.mock)) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

