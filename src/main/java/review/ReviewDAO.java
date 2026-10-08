package review;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

//리뷰 테이블과 연동하여 CRUD(Create, Read, Update, Delete) 작업을 수행하는 클래스
public class ReviewDAO {
	
	//====================================================
	//1. 데이터베이스 접속 설정 정보
	//(DB 스키마 : moviebox / 계정 : teamid / 암호 : teampass)
	//====================================================
	private final String DRIVER = "com.mysql.cj.jdbc.Driver";
	private final String URL = "jdbc:mysql://localhost:3306/moviebox?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8";
	private final String USER = "teamid";
	private final String PASS = "teampass";
	
	//데이터베이스 연결 객체(Connection)를 반환하는 공통 메소드
	private Connection getConnection() throws  Exception {
		Class.forName(DRIVER);
		return DriverManager.getConnection(URL, USER, PASS);
	}
	
	/*
	 	DB 작업 후 자원을 안전하게 반환(닫기)하는 공통 메소드
	 	메모리 누수 및 DB 커넨션 고갈을 방지하기 위해 finally 블록에서 호출합니다.
	*/
	private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if (rs != null) {
			try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
		}
		if (pstmt != null) {
			try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
		}
		if (conn != null) {
			try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
		}
	}
	
	//====================================
	//2. 리뷰 등록 (CREATE)
	//====================================
	
	/*
		신규 리뷰를 데이터베이스에 저장합니다.
		@param dto 사용자가 입력한 리뷰 정보 (movieId, memberId, rating, content)
		@return 성공 시 반영된 행의 수(1), 실패 시 0 또는 -1
	*/
	public int insertReview(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int result = 0;
		
		//review_id는 AUTO_INCREMENT, reg_date는 CURRENT_TIMESTMAP, like_count는 기본값 0 자동 처리
		String sql = "INSERT INTO review (movie_id, member_id, rating, content) VALUES (?, ?, ?, ?)";
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			
			//매개변수 바인딩 (물음표 채우기)
			pstmt.setInt(1, dto.getMovieId());
			pstmt.setString(2, dto.getMemberId());
			pstmt.setInt(3, dto.getRating());
			pstmt.setString(4, dto.getContent());
			
			result = pstmt.executeUpdate(); //쿼리 실행 (1 반환 시 성공)
		} catch (Exception e) {
			System.err.println("[ReviewDAO] insertReview 에러 발생 : " + e.getMessage());
			e.printStackTrace();
		} finally {
			close(conn, pstmt, null);
		}
		
		return result;
	}
	
	//=====================================
	//3. 특정 영화의 리뷰 목록 조회 (READ)
	//=====================================
	
	/*
		특정 영화(movieId)에 등록된 리뷰 목록을 최신 등록순으로 가져옵니다.
		작성자 이름(member_name)을 화면에 함께 띄우기 위해 member 테이블과 JOIN 합니다.
		@param movieId 조회하려는 영화 고유 번호
		@return ReviewDTO 리스트
	*/
	public List<ReviewDTO> getReviewsByMovieId(int movieId) {
		List<ReviewDTO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT r.review_id, r.movie_id, r.member_id, r.rating, r.content, "
				   + "       r.reg_date, r.like_count, m.member_name "
				   + "FROM review r "
				   + "JOIN member m ON r.member_id = m.member_id "
				   + "WHERE r.movie_id = ? "
				   + "ORDER BY r.review_id DESC"; //최신순 정렬
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, movieId);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				ReviewDTO dto = new ReviewDTO();
				dto.setReviewId(rs.getInt("review_id"));
				dto.setMovieId(rs.getInt("movie_id"));
				dto.setMemberId(rs.getString("member_id"));
				dto.setRating(rs.getInt("rating"));
				dto.setContent(rs.getString("content"));
				dto.setRegDate(rs.getTimestamp("reg_date"));
				dto.setLikeCount(rs.getInt("like_count"));
				dto.setMemberName(rs.getString("member_name")); //JOIN으로 가져온 회원 이름
				
				// ★ 각 작성자별 실관람 여부 조회 및 저장
			    dto.setAudience(checkAudience(dto.getMemberId(), dto.getMovieId()));
				
				list.add(dto);
			}
		} catch (Exception e) {
			System.err.println("[ReviewDAO] getReviewsByMovieId 에러 발생 : " + e.getMessage());
			e.printStackTrace();
		} finally {
			close(conn, pstmt, rs);
		}
		
		return list;
	}
	
	//===============================
	//4. 영화별 평균 평점 및 리뷰 수 조회 
	//===============================
	
	/*
		특정 영화의 평균 별점을 계산합니다. 
		@param movieId 영화 번호
		@return 평균 별점 (리뷰가 없으면 0.0)
	*/
	public double getAvgRating(int movieId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double avg = 0.0;
		
		String sql = "SELECT IFNULL(ROUND(AVG(rating), 1), 0.0) AS avg_rating "
				   + "FROM review WHERE movie_id = ?";
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, movieId);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				avg = rs.getDouble("avg_rating");
			}
		} catch (Exception e) {
			System.err.println("[ReviewDAO] getAvgRating 에러 발생 : " + e.getMessage());
			e.printStackTrace();
		} finally {
			close(conn, pstmt, rs);
		}
		
		return avg;
	}
	
	//===============================
	//5. 실관람객 인증 여부 확인
	//===============================
	
	/*
		해당 회원이 이 영화를 실제로 예매(booking)한 이력이 있는지 검증합니다.
		@param memberId 회원 아이디
		@param movieId 영화 번호
		@return 예매 내역이 1건 이상이면 true, 없으면 false
	*/
	public boolean checkAudience(String memberId, int movieId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean isAudience = false;
		
		//booking 테이블과 showing 테이블을 JOIN 하여 회원이 해당 영화를 예매했는지 검사
		String sql1 = "SELECT COUNT(*) AS cnt FROM reservation WHERE member_id = ? AND movie_id = ?";
		
		String sql2 = "SELECT COUNT(*) AS cnt FROM booking b JOIN showing s ON b.showing_id = s.showing_id WHERE b.member_id = ? AND s.movie_id = ?";
		
		try {
			conn = getConnection();
			try {
				pstmt = conn.prepareStatement(sql1);
				pstmt.setString(1, memberId);
				pstmt.setInt(2, movieId);
				rs = pstmt.executeQuery();
				if (rs.next() && rs.getInt("cnt") > 0) {
					isAudience = true;
				}
			} catch (SQLException e) {
				// reservation 테이블이 없으면 fallback으로 booking 쿼리 실행
				close(null, pstmt, rs);
				pstmt = conn.prepareStatement(sql2);
				pstmt.setString(1, memberId);
				pstmt.setInt(2, movieId);
				rs = pstmt.executeQuery();
				if (rs.next() && rs.getInt("cnt") > 0) {
					isAudience = true;
				}
			}
		} catch (Exception e) {
			System.err.println("[ReviewDAO] checkAudience 에러: " + e.getMessage());
		} finally {
			close(conn, pstmt, rs);
		}
		
		return isAudience;
	}	
		
	//=========================
	//6. 리뷰 삭제 (DELETE)
	//=========================
	
	/*
		자신이 작성한 리뷰를 삭제합니다. (보안을 위해 작성자 아이디 검증 병행)
		@param reviewId 삭제할 리뷰 번호
		@param memberId 로그인한 작성자 아이디
		@return 삭제된 행의 수 (1 이면 성공)
	*/
	public int deleteReview(int reviewId, String memberId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int result = 0;
		
		String sql = "DELETE FROM review WHERE review_id = ? AND member_id = ?";
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, reviewId);
			pstmt.setString(2, memberId);
			
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			System.err.println("[ReviewDAO] deleteReview 에러 발생 : " + e.getMessage());
			e.printStackTrace();
		} finally {
			close(conn, pstmt, null);
		}
		
		return result;
	}
	
	//================================================
	// 7. 전체 최신 리뷰 목록 조회 
	//================================================
	public List<ReviewDTO> getRecentReviews(int limit) {
		List<ReviewDTO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
			
		String sql = "SELECT r.review_id, r.movie_id, r.member_id, r.rating, r.content, "
				   + "       r.reg_date, r.like_count, m.member_name, mv.title AS movie_title "
				   + "FROM review r "
				   + "JOIN member m ON r.member_id = m.member_id "
				   + "LEFT JOIN movie mv ON r.movie_id = mv.movie_id "
				   + "ORDER BY r.review_id DESC LIMIT ?";
			
		try {
				conn = getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, limit);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					ReviewDTO dto = new ReviewDTO();
					dto.setReviewId(rs.getInt("review_id"));
					dto.setMovieId(rs.getInt("movie_id"));
					dto.setMemberId(rs.getString("member_id"));
					dto.setRating(rs.getInt("rating"));
					dto.setContent(rs.getString("content"));
					dto.setRegDate(rs.getTimestamp("reg_date"));
					dto.setLikeCount(rs.getInt("like_count"));
					dto.setMemberName(rs.getString("member_name"));
					dto.setMovieTitle(rs.getString("movie_title"));
					dto.setAudience(checkAudience(dto.getMemberId(), dto.getMovieId()));
					list.add(dto);
				}
		} catch (Exception e) {
			System.err.println("[ReviewDAO] getRecentReviews 에러: " + e.getMessage());
		} finally {
			close(conn, pstmt, rs);
		}
		return list;
		}
	
	//=========================
    // 8. 리뷰 수정 (UPDATE)
	//=========================
	
	/*
		자신이 작성한 리뷰의 별점과 내용을 수정합니다.
		@param dto 수정할 리뷰 정보 (reviewId, memberId, rating, content)
		@return 반영된 행의 수 (1이면 성공)
	*/
	public int updateReview(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int result = 0;
		
		String sql = "UPDATE review SET rating = ?, content = ? WHERE review_id = ? AND member_id = ?";
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getRating());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getReviewId());
			pstmt.setString(4, dto.getMemberId());
			
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			System.err.println("[ReviewDAO] updateReview 에러 발생 : " + e.getMessage());
			e.printStackTrace();
		} finally {
			close(conn, pstmt, null);
		}
		
		return result;
	}
	
	
}

