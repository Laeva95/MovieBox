package review;

import java.sql.Timestamp;

public class ReviewDTO {

	//1. review 테이블 컬럼 매핑 필드
	private int reviewId;      //review_id (PK)
	private int movieId;       //movie_id (FK : 영화 번호)
	private String memberId;   //member_id (FK : 작성자 아이디)
	private int rating;        //rating (별점 : 1 ~ 10)
	private String content;    //content (한줄평 내용)
	private Timestamp regDate; //reg_date (작성일시)
	private int likeCount;     //like_count (좋아요 수)
	
	//2. 화면 출력용 보조 필드 (JOIN 쿼리 결과를 담기 위한 용도)
	private String memberName; //작성자 이름 (member 테이블과 JOIN 시 사용)
	private String movieTitle; //영화 제목 (movie 테이블과 JOIN 시 사용)
	
	//3. 기본 생성자
	public ReviewDTO() {}
	
	//4. 리뷰 등록 시 사용하는 필수 생성자 (리뷰번호, 작성일, 좋아요 수는 DB가 자동 처리)
	public ReviewDTO(int movieId, String memberId, int rating, String content) {
		this.movieId = movieId;
		this.memberId = memberId;
		this.rating = rating;
		this.content = content;
	}

	//5. Getter & Setter 메소드
	public int getReviewId() {
		return reviewId;
	}

	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}

	public int getMovieId() {
		return movieId;
	}

	public void setMovieId(int movieId) {
		this.movieId = movieId;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Timestamp getRegDate() {
		return regDate;
	}

	public void setRegDate(Timestamp regDate) {
		this.regDate = regDate;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getMovieTitle() {
		return movieTitle;
	}

	public void setMovieTitle(String movieTitle) {
		this.movieTitle = movieTitle;
	}
	
	//6. 디버깅 및 콘솔 확인용 toString()
	@Override
	public String toString() {
		return "ReviewDTO [reviewId=" + reviewId + ", movieId=" + movieId + ", memberId=" + memberId
				+ ", rating=" + rating + ", content=" + content + ", regDate=" + regDate
				+ ", likeCount=" + likeCount + "]";
	}
	
}
