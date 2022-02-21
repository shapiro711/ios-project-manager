#  📝 프로젝트 매니저

- 프로젝트 진행 기간: 2021년 10월 25일 ~ 11월 19일   
- 프로젝트 진행자: 🐶[Coden](https://github.com/ictechgy), 🤡[Shapiro](https://github.com/shapiro711)

&nbsp;   

## 📚 프로젝트 설명
프로젝트 진행 상황을 Todo, Doing, Done으로 나누어 관리하는 어플리케이션
   
&nbsp;   

## 목차
+ [사용기술](#-사용-기술)
+ [실행 화면](#-실행-화면)   
+ [UML](#-uml)   
+ [주요 구현 사항](#주요-구현-사항)   
  1. [SwiftUI를 이용한 UI 구현](#1-swiftui를-이용한-ui-구현)   
      + [💫 TroubleShooting](#-swiftui-troubleshooting)   
  2. [MVVM + Clean Architecture 적용](#2-mvvm--clean-architecture-적용)   
      + [💫 TroubleShooting](#-architecture-troubleshooting)   
  3. [CoreData 구현](#3-coredata-구현)   
      + [💫 TroubleShooting](#-coredata-troubleshooting)   
  4. [Firebase 구현](#4-firebase-구현)   
      + [💫 TroubleShooting](#-firebase-troubleshooting)   
  5. [Remote-Local 동기화](#5-remote-local-동기화)  

&nbsp;

## 🔖 프로젝트 진행 방식

- 100% 페어 프로그래밍으로 진행

&nbsp;

## 🛠 사용 기술

|구현 내용|도구|
|:--:|:--:|
|아키텍쳐|MVVM + Clean Architecture|
|UI|SwiftUI|
|로컬 데이터 저장소|CoreData|
|원격 저장소|Firebase|
|동시성 프로그래밍|GCD|
   
&nbsp;

## 📱 실행 화면
|상황|실행화면|
|:--:|:--:|
|메모 추가|<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/140485980-fd9f00d4-3ae4-4bad-914e-6dbfd95713ff.gif">|
|메모 수정|<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/140485989-5178d419-16dc-4594-b0bc-3bab504afabc.gif">|
|메모 이동|<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/140485994-ba477187-1efb-4f56-96bb-a990c6d29c5c.gif">|
|메모 삭제|<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/140485996-99737473-bcb4-4b25-8d8a-a13741308d2e.gif">|
|변경 내역 확인|<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/57553889/142656788-6ce1d3d0-b31e-4e85-a433-ef08ba5e67c0.gif">|
   
&nbsp;   
   
# 🗺 UML

![https://user-images.githubusercontent.com/39452092/142631747-e8a978d9-ea52-4514-842e-071c4c62d2bc.png](https://user-images.githubusercontent.com/39452092/142631747-e8a978d9-ea52-4514-842e-071c4c62d2bc.png)
   
&nbsp;   
   
# 주요 구현 사항

1. SwiftUI를 이용한 UI 구현
2. MVVM + Clean Architecture 적용
3. CoreData 구현
4. Firebase 구현
   
&nbsp;   
   
## 1. SwiftUI를 이용한 UI 구현



UIKit으로 항상 UI 작업을 해오다 이번에 SwiftUI를 이용하여 UI 작업을 하였다.
   
&nbsp;   
   
### 구현 내용

- **화면에 데이터를 그려주고 사용자가 UI를 통해 메모의 CRUD가 가능해지도록 구현하였다.**
- 가장 상위에 나타나는 `ContentView`는 `TODO`, `DOING`, `DONE` List를 가지고 있다.
- 각각의 `MemoList`는 각각의 상태에 맞는 `MemoRow` 를 가지고 있다.
- `MemoRow`는 메모를 최종적으로 표시해주고 `MemoDetail`로의 이동, 메모의 상태 변화(TODO, DOING ...)와 스와이프 하여 삭제하는 기능을 가지고 있다.
- `MemoDetail` 는 메모의 편집, 추가, 읽기 기능을 가지고 있다.
- Popover는 `@State` 변수를 이용하였으며 나머지 상태값들은 `ViewModel`이 가지고 있도록 하였다.
- 상위뷰의 크기가 필요한 곳에서는 `GeometryReader`를 이용하였다.
   
&nbsp;   
   
### 💫 SwiftUI TroubleShooting

1. **여러개의 Row가 존재할 때 Popover가 제대로 동작하지 않는 문제가 있었다.**

<details>
<summary> <b> 문제 발생 부분 코드 </b>  </summary>
<div markdown="1">

```swift
struct MemoList: View {
    @EnvironmentObject var viewModel: MemoViewModel
    @Binding var isDetailViewPresented: Bool
    @State private var isPopoverShown = false
    let state: MemoState

    var body: some View {
            List {
                ForEach(list) { memo in
                    MemoRow(memo: memo)
                        .onTapGesture {
                            isDetailViewPresented = true
                            viewModel.readyForRead(memo)
                        }
                        .onLongPressGesture {
                            isPopoverShown = true
                        }
                        .popover(isPresented: $isPopoverShown) {
                            MemoPopover(isPopoverShown: $isPopoverShown, selectedMemo: memo)
                        }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        viewModel.delete(list[index])
                    }
                }
            }
            .listStyle(.plain)
            .background(Color(UIColor.systemGray6))
        }
    }
}
```

</div>
</details>

위의 문제는 (확실하지는 않지만) 다음과 같은 상황에 의해 발생하였다고 파악하였다. `MemoRow`가 여러개 있는 상황을 가정으로 하면:

1. `MemoRow` 중 하나를 길게 눌러 `.onLongTapGesture`를 동작시킨다. 
2. 내부 클로저에 의해 `@State` 프로퍼티인 `isPopoverShown` 의 값이 `true`로 바뀐다. 
3. `isPopoverShown`의 값에 바인딩되어 있던 popover들이 동작한다.
4. 이 때 `MemoList`의 관점에서는 모든 `MemoRow`들이 `.popover(isPresented: $isPopoverShown)`을 가지고 있으므로 모든 `MemoRow`들의 popover를 띄워주려고 한다.
5. 이 동작은 실행되지 않는다. (popover가 전체 화면에서 하나만 띄워지도록 하기 위해 이 동작을 시스템이 막은 것 아닌가 하는 추측을 하였다.)

1. **TapGesture가 제대로 동작하지 않는 문제**
- `MemoList`에서 각각의 `MemoRow`들을 만들어줄 때 `.onTapGesture{}`를 붙여줌
- `MemoRow`에서는 내부에 `.onLongPressGesture{}`를 가지고 있음

➡️ 위와 같은 상황에서 `TapGesture`가 동작하지 않는 현상이 발생하였다. `MemoRow` 내부에 있는 `LongPressGesture`를 잠시 주석처리하는 경우 `TapGesture`는 제대로 동작하였다. 우리는 외부에서 사용된 Gesture와 내부 row의 Gesture가 서로 충돌한 것이 아닐까? 라고 추측했다.  `TapGesture`와 `LongPressGesture`를 한곳에 두는 경우 이 문제는 해결할 수 있었지만 우리의 구현 방식 상 한곳에 두기가 어려웠다. 따라서 아래와 같은 방식을 이용하여 해결하였다. 

<details>
<summary> <b> 해결 코드 </b>  </summary>
<div markdown="1">

```swift
List {
    ForEach(list) { memo in
        MemoRow(memo: memo)
            .highPriorityGesture(TapGesture()
                                    .onEnded({ _ in
                isDetailViewPresented = true
                viewModel.readyForRead(memo)
            }))
    }
}
```

</div>
</details>

- `MemoRow`에 존재하는 기존 제스처(`LongPressGesture`)보다 `TapGesture`가 우선순위가 높도록 하여 attatch하였다.
- `TapGesture`가 눌렸을 때 어떤 동작을 할 것인지는 `.onEnded` 클로저를 통해 정의하였다.
   
&nbsp;   
   
2. **키보드가 올라왔을 때 할 일 입력화면인 `MemoDetail` 이 가려지는 문제**

할 일을 입력하려는 경우 아래와같이 키보드가 화면을 다 가려서 제대로 입력을 할 수 없는 문제가 발생하였다. 

<details>
<summary> <b> 문제 화면 </b>  </summary>
<div markdown="1">
<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/140492120-d25da422-8f4b-46ac-a8b0-08ba87000d46.png">
</div>
</details>

1. 우선 우리는 `MemoDetail`에 들어가는 뷰 요소들 전체를 `ScrollView`로 감싸주었다.
2. 그런데 그렇게 했더니 이번에는 `TextEditor`가 정상적으로 보이지 않는 문제가 발생하였다. (height가 0으로 잡히는 현상)
3. 이를 해결하기 위해 가장 바깥쪽을 `GeometryReader`로 한 번 더 감싸주었고 `TextEditor`의 frame을 `GeometryReader` 기준으로 설정하는 코드를 추가해주었다. 

<details>
<summary> <b> 해결 코드 </b>  </summary>
<div markdown="1">

```swift
var body: some View {
    GeometryReader { geometry in
        ScrollView {
            VStack {
                HStack {
                    leftButton
                    Spacer()
                    Text("TODO")
                    Spacer()
                    rightButton
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                VStack {
                    TextField("Title", text: $memo.title)
                        .padding()
                        .background(Color.white.shadow(color: .gray, radius: 3, x: 1, y: 4))
                    DatePicker(selection: $memo.date, label: {})
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    TextEditor(text: $memo.description)
                        .background(Color.white.shadow(color: .gray, radius: 3, x: 1, y: 4))
                        .frame(height: geometry.size.height * 0.65)
                }
                .disabled(!accessMode.isEditable)
                .padding()
            }
        }
    }
}
```

</div>
</details>

<details>
<summary> <b> 해결 뒤(키보드가 올라와있지 않을 때) </b>  </summary>
<div markdown="1">
<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/140494541-c44ec9b7-6e16-4638-bb65-4e3175cefd51.png">
</div>
</details>

<details>
<summary> <b> 해결 뒤(키보드가 올라와 있을 때) </b>  </summary>
<div markdown="1">
<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/140494565-89e1d6d4-a497-4f11-bc4c-063aac315246.png">
</div>
</details>
   
&nbsp;   
   
## 2. MVVM + Clean Architecture 적용
### 구현 내용

- Presentation Layer
    - View
    - VeiwModel
- Domain Layer
    - Entity
    - UseCase
- Data Layer
    - Repository
    - Storage
    
- **파일 구조**

![https://user-images.githubusercontent.com/39452092/142656612-3009b55c-01ca-4241-814c-1094c0790968.png](https://user-images.githubusercontent.com/39452092/142656612-3009b55c-01ca-4241-814c-1094c0790968.png)

- **Clean Architecture 적용하기 전 MVVM 기반으로 구성했다.**
    
    처음 구현을 시작할 때 `View`와 `ViewModel` 그리고 `Model`을 작성하였다.
    
    이때 구조를 `View` → `ViewModel` → `Model` → `Entity` 순으로 잡도록 노력했다.
    
    아래는 우리가 구성했던 각각의 요소이다.
    
    1. `View` - 실제 화면, 사용자와의 인터렉션을 통해 변화된 Data에 대한 화면을 업데이트 해준다.
    2. `ViewModel` - View에서 일어난 Input을 Model에 전달, 이후 내부 로직을 통해 나온 Output을 View에게 전달, 혹은 ViewModel에서 뷰의 화면 변동에 필요한 State 값 변화 처리
    3. `Model` - 비지니스 로직을 가지고 있어 각종 연산 처리
    4. `Entity` - 데이터만 가지고 있는 비지니스 모델
    
- **Clean Architecture 적용**
    - Presentation Layer
        - View - Swift UI를 사용하여 화면 요소들을 구현했다.
        - ViewModel - View에서 일어난 상호작용들을 받아 상태값을 처리하거나 코어 비지니스 로직이 있는 UseCase에 처리를 요구한다.
    - Domain Layer
        - UseCase - 앱의 핵심기능에 대한 로직을 가지고 있다. 데이터의 흐름에 따라 ViewModel과 Repository에 데이터를 넘겨준다.
        - Entity - 프로젝트에서 사용되는 Data Structure를 구현했다.
    - Data Layer
        - Repository - UseCase가 Remote, Persistent 중 어떤 Storage와 통신을 할지 고려하지 않고 사용할 수 있도록 연결고리 역할을 한다.
        - RemoteStorage - Firebase 통신 구현
        - PersistentStorage - CoreData 통신 구현
        
- **Clean Architecture의 각 Layer들에 대한 의존성 규칙**
    - Presentation Layer → Domain Layer ← Data Layer 의 방향으로 의존성을 지키려 노력했다.
        - UseCase가 Repository를 가지고 있어야 하는 경우 의존성을 역전시켜 해결했다.
            - 추상화 된 Repository
                
                ![https://user-images.githubusercontent.com/39452092/142656733-3ab85755-eea5-4c4a-9edc-1ae85821f0e9.png](https://user-images.githubusercontent.com/39452092/142656733-3ab85755-eea5-4c4a-9edc-1ae85821f0e9.png)
                
            - Repository를 사용하고 있는 UseCase
                
                <img width="700" src="https://user-images.githubusercontent.com/39452092/142656795-1caeaf33-dc4f-4d08-bdcf-00f9826b15f6.png" />
                

- **사용자 상호작용에 따라 처리해야할 Data 의 Flow를 각각 나누어 구현**
    - 데이터 - 사용자에게 보여줄 Memo와 변경내역인 History를 가지고 있다.
    - 각각의 ViewModel, UseCase, Repository, Storage를 분리시켜 기능을 분리 시키고 각각의 기능이 수정사항이 생겨도 다른 클래스에 영향이 가지 않도록 구현하였다.
   
&nbsp;   
   
### 💫 Architecture TroubleShooting

1. **View에서 모델 엔티티를 가져도 되는가에 대한 고민**

```swift
struct MemoRow: View {
    let memo: Memo
    @State private var isPopoverShown = false
		
    var body: some View {
      // some View
    }
}
```

+ 우리는 위의 코드처럼 각각의 Row가 `memo`라는 `entity`를 직접 접근하고 있는 방식으로 구현했었다.

+ [StanFord Swift UI] [https://youtu.be/oWZOFSYS5GE?t=532](https://youtu.be/oWZOFSYS5GE?t=532)

+ 위의 강의에서 `View`에게 모델을 잘게 쪼개서 보내는 방법을 추천했다.

+ 하지만 MVVM의 규칙에서 `View`는 `Model`을 `ViewModel`을 통해 접근해야 한다는 법칙을 위반한것이 아닌가? 하는 고민이 있었다.

+ MVC 패턴을 사용할때도 위와 비슷한 고민이 있었는데, `TableView`를 사용할때 `DataSource`에서 데이터를 셀에 세팅해줄 시 "구체적인 `Model` 타입을 `Cell`이라는 `View`에게 넘겨줘도 되는가?" 였다.

+ 위의 MVC패턴에 대한 고민은 많은 개발자들이 자신의 스타일을 가지고 있었고 구체적인 `Model`을 `View` 에게 넘겨주는 방법을 사용하는 개발자들도 많아 보였다.

➡️ 하지만 "*이 방식으로 구현하지 않는 것이 좋을 것 같다*"는 피드백을 받았고 `View`가 `ViewModel`을 통해 `Model`에 접근할 수 있도록 수정해주었다.
   
   &nbsp;   
   
2. **Repository 프로토콜을 제네릭을 이용하여 하나로 합칠때 발생한 문제**

우리는 UseCase에서 Repository에 어떠한 데이터(Memo, History)를 건네도 Local, Remote에 알아서 보내질 수 있도록 제네릭을 이용하여 (Repository 프로토콜들을) 합쳐보려 했다. 

제네릭을 이용하려하다 보니 `associate type`을 사용하게 되었다. 

`associate type`을 사용하다보니 UseCase에서 추상화된 Repository를 가질 수 없게 되어 의존성 역전을 이용하지 못하게 되었다. ➡️ 의존성 규칙에 문제가 생김

- 우리가 시도해본 코드

<img width="800" src="https://user-images.githubusercontent.com/39452092/142656884-1b07adc2-7322-4d72-9478-9917e5aadce5.png" />

<img width="700" src="https://user-images.githubusercontent.com/39452092/142657008-7a32c9e7-a2a1-45c0-87b1-60030bc94c5b.png" />

<img width="900" src="https://user-images.githubusercontent.com/39452092/142657162-22fd0bde-ea66-4809-beb4-736984aa2629.png" />

위와 같이 추상화된 타입을 밖에서 사용할 수 있도록 하기 위해 노력을 해보았지만

Domain Layer에 있는 HistoryUseCase가 Data Layer의 구체 타입인 HistoryRepository를 의존하도록 만들 수 밖에 없었다.

이는 Clean Architecture 의존성 규칙에 위배되므로 기존 방법인 (Memo, History에 대해) 각각의 Repository protocol이 있도록 하였다.
   
&nbsp;   
   
## 3. CoreData 구현



- CoreData 구조
    
    Entity
    
    - HistoryEntity
    - MemoEntity
    
    persistentContainer
    
    - CoreDataStorage 타입을 싱글턴으로 구현하여 각각의 Storage가 같은 persistentContainer을 이용하도록 구현하였습니다.
    
    MemoStorage
    
    - Memo에 대한 CRUD 작업이 이루어지는 타입
    
    HistoryStorage
    
    - History에 대한 Fetch 작업이 이루어지는 타입
   
&nbsp;   
   
### 💫 CoreData TroubleShooting

1. **CoreData Thread-Safety 문제**
    - 문제가 발생할 수 있는 상황
        1. 사용자가 수정과 삭제 등을 동시에 빠르게 하는 경우 이 이벤트에 대한 함수 호출들은 main thread를 타고 MemoStorage까지 흘러 들어간다. 
        2. 이때까지는 main 쓰레드가 시리얼 큐이다보니 어떤 문제가 발생하지 않지만, `persistentContainer.performBackgroundTask` 가 호출되는 경우 이야기가 달라진다. 
        3. 해당 작업들은 비동기 작업이므로 특정 작업이 끝나기 전에 다른 작업이 실행될 가능성이 있다. 따라서 여러 작업이 동시에 돌아갈 수 있게 된다. 
        4. 이 경우 데이터의 일관성 문제가 발생할 수 있다. (특정 Context에서는 1번 메모를 수정하고 있는데 다른 Context에서 해당 메모를 또 다르게 수정하고 있는 경우와 같이..) 
    - 해결법
        - `persistentContainer.performBackgroundTask`의 동작이 커스텀 시리얼 큐에서 동작하도록 구현
        - 이를 통해 여러 작업이 와도 순차적으로 실행되도록 함(Context의 최대 개수가 제한되는 효과도 생겼다.)
    - 해결 코드
    
```swift
final class CoreDataStorage {
    // 커스텀 큐
    private let coreDataSerialQueue = DispatchQueue(label: "CoreDataStorage")

    //비동기 작업이 이루어지는 메서드
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        coreDataSerialQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            self.persistentContainer.performBackgroundTask(block)
        }
    }
}
```
    
   
&nbsp;   
   
## 4. Firebase 구현



원격 저장소로 우리는 Firebase Firestore를 사용하기로 했다.

Firebase Auth 를 이용하여 기기에 대한 사용자의 ID를 받아와 Data Base를 구성했다.

- Firebase Firestore의 Data Base
    
    사용자의 고유 ID → 사용자의 메모들, 최종 수정 시각 → 각 메모들에 대한 내용
    

Data Base 구성 

![https://user-images.githubusercontent.com/39452092/142643648-2837d4df-6414-4999-97c5-1f514dd41ab7.png](https://user-images.githubusercontent.com/39452092/142643648-2837d4df-6414-4999-97c5-1f514dd41ab7.png)

- Application 에서는 FirebaseStorage 타입에서 읽기 쓰기 작업이 이루어지도록 구현하였다.

추가, 변경을 담당하는 put 메서드 구현 내용

```swift
final class FirebaseStorage {
    private let db: Firestore = Firestore.firestore()
    private let dbCollectionRef: CollectionReference
    
    init() {
        dbCollectionRef = db.collection("Memos")
    }
    
    func put(_ memo: Memo, completion: @escaping (Result<Memo, Error>) -> Void) {
        Auth.auth().signInAnonymously { [self] result, _ in
            guard let uid = result?.user.uid else {
                return completion(.failure(FirebaseError.signingFailed))
            }
            let batch = db.batch()
            
            do {
                let userDocRef = dbCollectionRef.document(uid)
                let memoRef = userDocRef.collection("UserMemos").document(memo.id.uuidString)
                batch.setData(["lastModified": Date()], forDocument: userDocRef)
                try batch.setData(from: memo, forDocument: memoRef)
            } catch {
                completion(.failure(error))
            }
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(memo))
                }
            }
        }
    }
}
```
   
&nbsp;   
   
### 💫 Firebase TroubleShooting

1. 객체 생성시 프로퍼티가 비동기적으로 초기화 됨으로 인해 생기는 문제(Auth id 얻어올 때 발생하는 문제)
    - FirebaseStorage CRUD 로직은 uid를 얻은 뒤에 이루어 져야한다.
    - FirebaseStorage의 uid 프로퍼티는 비동기적으로 얻어와 초기화 된다.
    - CRUD 로직이 실행될때 uid를 얻어오는 작업이 끝나있지 않으면 에러가 발생한다.
    - 기존 코드에서는 FirebaseStorage 객체를 생성할때 init에 이러한 uid 비동기 작업이 이루어지고 있었다..
    
    uid를 얻어오는 작업이 비동기적으로 이루어지기 때문에 각각의 CRUD 작업이 이루어지려면 uid를 받아온 후에 이루어져야 했다.
    
    우리는 아래와 같은 시도를 해보았다.
    
    <details>
    <summary> <b> 시도 1 - uid에 대해 싱글톤으로 구현하여 사용하는 방법-  </b>  </summary>
    <div markdown="1">
    
      <img width="450" src="https://user-images.githubusercontent.com/39452092/142657282-8801733a-a583-4236-8e77-c8def1408542.png" />
          
      <img width="600" src="https://user-images.githubusercontent.com/39452092/142657409-cc6422bf-7308-41f2-9157-31b0984bf63c.png" />
    
    - uid 설정을 AppDelegate에서 바로 해주도록 했다.
    - 하지만 앱이 켜질 때 uid를 이용하는 fetch도 바로 발생하다보니 uid를 얻지 못한 상태에서 사용하게 된다. (생각보다 uid를 얻어오는 작업이 시간이 걸린다...)
    
    </div>
    </details>
    
    <details>
    <summary> <b> 시도 2 - 인스턴스를 얻는 것 자체도 비동기 방식으로 구현-  </b>  </summary>
    <div markdown="1">
    
    ```swift
    final class FirebaseStorage {
        private static var shared: FirebaseStorage?
        private var uid: String
        private let db: Firestore = Firestore.firestore()
        private let dbCollectionRef: CollectionReference
        
        private init(uid: String) {
            self.uid = uid
            dbCollectionRef = db.collection("Memos")
        }
        
        static func obtainInstance(completion: @escaping (Result<FirebaseStorage, Error>) -> Void) {
            if let shared = shared {
                completion(.success(shared))
            } else {
                Auth.auth().signInAnonymously { result, error in
                    if let error = error {
                        return completion(.failure(error))
                    }
                    guard let uid = result?.user.uid else {
                        return completion(.failure(FirebaseError.signingFailed))
                    }
                    let instance = Self.init(uid: uid)
                    shared = instance
                    completion(.success(instance))
                }
            }
        }
    }
    ```
    
    - 하지만 사용하는 쪽에서는 코드 블록 Indent가 더 들어가게 된다...
    
    </div>
    </details>
    
    uid를 얻어오는 작업을 완전히 보장받기 위해 각각의 CRUD 작업을 uid를 얻어오는 블럭으로 감싸 해결했다.
    

```swift
func delete(_ memo: Memo, completion: @escaping (Result<Memo, Error>) -> Void) {
				//uid를 얻어오는 작업
        Auth.auth().signInAnonymously { [self] result, _ in
            guard let uid = result?.user.uid else {
                return completion(.failure(FirebaseError.signingFailed))
            }
						// uid를 얻어 온후에 delete 작업 시작
            let batch = db.batch()
            
            let userDocRef = dbCollectionRef.document(uid)
            let memoRef = userDocRef.collection("UserMemos").document(memo.id.uuidString)
            batch.setData(["lastModified": Date()], forDocument: userDocRef)
            batch.deleteDocument(memoRef)
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(memo))
                }
            }
        }
    }
```
   
&nbsp;   
   
## 5. Remote, Local 동기화



'여러 기기에서 같은 사용자 아이디로 동시에 읽기 쓰기 작업이 일어나는 경우' 등과 같이 여러가지 상황이 존재 할 수 있다고 판단하였다.

모든 케이스들을 고려하지는 못했지만 우리가 생각한 해결 방법은 아래와 같았다.

*현재 구상만 해놓고 프로젝트에 반영은 못하였다.*

- **앱 첫 실행시에는 항상 사용자의 Auth.auth() - uid가 Firestore에 있는지 먼저 체크한다. (사용자가 앱을 처음 사용하는 것인지 아닌지 판단)**
- 체크 성공 시
    - 사용자가 처음 설치한 것이라면
        1. CRUD 발생 시 CoreData에 먼저 저장
        2. 이후 Remote에 저장
    - 사용자가 처음 설치한 것이 아니라면
        1. 사용자에게 원격지의 데이터를 가져올 것인지 묻는다. 
        2. 사용자가 원한다고 하면 원격지의 데이터를 가져와서 로컬에 넣는다.
        3. 만약 사용자가 원치 않는다고 하면 원격지의 데이터는 전부 삭제한다. 
        4. 이후 과정은 처음 설치했을 때를 가정한 것과 동일
- 체크 실패 시(앱 설치 후 실행했는데 인터넷 연결 끊겨있어서 확인 못한 경우)
    
    → 리모트에 기존 데이터가 남아있는데 로컬에서 추가적인 변경이 일어나면 이를 동기화 하는 것이 어려움
    
    - **일단 최초 1회 인터넷 연결이 필요하다고 띄워주고 앱 실행을 대기 시킨다.**
    
- **인터넷 연결 상태 변동에 따른 flow**
    - 인터넷 연결이 끊겨있다면 CRUD는 우선 로컬에만 저장
    - 인터넷에 연결되면 로컬의 변동 내용들을 Remote에 저장
        
        → 문제는 '인터넷 연결이 끊겼다가 다시 연결되었을 때 변동내역들을 어떻게 파악하고 해당 내용들만 리모트에 올릴지'였다.
        
        1. 각각의 메모마다 동기화 됐는지 플래그 두기
        2. 동기화되지 않은 변동 내역들을 관리하는 별도의 무언가
        3. `NWPathMonitor`로 인터넷 연결상태 변경을 지켜보다가 offline → online이 될 때 전체 내용을 서버에 업데이트 하는 방식(하지만 이 방식은 오프라인상태에서 메모의 수정이 발생하고, 앱을 끈 뒤 인터넷 연결 한 상태에서 앱을 키면 이에 대한 감지가 되지 않는문제가 존재한다. 되는지 안되는지 확실치가 않다) 
        4. 로컬과 리모트에 **메모를 최종적으로 건드린 시각**에 대한 특정 데이터를 구비해두고 CRUD가 발생 할 때마다 이를 비교(인터넷 연결이 된 상태에서 최초 CRUD 발생할 때마다 해당 **수정시각 데이터**를 비교해서 최초 1번 동기화 수행해주는 방식)
            
            ➡️ 로컬은 **가장 최신 히스토리**를 쓰고 리모트에서는 **lastModified와 같은 최종 수정 시각에 대한 필드 하나**만을 두는 것이 가장 가벼워보인다.
            
            - 로컬의 최신 히스토리와 원격 lastModified 비교
                1. 앱을 아예 처음 설치해서 로컬에 히스토리가 없는 경우 - 그냥 CRUD 수행 가능
                2. 앱을 삭제했다 다시 깔아서 로컬에는 히스토리가 없는데 리모트에는 lastModified가 있는 경우 - 앱 최초 실행 시 원격지의 내용을 로컬로 가져왔을 것이다. 이 때 이후에는 그냥 CRUD를 수행하여 로컬에는 히스토리를 만들어주고 원격지의 lastModified는 변경해주기만 하면 된다.(즉 그냥 CRUD 수행 가능)
    - 일단 다중기기에 대한 부분은 고려하지 않는다. (다른 기기에 의해 리모트가 최신이 되는 상황 고려 X)
        
        → 때문에 우리는 위의 4번 문항에서 로컬 → 리모트 방향의 동기화만 일어날 것.
        
    
    **최종적으로 우리는 이런 플로우를 사용하기로 했다.**
    
    1. 앱 첫 실행시 사용자의 데이터가 원격에 있다면 사용할건지 사용자에게 물어본다. (이때는 인터넷 연결 강제)
    2. 이후 CRUD가 발생하면 로컬에 먼저 저장을 한다.
    3. 인터넷이 연결되어 있다면 CRUD 작업을 하기 전에 로컬과 리모트의 최종 수정 시각 비교 후 CRUD 작업이 이루어지고 원격의 저장소를 로컬과 동기화 시킨다.
       
&nbsp;   
   
<details>
<summary> <b> CoreData 관련 알아낸 팁 </b>  </summary>
<div markdown="1">
    
<img width="300" src="https://user-images.githubusercontent.com/39452092/142657491-283b7271-d199-418f-ab2f-aa014170cbc6.png" />
    
- CoreData에서 Entity의 attribute 값 Optional을 풀어줬는데 코드에서 반영이 안되는 문제 발생

### 해결법

<img width="350" src="https://user-images.githubusercontent.com/39452092/142657570-614e2f36-f7e3-4498-ad7b-74648aaa0f5b.png" />

1. 우선 해당 Entity의 Codegen을 `Manual/None`으로 변경한다.

<img width="350" src="https://user-images.githubusercontent.com/39452092/142657654-d00e4cdd-40c9-4adb-8731-dd99cb0ebfef.png" />

2. Editor → Create NSManagedObject Subclass 메뉴 선택 → 수정하고자 하는 Entity 체크하여 파일을 생성해준다.

<img width="250" src="https://user-images.githubusercontent.com/39452092/142657722-065140e8-f9ea-49b4-b351-ab9e97d8bd93.png" />

3. 위와같이 두개의 파일이 생성되었을 텐데 [Entity명]+CoreDataProperties 파일로 들어가준다.

<img width="700" src="https://user-images.githubusercontent.com/39452092/142657813-f3e58aa7-6183-43a9-8205-4a60c93ba009.png" />

4. 수정하고자 하는 프로퍼티의 옵셔널 변경해주자
5. 이후 빌드를 한번 쭉 돌려주자.

<img width="350" src="https://user-images.githubusercontent.com/39452092/142657880-c785dede-ca45-4545-b42d-a922c42b927a.png" />

6. 아마 [Entity명]+CoreDataProperties.swift 파일의 target이 체크되어있었을 텐데 이 '체크를 해제한 뒤에 빌드' → '다시 체크 후 빌드'해주면 문제가 해결된다. 

</div>
</details>
<details>
<summary> <b> 이외에도 마주했던 문제들과 기록들 </b>  </summary>
<div markdown="1">

1. **ContentView의 init()에서 `@StateObject viewModel` 에 접근하려 한 경우**
    - accessing state object's object without being installed on a view
    
    ➡️ 뷰에 설치되기 전에 접근하면 매번 새 인스턴스를 생성하게 된다고 경고가 나왔다. 때문에 init에서 접근하지 않도록 수정해주었다. 
    
2. **NSManagedObject를 찾는 Context와 삭제하는 Context가 다른 경우**
    - NSManagedObjectContext cannot delete objects in other contexts.
    - find를 하는 곳의 context와 검색 결과를 가지고 delete를 하는 곳의 context가 달랐었음
    
    ➡️ context를 동일하게 해줌으로써 해결하였다. 
    
3. **뷰에 반영이 될 `@Published` 프로퍼티 값을 백그라운드 쓰레드에서 변경한 경우**
    
    ![https://user-images.githubusercontent.com/39452092/142657962-71a848e1-e793-4af4-ba5f-e0ac13636883.png](https://user-images.githubusercontent.com/39452092/142657962-71a848e1-e793-4af4-ba5f-e0ac13636883.png)
    
    ![https://user-images.githubusercontent.com/39452092/142658027-9439ce5b-f1f2-4802-965d-411b08648484.png](https://user-images.githubusercontent.com/39452092/142658027-9439ce5b-f1f2-4802-965d-411b08648484.png)
    
    - Publishing changes from background threads is not allowed
    - 이 경우 뷰가 제대로 업데이트 되지 않는 상황 발생(어쩔 땐 업데이트 되기도 하는데 신기함)
    
     ➡️ 메인쓰레드에서 변경이 일어나도록 수정하였다.
    
4. **NSManagedObject에 대해 context.delete()를 하고 context.save()를 한 뒤에 접근하려 한 경우**
    
<img width="700" src="https://user-images.githubusercontent.com/39452092/142658101-766df2ba-5522-489c-affd-df9d477c982e.png" />
    
    - 위쪽 출력문은 context.delete()만 했을 때
    - 아래쪽 출력문은 context.save() 한 이후
    
    ➡️ save가 되자마자 NSManagedObject는 사라지고 memoEntity 참조 변수는 dangling pointer가 된 듯
    
5. 메모 삭제는 잘 됐는데 메모의 state를 바꾸는 부분(MemoListViewModel - moveColumn)에서 문제가 생김. 경로를 따라가보니 MemoStorage의 update쪽이 실행되면서 생기는 문제
    
    ![https://user-images.githubusercontent.com/39452092/142658153-90d281f4-9ae3-4e60-8883-159a3f274d37.png](https://user-images.githubusercontent.com/39452092/142658153-90d281f4-9ae3-4e60-8883-159a3f274d37.png)
    
    - MemoStorage의 find메서드에서 MemoEntity.fetchRequest()를 할 때 NSFetchReuqest를 LLDB에서 찍어보면 아래와 같이 이상하게 나온다.
    
    ![https://user-images.githubusercontent.com/39452092/142658272-88de9282-1191-4441-a45f-5cac5b8763a6.png](https://user-images.githubusercontent.com/39452092/142658272-88de9282-1191-4441-a45f-5cac5b8763a6.png)
    

<img width="600" src="https://user-images.githubusercontent.com/39452092/142659321-19260e3b-ec28-4c97-be71-6a3ba22783ee.png" />

- Coden의 생각: Context가 매번 달라서 생기는 문제인가? fetch를 할 때 이미 데이터들을 특정 Context에 올려두었는데 변경/삭제 등을 할 때 또다른 Context에 동일한 NSManagedObject를 올려두고 써서? (데이터의 일관성 문제?)

> Changes to managed objects remain in memory in the associated context until Core Data saves that context to one or more persistent stores. A single managed object instance exists in one and only one context, but multiple copies of an object can exist in different contexts. Therefore, an object is unique to a particular context.
> 

- CoreData에서 가져온 NSManagedObject 내용을 출력해봤을 때 data가 <fault>인 이유
    - [https://stackoverflow.com/questions/7304257/coredata-error-data-fault](https://stackoverflow.com/questions/7304257/coredata-error-data-fault)

➡️ **이 문제를 해결한 방법**

- CoreData Entity의 특정 attribute에 String으로 값을 넣겠다고 했는데 Swift 값 그 자체(enum)을 자꾸 넣으려고 했다...

1. history 구현 방식 구상
    
<img width="500" src="https://user-images.githubusercontent.com/39452092/142659818-dbcb7bf4-1ca7-4154-9087-4ec594f75d82.png" />
    
- 간단하게 구현해보자!
- **MemoHistory**와 기존 **MemoEntity Table**간의 관계도 구성해봄직 했으나(다:1 관계), 메모가 삭제되는 경우 해당 메모에 대한 히스토리가 관계를 잃어버린다는 문제가 생긴다. (제약조건 위배)
        
        
    
![https://user-images.githubusercontent.com/39452092/142659939-6caefbf3-d8d6-467f-9159-e7dcd2f58731.png](https://user-images.githubusercontent.com/39452092/142659939-6caefbf3-d8d6-467f-9159-e7dcd2f58731.png)
    
- 위와 같이 해도 49번 라인에서 생성된 HistoryEntity는 63번 라인에서 저장이 될까?
- context내에 생성을 한 것이니까 인스턴스가 사라지지 않고 그대로 남아있다가 저장까지 되지 않을까?

    > Changes to managed objects remain in memory in the associated context until Core Data saves that context to one or more persistent stores. - NSManagedObjectContext 공식 문서
    > 

➡️ 저장이 된다.
    

</div>
</details>
