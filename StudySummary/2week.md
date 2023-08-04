## 2주차

### 회원정보 Test DB 구성

:::info
:information_source: DB구성 (*: pk, #: fk)

// USER
|    |Type|
|:-: |:-:|
|id(*)|Int|
|group_id(#)|Int|
|name|String|
|image_url|String|
|description|String|

// GROUP
|    |Type|
|:-: |:-:|
|id(*)|Int|
|name|String|
:::

---
### 진행요약
- Homebrew를 이용하여 mariadb 설치
- dbeaver등을 이용하여 mariadb에 connect하고 db를 세팅한다(테이블, 칼럼 등)
- vapor에 fluent, fluentMySQL라이브러리 의존성 추가
- fluent 이용하여 configuration에서 로컬 db 연결
- Vapor에서 모델 타입 정의 하여 db값 매핑 기반 마련
- route에서 특정 path에 대해 db를 모델로 매핑한 값 반환 (json 자동변환 해주는 것 같음)
---

### 세부진행사항
1. DBMS Tool Dbeaver를 설치한다.(공홈에서, 설정은 뒤에서)
2. RDBMS로 선택한 MariaDB를 설치 - 시작 - root계정으로 로그인한다. ()

```
// 설치
brew install mariadb

// MariaDB Server 시작
mysql.server start

// root계정으로 로그인
sudo mysql -u root
```
- 이 방법은 아래 MariaDB 공식문서에 잘 기입되어있다.
- https://mariadb.com/kb/ko/installing-mariadb-on-macos-using-homebrew/

3. MariaDB mysql root 암호를 변경한다.
![](https://hackmd.io/_uploads/ryPu9M_o2.png)
- DBeaver(DBMS)에 MariaDB를 연결 해주기 위해 password를 변경시켜주는 것으로 예상된다.


4. 처음에 설치한 Dbeaver(DBMS)로 이동하여 사용할 데이터베이스를 추가한다.
- 데이터베이스 → 새 데이터베이스 연결 → MariaDB 를 선택하면 아래와 같은 화면이 나타난다.
![](https://hackmd.io/_uploads/SknesM_sh.png)
- 여기서 3과정에서 변경한 root의 password를 입력하고 TestConnection을 보내보면 그림과 같이 Connected 되었다는 창이 표시될 것임

5. 정상적으로 연결되었다면 좌측 DB Navigator에 localhost로 object가 생긴 것을 확인할 수 있다.
![](https://hackmd.io/_uploads/ryGlAzOi3.png)

++ 연결이 된지 확인해보고싶다면 Dbeaver → localhost → 우클릭 create NewDB → root계정으로 로그인 한 상태에서 terminal 'show databases;'를 입력하면 추가되어있는 모든 DB를 확인할 수 있다.
![](https://hackmd.io/_uploads/B1FNlQuj2.png)

6. 아래를 보면 크게 아래와 같다.
- 두개의 테이블을 구성되어있다.(User, Group)
- User Table은 id(pk)와 Group Table과의 관계를 나타내기위해 group_id(fk)를 갖는다.
- Group Table은 id(pk)를 갖는다.

:::info
:information_source: DB구성 (*: pk, #: fk)

// USER
|    |Type|
|:-: |:-:|
|id(*)|Int|
|group_id(#)|Int|
|name|String|
|image_url|String|
|description|String|

// GROUP
|    |Type|
|:-: |:-:|
|id(*)|Int|
|name|String|
:::

7. 두개의 테이블(User, Group) 각각의 column을 생성해주고 PK, FK를 설정하고 Save하자!
- PK로는 각각 user: id, group: id 로 설정해준다. (constraint에서 우클릭 create new constraint로 생성해주면된다.)
![](https://hackmd.io/_uploads/HkxnxEdsn.png)

- FK로는 user: group_id에 생성해주면된다.(그림과 같이 아래의 첫번째 그림과 같은 방법으로 추가하면 두번째 그림처럼 추가가된다.)
![](https://hackmd.io/_uploads/Sy1O-Vush.png)
![](https://hackmd.io/_uploads/HJdqZNuj2.png)

- 위 방법으로 정상적으로 마쳤다면 DB구성은 끝났다.
- DB에서 다이어그램 보기를 선택해보자 그러면 아래와 같이 관계도가 그려질 것이다.
![](https://hackmd.io/_uploads/H1m7MVOoh.png)

- 

8. 이제는 vapor와 방금 구현해놓은 로컬DB를 연결해줘야한다.
- 이를 수행하기 위해선 Fluent, FluentMySQL 라이브러리가 필요함.(ORM 객체-관계 매핑 프레임워크)
- package Dependency에 아래 두 라이브러리를 추가한다.

```
// package (version의 경우 SPM에 Search해보고 맞는 Version을 추가하면된다.)
.package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
.package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: <version>),

// product (vapor는 원래 추가되어있음)
.target(name: "App", dependencies: [
    .product(name: "Fluent", package: "fluent"),
    .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
    .product(name: "Vapor", package: "vapor"),
]),
```

9. configure.swift에서 app.databases.use(_:)를 사용하여 데이터베이스를 구성할 수 있음.

```swift
import Fluent
import FluentMySQLDriver

public func configure(_ app: Application) async throws {
// ... 이외 코드
    app.databases.use(.mysql(
            hostname: "localhost",
            username: "root",
            password: "4321", // 아까 terminal로 변경한 root password
            database: "chat"), as: .mysql) // db명

// ... 이외 코드
```
- https://docs.vapor.codes/fluent/overview/#mysql
- vapor 공식문서에 설명되어있다.


10. 그리고 나서, Fluent를 활용하여 관계형DB의 테이블과 Swift의 클래스를 매핑하기위한 모델을 구현해야한다.
- 매핑할 DB를 살펴보고 어떻게 객체로 나타내야할 지 비교해보자.
    - 테이블명: user / Int
    - 컬럼1: id / / Int? / autoincrease
    - 컬럼2: name / Text
    - 컬럼3: image_url / Text
    - 컬럼4: description / Text
- group_id 는 어떻게 처리해줘야하는걸까? 한번 물어보도록하자(일단, null 값으로 체크해준다.)

![](https://hackmd.io/_uploads/SJ-e0Yqsn.png)

```swift
final class User: Model, Content {
    static let schema = "user" // 테이블명

    @ID(custom: "id") // 컬럼1
    var id: Int?

    @Field(key: "name") // 컬럼2
    var name: String

    @Field(key: "image_url") // 컬럼3
    var imageURL: String
    
    @Field(key: "description") // 컬럼4
    var description: String
    
    init() { }

    init(id: Int? = nil, name: String, imageURL: String, description: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.description = description
    }
}
```
- 왜? @ID 필드에는 (custom: "id")으로 다른것들과는 다르게 선언되었을까?
    - 이유 [Vapor 공식문서 Identifier]
    - 이 필드는 프로퍼티 래퍼를 사용해야 합니다. 
    - @ID. Fluent는 Fluent의 모든 드라이버와 호환되는 UUID및 특수 필드 키를 사용할 것을 권장합니다 
    - 만약, 사용자 정의 ID 키 또는 유형을 사용하려면 @ID(custom:)오버로드를 사용하십시오.
    - 우리는 DB에서 볼 수 있듯 ID컬럼이 Int로 정의되어있다. 따라서, 여기서 말하는 id값은 custom으로 오버로드 하여 사용해야한다는 것
- id는 DB내에서 autoincrease이며, null로 선언되어있으므로 옵셔널값으로 하며, init 될 때 기본값을 nil로 주도록한다.
    - (DB 내에선 로우가 쌓일수록 알아서 id가 autoincrease 된다.)
- 모델을 설계하는 것 역시 Vapor 공식문서에 잘 정리되어있다 나중에 필요하면 볼 것!

11. routes.swift 파일의 func routes(_ app: Application) 함수에서 라우팅을 구현하자.
- 여기서 서버로 요청되는 get,post .. 등의 http요청에 대한 핸들러를 정의해줄 수 있다.
- 우선, get으로 요청을보내보자.
```swift
func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
```
- 이렇게 요청을 보내게되면 응답이 "It works!"로 돌아온다.
- 이번엔 DB목록을 읽을 수 있도록 해보자.

```swift
func routes(_ app: Application) throws {
    app.get { req async throws in
        return try await User.query(on: req.db).all()
    }
}
```
- 정상적으로 요청이루어졌다면 빈 배열값이 반환될 것이다. (왜? 아직 post를 안했으니까)
- post요청에 대한 handler도 정의해주고 테스트해보자!
    1. 아래 코드를 routes.swift에 정의해주고 project를 build한다.
    2. 요청의 body에 포함시킬 TestJson을 구성해준다.
    3. Postman으로 요청해본다. (https://127.0.0.1:8080/write + json 포함하여)
        ```
        {
           "name":"woong",
           "imageURL":"www.naver.com",
           "description":"forTestrequest",
        }
        ```
    4. 만약 요청이 성공한다면 아래 post코드의 closure를 타게되고 콘솔에 아래와 같이 찍히게 된다.
    ![](https://hackmd.io/_uploads/S1GO5c5oh.png)
    5. 그리고나서 다시 URL을 입력하여 DB에 쓰여진 데이터를 Read해보자.
    ![](https://hackmd.io/_uploads/Hy2395qj2.png)

```swift
func routes(_ app: Application) throws {
    app.get { req async throws in
        return try await User.query(on: req.db).all()
    }
    
    app.post("write") { req async throws -> User in // [!]이 클로저를 탐
        let newUser = try req.content.decode(User.self)
        try await newUser.create(on: req.db)
        return newUser
    }
}
```

이번 스터디로 서버가 어떤 역할을 한다는 것을 완전히 이해할 순 없지만
앱에서 CRUD를 수행할 때, 
서버로 HTTP요청으로 GET,POST,PUT,PATCH를 request하고 
라우팅을 통해서 handler가 정의되며 처리되는거구나! 하는 약간의 감은 오는 것 같다.
비어있는 개념이 약간은 채워진 느낌
매주 모르는개념을 익히고 정리하면서 공부해보자.

---

### 문제사항
- Field 'group_id' doesn't have a default value라는 에러문구가 발생했다.
    
    원인
    - 말그대로 defaultValue가 없어서 발생한 문제였다.
    - 내가 Vapor에서 구현한 Model의 경우, group_id를 포함하고 있지 않기에 이와 같은 에러가 발생한 것이 아닐까 예상하고있다.
    - 그렇다면 group_id도 vapor 내의 Model에서 구현해줘야하는 것인가?
    - 이건 한번 확인해보고 처리해보자.
    
    해결
    - group_id의 Not Null을 Null값이 가능하도록 하고 Default를 Null로 구현하였다.(임시방편의 해결책이므로 근본적인 방법을 묻고 찾아보자.)
    
![](https://hackmd.io/_uploads/H1x23qcsn.png)

---

### 모르는개념

**DBMS, RDBMS란?**
- Relational Database Management System
- Database Management System
- 간단하게 RDBMS는 테이블 기반의 DBMS라고 생각하면된다. 또한, 이는 DBMS의 하위 카테고리라고 볼 수 있다.

DBMS:
- DB Management System 로 DB를 관리하는 시스템
- DB는 여러 사람이 공유하고 사용할 목적으로 관리되는 정보
- 자료의 중복을 없애고 구조화하여 처리를 효율적으로 하기 위해 관련성을 가지며 기억시켜 놓은 데이터의 집합
- DB를 관리하여 응용프로그램들이 DB를 공유하며 사용할 수 있는 환경을 제공함
- DB를 구축하는 틀을 제공하고 검색&저장하는 기능으로 제공하며, 응용프로그램들이 DB에 접근할 수 있는 인터페이스를 제공하고 복구기능과 보안성 기능을 제공함.
- 예시: DBeaver?

RDBMS:
- DB의 한 정류로 가장 많이 사용됨. 역사가 오래되어 신뢰성이 높고, 데이터 분류, 정렬, 탐색속도가 빠름. 
- 현재 사용되는 대부분의 DB는 관계형 DB 모델을 기반으로 함.
- 모든 데이터를 2차원 테이블로 표현함. 테이블은 row(행), column(컬럼)으로 이루어진 기본 데이터 저장단위임.
- 예시: MySQL, PostgresSQL, MariaDB, Microsoft SQL Server, OracleDB

**Constratint Primary & Foreign Key?**

Primary Key(기본키):
- Table의 각 레코드를 고유하게 식별할 수 있는 값
- Table에서는 하나의 Primary Key만 있을 수 있음.
- PK는 단일 또는 복수 Column으로 구성됨

Foreign Key(외래키):
- 다른 Table의 PK를 Refers(참조)하는 값으로 Table 간의 관계를 파괴하는 작업을 방지하는 용도로 사용됨.
- PK가 있는 Table을 Parent Table이라고 하고 
- FK가 있는 Table을 Child Table이라고 하며, 이는 종속 관계가 됨.

https://carrotweb.tistory.com/225
https://carrotweb.tistory.com/226

**Vapor - Fluent란?**
- Fluent는 Swift용 ORM 프레임워크 (객체지향프로그래밍-관계형DB를 매핑하는 프레임워크)
- 쉽게 말해서 Swift의 클래스 - MariaDB의 테이블을 매핑해주는 프레임워크임
- Swift의 타입에 맞춰 데이터베이스를 사용하기 쉬운 인터페이스로 구성할 수 있도록 함
- Fluent 사용은 데이터베이스의 데이터 구조를 나타내는 모델 유형 생성을 중심으로 합니다.

**ORM이란?**
- Object Relational Mapping, 객체-관계 매핑
- 객체와 관계형 데이터베이스의 데이터를 자동으로 매핑(연결)해주는 것을 말한다.
- 객체 지향 프로그래밍은 클래스를 사용하고(Swift), 관계형 데이터베이스(MariaDB)는 테이블을 사용한다.
- 객체 모델과 관계형 모델 간에 불일치가 존재한다.
- ORM을 통해 객체 간의 관계를 바탕으로 SQL을 자동으로 생성하여 불일치를 해결
- https://gmlwjd9405.github.io/2019/02/01/orm.html 

**라우팅(Routing)이란?**

사전적 정의
- 라우팅(영어: routing)은 어떤 네트워크 안에서 통신 데이터를 보낼 때 최적의 경로를 선택하는 과정
- 최적의 경로는 주어진 데이터를 가장 짧은 거리로 또는 가장 적은 시간 안에 전송할 수 있는 경로다.
- 라우팅은 전화 통신망, 전자 정보 통신망, 그리고 교통망 등 여러 종류의 네트워크에서 사용된다.

Vapor 공식문서에서의 정의
- 라우팅은 들어오는 request에 대한 적절한 requestHandler를 찾는 과정입니다.
- vapor에선 기본적인 HTTP 요청(GET,POST,PUT,PATCH,DELTE)을 주로 사용하게 될 것임.

---

### 2주차 사전공부
- 스터디를 진행하기 전 DB에 대한 개념이 전혀 없어 찾아본 내용정리

[대략적인 DBMS 사용의 개념](https://www.youtube.com/watch?v=muOKnEIUA8Y)

### Data, DataBase, SQL, DBMS
- 서버에서 중요한 개념이 데이터베이스이다.
- 회원정보, 게시판글 등이 전부 데이터이다. 이 데이터가 모여있는 곳이 데이터베이스라고 한다.
- 데이터베이스를 사용하기위해 읽고, 쓰는 행위를 해야하는데 이것을 어떻게나는가?
- 그 것을 가능하게 하는 언어가 바로 SQL(Structured Query Language)이다.
- SQL은 데이터를 쓰거나 읽을 때 전용으로 쓰는 언어이다.
- DBMS(DataBase Management System)는 DB를 관리하는 시스템을 말한다. 
- 그 종류에는 MySQL, Oracle, Dbeaver 등이 있다.
- DB를 다룬다. (SQL로 쿼리를 짠다거나 하는 것을 말하는 것이다.)
- 사용자가 있다고 하면 회원가입할 때는 쓰기 Create, 로그인 할 때는 읽기 Read
- 회원정보를 변경한다면 Update, 게시물을 삭제한다면 Delete

### 사용
- DBMS를 설치한다.
- DBMS 내부에서 DB라는 이름으로 한번 나눠진다.
- 그 DB안쪽에서는 테이블들로 나뉜다. (회원테이블, 메뉴테이블, 게시글테이블, 댓글테이블)
- 앱 서비스를(A기능)하다가 다른 서비스(B기능)를 1개 더 만들려고하면 DB를 하나 더 생성한다.
- 테이블 내부에 글들이 쌓이면 그것을 레코드라고 부른다.
- 항목이 있을 수 있다.(회원, 제목, 내용, 날짜) 이것들을 컬럼이라고 한다.
- 테이블 하나를 만든다.(create table)
- 게시글 하나를 입력한다.(insert into table 에 글을 넣습니다.)
- 레코드들을 테이블로부터 가져온다. (select * from table)
- 삭제한다 (delete ... from table)
- where로 조건을 설정해줄 수 있다.
- 호출이라는 것을 DB에 연결해서 SQL 문장을 DBMS에 전달하면 응답으로 SQL문에 해당하는 로직의 데이터를 전달해준다. (그것이 DBMS가 하는 일이다.)
