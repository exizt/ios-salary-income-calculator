### 버전 룰 ###
1. (1.2.0) 이라고 예를 들때, 순서대로 major.minor.maintenance 라고 하자. 예시에서 major 는 1, minor 는 2, maintenance 는 0 이다.
2. major 넘버는 거의 올리지 않는다.
3. minor 넘버는 ui 에 변경이 느껴지거나 메뉴 추가, 아이템 추가 등이 되었을 때에 카운팅 (숫자증가) 를 한다.
4. maintenance 넘버는 계속 올린다. 그냥 계속 올린다. 작업할 때마다 올린다. 앞의 minor가 변경되면 다시 0부터 올린다.
5. 빌드 단계의 넘버링에서는 major 와 minor 는 일치시키되, maintenance 는 가차없이 계속 카운팅 한다. 
6. 스토어 단계의 넘버링 에서는 major 와 minor 는 일치시키고, maintenance 는 0부터 순차적으로 카운팅 한다. 가끔 귀찮으면 훅 올라가도 좋다.(갭이 너무 클 경우에. 빌드 넘버링과 일치시키는 과정)

### TODO 목록 ###
1. 보험별 계산 과정 보기.
2. 세율 변경 시 알려주는 기능
3. 세금 역 계산기
4. 입력 화면 변경

### Bug 목록 ###
1. 이따금 '결과 상세보기' 에서 segmented control 을 체인지 했을 때, 글이 안 나오는 경우가 있음 : 원인 분석 중



# 사용된 라이브러리
    1. (필수) AEXML : XML 파싱 목적 / https://github.com/tadija/AEXML
    2. 구글 애드몹 광고 (용량이 70MB 정도함)
        - GoogleAppMeasurement
        - Google-Mobile-Ads-SDK
        - GoogleUtilities
        - nanopb


# Git 관련
    - 용량을 줄이기 위해서, 애드몹 코드는 제외시키기로 함. (70MB 감소)
    - AEXML 은 용량이 작은데다가 필수적이므로 두기로 함.
