# UMC6thAssignment
Making alarm application using DispatchQueue and DispatchWorkItem



## 개선해야할 점

- 알람을 설정해주세요 부분 60분이 초과되게끔 표시가 됨 (if 문을 사용해서 60분 초과시 시+1 되게끔 수정해야됨)
- 알람을 재설정할 때 DispatchQueue를 중간에 멈추지 못하였다.
    - DispatchWorkItem에 cancel()이 있다해서 사용해봤는데 이 또한 쉽지 않았다.
    - 재설정하게 두면 DispatchQueue가 이전꺼와 같이 돌아가 시간표기에 오류가 나서 재설정시 앱을 재시작하라고 알람이 뜨게 만들었다.
    - 추후 문법을 더 공부한다면 DispatchWorkItem - cancel()을 알아볼 것
