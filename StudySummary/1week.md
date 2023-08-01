## 1주차

### 전반적인 스터디 목표를 설정했다.

- 스터디에서 진행하는 토이프로젝트의 최종결과물에 대해서 설정하였다.
    - 친구목록 기능
    - 대화방목록 기능
    - 스터디원 8명과 1:1 or 1:N 대화 기능

- **친구목록 View의 구현**
    1. Vapor 서버를 활용해서 받아오도록 함
    2. openssl 이용한 사설 CA 및 인증서 생성해서 적용
    
- **대화방목록 기능과 1:1 & 1:N의 구현** 에 대한 방법을 일부 알려줬지만, 기록하면서 들었는데도 이해가 가지않는다. 스터디를 진행하면서 이해 할 수 있도록 노력해보자

---
### 진행요약

1. Vapor를 통해서 초기에 서버를 구현했다.(보안이 적용되지않은 http로)
2. 보안을 적용해주기 위해서 SSL/TLS를 기본으로 사용하는 HTTP2 프로토콜을 적용시켜야 겠다고 생각했다!(속도를 향상시키려는 의도도 있는 것 같다.)
3. OpenSSL을 통해서 인증서를 생성하고 자체서명하였다.
4. 서명된 인증서를 활용하여 Vapor 내부에서 TLS를 구성하고 server에 HTTP2 프로토콜이 적용되도록 한 후, 빌드를 통해 서버를 활성화하였다.

---

### 세부진행사항

1. 터미널에서 vapor를 설치한다.
    ```
    brew install vapor
    ```
2. Vapor 프로젝트를 생성 후, 프로젝트 디렉터리로 이동하여 Xcode에서 프로젝트를 실행한다.
    ```
    // 생성
    vapor new task-management
    // 열기
    cd task-management
    vapor xcode
    ```
3. vapor xcode를 통해 실행하게되면 엄청나게 많은 Package Dependencies와 함께 SPM 다운로드가 시작됨. 
    ![](https://hackmd.io/_uploads/BkqWvgHoh.png)

4. 이걸 빌드하게되면 console창에 아래와 같은 텍스트가 찍히게된다. 그리고 이 URL을 chrome을 통해 접근하면 Hello World란 텍스트가 찍힌 웹을 확인 할 수 있다.
    ```
    [ NOTICE ] Server starting on http://127.0.0.1:8080
    ```
    ![](https://hackmd.io/_uploads/H1HCOxSjh.png)

5. 이제 SSL(Secure Sockets Layer)이 적용되어있지 않은 http:// 로 되어있는 URL을 SSL을 적용시켜 https:// 로 변경시켜줘야한다.
    
6. HTTP1을 HTTP2로 적용시키자. 그러기 위해선 SSL이 필요. SSL을 생성하자
    - 기본적으로 HTTP2는 TLS/SSL을 통해서만 작동함
    - 아래 문서는 HTTP2를 지원하기 위해 SSL을 생성하는 방법을 잘 보여주고 있는 아티클이다.
    - [A simple HTTP/2 server using Vapor 4](https://theswiftdev.com/a-simple-http2-server-using-vapor-4/)
    
7. SSL을 생성하기 위해서 터미널에서 아래 코드를 입력하여 실행한다.
    ```
    openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
    ```
    - 입력값에 대해 소개하는 아티클 https://m.blog.naver.com/espeniel/221845133507
    - 터미널에 위 코드를 통해서 Self signing SSL 인증서를 생성하게되면 cert.pem, key.pem이라는 키 파일이 두개 생성된다.
    ![](https://hackmd.io/_uploads/BySdfXUsn.png)

8. HTTP2 지원을 활성화하려면 Vapor에서 HTTPServer 구성 서비스를 등록해야함.
    - configure.swift 파일에서 이 작업을 수행할 수 있다.
    - 먼저, 해당 개인 키 파일로 인증서 체인을 로드함.
    - 다음으로 SSL인증서를 사용하여 적절한 TLS 구성을 만들어야 함.
    - 마지막으로 만들어야 하는 것은 새 HTTP 구성 개체
    
    ```swift
    public func configure(_ app: Application) async throws {
        let homePath = "/Users/hyeonung-seo/Desktop/chatAPP/chatAPP"
        let certPath = homePath + "/cert.pem"
        let keyPath = homePath + "/key.pem"
        // 인증서로드
        let certs = try! NIOSSLCertificate.fromPEMFile(certPath)
        .map { NIOSSLCertificateSource.certificate($0) }
        // TLS 구성
        let tls = TLSConfiguration.forServer(
            certificateChain: certs,
            privateKey: .file(keyPath)
        )
        // 새 HTTP 구성 개체 configure
        app.http.server.configuration = .init(
            hostname: "127.0.0.1",
            port: 8080,
            backlog: 256,
            reuseAddress: true,
            tcpNoDelay: true,
            responseCompression: .disabled,
            requestDecompression: .disabled,
            supportPipelining: false,
            supportVersions: Set<HTTPVersionMajor>([.two]),
            tlsConfiguration: tls,
            serverName: nil,
            logger: nil
        )
        // ... 이외코드
    ```
    
    
9. 위 코드를 작성하고 빌드를 통해 HTTP2 지원을 활성화한다.
    - 콘솔창에 아래와 같이 보안이 적용된 URL https://---- 형태로 URL이 보여진다.
    ![](https://hackmd.io/_uploads/H1-mu7Ush.png)
    
    - URL에 접근하여 Chrome의 우클릭 + 검사창으로 적용된 프로토콜을 확인해보면 HTTP2가 적용되었다는 것을 확인 할 수 있다.
    ![](https://hackmd.io/_uploads/HkwiwQLi3.png)

10. 1주차 스터디에서 진행한 사항을 정리하면 아래와 같다.
    - Vapor를 통해서 초기에 서버를 구현했다.(보안이 적용되지않은 http로)
    - 보안을 적용해주기 위해서 SSL/TLS를 기본으로 사용하는 HTTP2 프로토콜을 적용시켜야 겠다고 생각했다!(속도를 향상시키려는 의도도 있는 것 같다.)
    - OpenSSL을 통해서 인증서를 생성하고 자체서명하였다.
    - Vapor에서 서명된 인증서를 통해서 TLS를 구현하고 server에 HTTP2 프로토콜이 적용되도록 한 후, 빌드를 통해 활성화하였다.

---

### 문제사항

1. [ WARNING ] No custom working directory set for this scheme, using --- 서버를 활성화시키게 되면 아래 에러메시지가 출력되었다.
    ![](https://hackmd.io/_uploads/r1amzE8oh.png)

    - **원인**
    기본적으로 Xcode에서 프로젝트를 실행하면 프로젝트의 루트 폴더가 아니라 
    이 DerivedData 폴더에서 실행하게 됩니다. 
    이 때문에 프로젝트 설정에 따라 특정 파일이나 폴더를 찾지 못하는 문제가 발생할 수 있음.
    - **해결**
    이 문제를 해결하려면, 프로젝트의 Xcode 스킴에서 사용자 정의 작업 디렉토리를 설정해야 함. (Vapor 공식문서에 잘 설명되어있다. 따라하면 그냥해결됨.)
    - 참조문서 https://docs.vapor.codes/getting-started/xcode/

2. 개설된 서버에 request를 보내면 403에러가 출력된다.
    - **원인**
    이건 정확한 원인을 파악하지못했다.
    해결하기위해 `cert.pem` 파일을 찾아가서 아래 명령어를 쳐서 키 정보를 확인해봤지만
    요청 URL 역시 일치하여 문제되는 부분이 없었다.
    - **해결**
    기존에 vapor 구성한 서버를 제거하고, 새롭게 서버를 생성하여 Key를 생성하고 서명하고 프로젝트에서 요청해보니 200으로 정상적인 요청작업이 수행되었다.
    ```
    openssl x509 -text -noout -in cert.pem
    ```
```swift
// ChatStudyApp
// ViewController.swift

func request() {
        let url = URL(string: "https://chat.com")!
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            print(data, response, error)
        }
        task.resume()
    }
```


---

### 모르는개념

- **Vapor**
    - Vapor는 Swift에서 가장 많이 사용되는 서버 사이드 프레임워크임.
    - Vapor를 활용하면 Swift로 서버를 만들 수 있다.
    - 서버사이드 프레임워크는 Vapor, Perfect, Kitura, Zewo, SwiftExpress 등이 있다.
    - 유사 프레임워크 중 가장 많은 GitHub 스타를 받고있음
    - [유사 프레임워크와 베이퍼의 소개](https://yagom.net/forums/topic/swift-%EC%84%9C%EB%B2%84-%EC%82%AC%EC%9D%B4%EB%93%9C-%ED%94%84%EB%A0%88%EC%9E%84%EC%9B%8C%ED%81%AC-vapor-perfect-kitura/)
    - https://github.com/vapor/vapor
    - Vapor를 활용하면 API를 만들고, 데이터베이스를 구성하고, 배포까지 가능함

- **SSL이란?**
    - 보안 소켓 계층(Secure Sockets Layer, SSL) 인증서라고 불림 
    - 종종 디지털 인증서로 불린다. 
    - 웹사이트와 브라우저 사이(또는 두 서버 사이)에 전송되는 데이터를 암호화하여 인터넷 연결을 보호하기 위한 기술
    - 웹사이트가 SSL/TLS 인증서로 보호되는 경우 **HTTPS**가 URL에 표시됨

- **SSL 왜씀?**
    - **결제 페이지**
        - 고객이 결제에 사용되는 신용카드 정보가 안전하는 것을 납득한다면 구매 전환의 가능성이 더 높일 수 있음
    - **로그인 패널**
        - 사용자 이름&비밀번호&기타 개인정보&문서&이미지 등을 암호화하여 보호함
    - **블로그 및 정보사이트**
        - 결제정보 or 민감한 정보를 수집하지 않는 블로그나 웹사이트도 사용자 활동의 보호를 위해 HTTPS가 필요함.

- **Certificate authority(CA, 인증 기관)**
    - CPS(Certification Practice Statement)에 따라 인증서의 발급, 중지, 갱신 또는 해지가 허용된 주체. 
    - 인증 기관, 웹 사이트, 이메일 주소, 회사 또는 개인과 같은 엔티티의 신원을 확인하고 전자 문서를 발행하여 암호화 키에 바인딩하는 회사 또는 조직
    - 현재, 스터디에서 이것을 'openssl 이용한 사설 CA 및 인증서 생성해서 적용' 하기로 하였다.

- **OpenSSL이란?**
    - 보통의 경우 웹서비스에 https를 적용할 경우 SSL인증서를 VeriSign라는 곳에서 발급받아야 함. 
    - 이때 비용이 발생하기 때문에 실제 운영서버가 아니면 발급 받기에 부담이 될 수 있다.
    - 이 때, OpenSSL을 사용하여 인증기관을 직접 만들고, Self Signed Certificate 를 생성하고, SSL인증서를 발급하면 된다.
    - 발급된 SSL인증서는 Apache httpd 등의 웹서버에 설치해서 쉽게 https의 서비스를 이용할 수 있다.

- **Self Signed Certificate 란?**

    - 공식적인 발급기관 이외에 Root CA의 개인키로 스스로의 인증서에 서명하여 최상위 인증기관 인증서를 만드는 행위. 
    - 이렇게 스스로 서명한 Root CA의 인증서를 Self Signed Certificate라고 한다. 
    - 이걸 이용하면 보통의 웹서버에서는 보안 경고를 발생시킬 수도 있지만, 테스트 사용시에는 지장이 없습니다.


- **HTTP/2란?**
    - HTTP/2(이하 H2)와 HTTP/1.x(이하 H1)와의 가장 큰 변화는 속도 향상입니다. H1의 성능 저하 부분과 비효율적인 것들을 개선되어 탄생한 것이 H2라고 생각하면 쉽습니다.
    - HTTP2는 기본적으로 안전하므로 TLS/SSL을 통해서만 작동
    - HTTP 버전 1.1에는 몇 가지 단점이 있음. 
    - 그것은 텍스트 기반의 암호화되지 않은 프로토콜이며 
    - 웹사이트가 진화하고 웹페이지를 렌더링하기 위해 점점 더 많은 리소스가 필요함에 따라 
    - HTTP/1.1은 한 번에 하나의 리소스만 다운로드할 수 있기 때문에 속도 문제에 직면하기 시작함
    - https://www.whatap.io/ko/blog/38/
    - https://theswiftdev.com/a-simple-http2-server-using-vapor-4/

- **TLS란?**
    - SSL(전송 계층 보안)은 컴퓨터 네트워크를 통해 통신 보안을 제공하는 C 언어로 작성된 암호화 프로토콜입니다. 암호화를 사용하여 데이터의 무결성과 기밀성을 보호합니다.
    - TLS(전송 계층 보안)는 인터넷을 통한 보안 통신을 위한 표준입니다. 클라이언트/서버 애플리케이션이 도청 및 정보 변조를 방지하도록 설계된 방식으로 네트워크를 통해 통신할 수 있도록 합니다.
    - 온라인 애플리케이션이나 전송 중인 데이터를 도청 및 변경으로부터 보호하기 위해 TLS 암호화는 이제 일상적인 절차가 되었다.
    - SSL 인증서와 TLS 인증서를 비교하면 데이터 흐름을 암호화하는 기능은 모두 동일함 
    - SSL의 개선되고 더 안전한 버전은 TLS임. 
    - 그러나 온라인에서 널리 사용 가능한 SSL 인증서는 웹 사이트를 보호하는 동일한 기능을 가지고 있습니다. 실제로 두 인증서는 온라인 보안의 차별화 기능으로 인식되고 있는 HTTPS 주소 표시줄을 제공함
    - https://powerdmarc.com/ko/difference-between-ssl-and-tls/
