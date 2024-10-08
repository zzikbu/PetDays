enum DiaryStatus {
  init, // DiaryState를 최초로 객체 생성한 상태
  submitting, // 게시글을 등록하는 중인 상태
  success, // 작업이 성공한 상태
  error, // 작업이 실패한 상태
}

class DiaryState {
  final DiaryStatus diaryStatus;

  const DiaryState({
    required this.diaryStatus,
  });

  factory DiaryState.init() {
    return DiaryState(diaryStatus: DiaryStatus.init);
  }

  DiaryState copyWith({
    DiaryStatus? diaryStatus,
  }) {
    return DiaryState(
      diaryStatus: diaryStatus ?? this.diaryStatus,
    );
  }
}