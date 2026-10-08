package review;

import java.util.List;

/*
	리뷰 관련 비즈니스 로직(규칙 검증, 데이터 가공, 권한 확인 등)을 처리하는 서비스 클래스
	controller(서블릿)와 ReviewDAO 사이에서 중계 및 유효성 검사를 담당합니다.
*/
public class ReviewService {

	//DB 작업을 위임할 DAO 객체 생성
	private ReviewDAO reviewDAO = new ReviewDAO();
	
	//===============================
	//1. 리뷰 작성 (비즈니스 유효성 검증 포함)
	//===============================
	
	/*
		사용자가 제출한 리뷰 데이터를 검증한 후 DB에 저장을 요청합니다.
		
		1. 작성자(memberId) 또는 영화 번호(movieId)가 없으면 등록 불가
		2. 리뷰 내용(content)이 비어있거나 공백만 있으면 등록 불가
		3. 별점은 1점 이상 10점 이하만 허용
		
		@param dto 화면에서 넘어온 리뷰 정보
		@return 등록 성공 시 true, 검증 실패 또는 DB 오류 시 false
	*/
	public boolean addReview(ReviewDTO dto) {
		// 1. 필수 파라미터 체크
		if (dto == null || dto.getMemberId() == null || dto.getMovieId() <= 0) {
				System.out.println("[ReviewService] 필수 정보 누락 (회원 아이디 또는 영화 번호 없음)");
				return false;
		}
				
		// 2. 내용 빈값 체크
		if (dto.getContent() == null || dto.getContent().trim().isEmpty()) {
				System.out.println("[ReviewService] 리뷰 내용이 비어있습니다.");
				return false;
		}
				
		// 3. 별점 범위 체크 (1 ~ 10점) 
		if (dto.getRating() < 1 || dto.getRating() > 10) {
				System.out.println("[ReviewService] 별점 범위 오류(1~10점만 가능) : " + dto.getRating());
				return false;
		}
				
		// 4. 모든 검증을 통과하면 DAO를 통해 DB 저장
		int result = reviewDAO.insertReview(dto);
		return result == 1;
	}
	
	//===========================
	//2. 특정 영화의 리뷰 목록 조회
	//===========================
	
	/*
		특정 영화에 달린 리뷰 목록을 가져옵니다.
		@param movieId 영화 고유 번호
		@return 리뷰 리스트 (리뷰가 없으면 빈 리스트 반환)
	*/
	public List<ReviewDTO> getMovieReviews(int movieId) {
		if (movieId <= 0) {
			return null;
		}
		return reviewDAO.getReviewsByMovieId(movieId);
	}
	
	//=======================
	//3. 영화 평균 별점 조회
	//=======================
	
	/*
		특정 영화의 평균 별점을 가져옵니다.
		@param movieId 영화 고유 번호
		@return 평균 별점 (소수점 1자리 형태, 예 : 9.2)
	*/
	public double getMovieAvgRating(int movieId) {
		if (movieId <= 0) {
			return 0.0;
		}
		return reviewDAO.getAvgRating(movieId);
	}
	
	//============================
	//4. 실관람객 인증 여부 확인
	//============================
	
	/*
		로그인한 사용자가 이 영화를 실제로 관람/예매했는지 확인합니다.
		화면에서 [실관람객 인증] 마크를 띄우거나, 실관람객 전용 혜택을 줄 때 활용됩니다.
		@param memberId 회원 아이디
		@param movieId 영화 고유 번호
		@return 실관람객이면 true, 아니면 false
	*/
	public boolean isVerifiedAudience(String memberId, int movieId) {
		//비회원이거나 잘못된 영화 번호인 경우 무조건 false
		if (memberId == null || memberId.trim().isEmpty() || movieId <= 0) {
			return false;
		}
		return reviewDAO.checkAudience(memberId, movieId);
	}
	
	//====================
	//5. 리뷰 삭제
	//====================
	
	/*
		자신이 작성한 리뷰를 삭제합니다.
		@param reviewId 삭제할 리뷰 번호
		@param loginMemberId 현재 로그인한 사용자의 아이디
		@return 삭제 성공 시 true, 실패 시 false
	*/
	public boolean removeReview(int reviewId, String loginMemberId) {
		if (reviewId <= 0 || loginMemberId == null) {
			return false;
		}
		int result = reviewDAO.deleteReview(reviewId, loginMemberId);
		return result == 1;
	}
	
	//================================================
	// 6. 전체 최신 리뷰 목록 조회 
	//================================================
	public List<ReviewDTO> getRecentReviews(int limit) {
		return reviewDAO.getRecentReviews(limit);
	}
	
	//====================
	// 7. 리뷰 수정
	//====================
	
	/*
	사용자가 수정한 리뷰 데이터를 검증한 후 DB 갱신을 요청합니다.
	
	1. 수정 대상 리뷰 번호(reviewId) 또는 작성자 아이디(memberId) 누락 시 수정 불가
	2. 수정할 내용(content)이 비어있거나 공백만 있으면 수정 불가
	3. 별점은 1점 이상 10점 이하만 허용
	
	@param dto 화면에서 넘어온 수정 리뷰 정보 (reviewId, memberId, rating, content)
	@return 수정 성공 시 true, 검증 실패 또는 DB 오류 시 false
	*/
	public boolean modifyReview(ReviewDTO dto) {
		if (dto == null || dto.getReviewId() <= 0 || dto.getMemberId() == null) {
			return false;
		}
		if (dto.getContent() == null || dto.getContent().trim().isEmpty()) {
			return false;
		}
		if (dto.getRating() < 1 || dto.getRating() > 10) {
			return false;
		}
		int result = reviewDAO.updateReview(dto);
		return result == 1;
	}
	
	
	
}
