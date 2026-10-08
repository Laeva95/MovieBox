package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.InitialContext;
import javax.sql.DataSource;

import movie.MovieDTO;
import review.ReviewDTO;

public class MemberDAO {
	// 커넥션풀 (DB 연결을 미리 여러 개 만들어 둔 보관함)
	private DataSource ds;

	//----------------------------------------------------------------
	// 생성자 : new MemberDAO() 할 때 딱 1번 실행되어 커넥션풀을 찾아 둔다
	//----------------------------------------------------------------
	public MemberDAO() {
		try {
			InitialContext ctx = new InitialContext(); // 톰캣의 "이름 → 자원" 전화번호부를 연다
			ds = (DataSource) ctx.lookup("java:comp/env/jdbc/moviebox"); // 이름으로 커넥션풀을 찾는다. (DataSource) = 찾은 물건을 커넥션풀 자료형으로 바꿔 받는다
		} catch (Exception e) {
			System.out.println("[MemberDAO] 커넥션풀 찾기 실패 : " + e); // context.xml 설정이 틀렸거나 DB 드라이버(jar)가 없으면 여기로 온다
		}
	}
	
	public int kakaoLogin(MemberDTO member) {

	    int result = 0;

	    // 1. 먼저 카카오 회원이 이미 존재하는지 확인
	    String selectSql =
	            "SELECT member_id FROM member WHERE member_id = ?";

	    try (Connection con = ds.getConnection();
	         PreparedStatement pstmt = con.prepareStatement(selectSql)) {

	        pstmt.setString(1, member.getMember_id());

	        try (ResultSet rs = pstmt.executeQuery()) {

	            // 이미 회원이 존재한다면
	            if (rs.next()) {
	                result = 1;
	                return result;
	            }
	        }

	        // 2. 회원이 없다면 회원가입
	        String insertSql =
	                "INSERT INTO member (member_id, member_pass, member_name) "
	              + "VALUES (?, ?, ?)";

	        try (PreparedStatement insertPstmt =
	                con.prepareStatement(insertSql)) {

	            insertPstmt.setString(1, member.getMember_id());
	            
	            // 카카오 로그인은 MovieBox 비밀번호를 사용하지 않으므로 임의의 문자열을 대입
	            insertPstmt.setString(2, "password");
	            
	            insertPstmt.setString(3, member.getMember_name());
	            
	            result = insertPstmt.executeUpdate();
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}
	
	// 입력 받은 id를 통해 비밀번호를 조회하는 메소드
	public String getPassword(String id) {
		String sql = "select member_pass from member where member_id=?";
		try (Connection con = ds.getConnection();
			 PreparedStatement pstmt = con.prepareStatement(sql)) {
			pstmt.setString(1, id);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {                  // 결과가 있다 = 가입된 아이디다
					return rs.getString("member_pass");  // pass 열의 값을 글자로 꺼내 돌려준다
				}
			}
		} catch (Exception e) {
			System.out.println("[MemberDAO] getPassword 오류 : " + e);
		}
		return null; // 없는 아이디 (또는 오류)
	}
	
	// 입력 받은 id를 통해 이름을 조회하는 메소드
	public String getName(String id) {
		String sql = "select member_name from member where member_id=?";
		try (Connection con = ds.getConnection();
			 PreparedStatement pstmt = con.prepareStatement(sql)) {
			pstmt.setString(1, id);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {                  // 결과가 있다 = 가입된 아이디다
					return rs.getString("member_name");  // pass 열의 값을 글자로 꺼내 돌려준다
				}
			}
		} catch (Exception e) {
			System.out.println("[MemberDAO] getName 오류 : " + e);
		}
		return null; // 없는 아이디 (또는 오류)
	}
	
	// dto 객체를 통해 회원 테이블에 행 하나를 추가하는 메소드
	public int insertMember(MemberDTO dto) {
		// (덧붙임) now() = MySQL 함수. 지금 날짜와 시간을 가입일(reg_date)로 넣는다
		String sql = "insert into member(member_id, member_pass, member_name, age, gender, email, address, tel, mtel)"
				   + " values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try (Connection con = ds.getConnection();
			 PreparedStatement pstmt = con.prepareStatement(sql)) {

			pstmt.setString(1, dto.getMember_id());      
			pstmt.setString(2, dto.getMember_pass());    
			pstmt.setString(3, dto.getMember_name());   
			pstmt.setInt(4, dto.getAge());   
			pstmt.setString(5, dto.getGender());        
			pstmt.setString(6, dto.getEmail());   
			pstmt.setString(7, dto.getAddress());  
			pstmt.setString(8, dto.getTel());      
			pstmt.setString(9, dto.getMtel());       
			return pstmt.executeUpdate();         
		} catch (Exception e) {
			System.out.println("[MemberDAO] insertMember 오류 : " + e);
		}
		return 0;
	}
	
	// 회원 id가 이미 테이블에 존재하는지 조회하는 메소드
	public boolean isMemberIdDuplicate(String memberId) {
	    String sql = "select count(*) from member where member_id = ?";
	    try (
	        Connection con = ds.getConnection();
	        PreparedStatement pstmt = con.prepareStatement(sql);) {

	        pstmt.setString(1, memberId);
	        ResultSet rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            int count = rs.getInt(1);
	            return count > 0;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	// id를 통해 회원 정보 전체를 조회하는 메소드
	public MemberDTO getMember(String id) {

	    MemberDTO member = null;

	    String sql = "SELECT * FROM member WHERE member_id = ?";

	    try (
	        Connection con = ds.getConnection();
	        PreparedStatement pstmt = con.prepareStatement(sql);
	    ) {

	        pstmt.setString(1, id);

	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            member = new MemberDTO();

	            member.setMember_id(rs.getString("member_id"));
	            member.setMember_name(rs.getString("member_name"));
	            member.setAge(rs.getInt("age"));
	            member.setGender(rs.getString("gender"));
	            member.setEmail(rs.getString("email"));
	            member.setAddress(rs.getString("address"));
	            member.setTel(rs.getString("tel"));
	            member.setMtel(rs.getString("mtel"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return member;
	}
	// 회원 정보를 수정하는 메소드
	public int updateMember(String id, String email, String address, String tel, String mtel, String age, String gender) {
	    int result = 0;
	    int ageInt = Integer.parseInt(age);

	    String sql =
	        "UPDATE member " +
	        "SET email = ?, " +
	        "    address = ?, " +
	        "    tel = ?, " +
	        "    mtel = ?, " +
	        "	 age = ?, " + 
	        " 	 gender = ? " +
	        "WHERE member_id = ?";
	    try (
	        Connection con = ds.getConnection();
	        PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setString(1, email);
	        pstmt.setString(2, address);
	        pstmt.setString(3, tel);
	        pstmt.setString(4, mtel);
	        pstmt.setInt(5, ageInt);
	        pstmt.setString(6, gender);
	        pstmt.setString(7, id);

	        result = pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}
	// 회원 이름, 이메일을 통해 id를 조회하는 메소드
	public List<String> findMemberIds(String name, String email) {

	    List<String> memberIds = new ArrayList<>();

	    String sql =
	        "SELECT member_id " +
	        "FROM member " +
	        "WHERE member_name = ? " +
	        "AND email = ?";

	    try (
	        Connection con = ds.getConnection();
	        PreparedStatement pstmt = con.prepareStatement(sql)
	    ) {

	        pstmt.setString(1, name);
	        pstmt.setString(2, email);

	        try (ResultSet rs = pstmt.executeQuery()) {

	            while (rs.next()) {
	                memberIds.add(rs.getString("member_id"));
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return memberIds;
	}
	
	// 회원 id, 이름, 이메일을 통해 비밀번호 재설정 가능 여부를 확인하는 메소드
	public boolean verifyMemberForPasswordReset(
	        String memberId,
	        String name,
	        String email) {

	    String sql =
	        "SELECT member_id " +
	        "FROM member " +
	        "WHERE member_id = ? " +
	        "AND member_name = ? " +
	        "AND email = ?";

	    try (
	        Connection con = ds.getConnection();
	        PreparedStatement pstmt = con.prepareStatement(sql)
	    ) {

	        pstmt.setString(1, memberId);
	        pstmt.setString(2, name);
	        pstmt.setString(3, email);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            return rs.next();
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}
	// 회원 id를 통해 비밀번호를 업데이트하는 메소드
	public int updatePassword(
	        String memberId,
	        String hashedPassword) {

	    String sql =
	        "UPDATE member " +
	        "SET member_pass = ? " +
	        "WHERE member_id = ?";

	    try (
	        Connection con = ds.getConnection();
	        PreparedStatement pstmt = con.prepareStatement(sql)
	    ) {

	        pstmt.setString(1, hashedPassword);
	        pstmt.setString(2, memberId);

	        return pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	// 회원이 찜한 영화 목록을 조회하는 메소드
	public List<MovieDTO> getFavoriteMovies(String memberId) {

	    List<MovieDTO> list = new ArrayList<>();

	    String sql =
	            "SELECT m.movie_id, m.title, m.genre, m.running_time, "
	          + "       m.release_date, m.poster, m.summary, "
	          + "       m.director, m.actors, m.country "
	          + "FROM movie_favorite f "
	          + "JOIN movie m ON f.movie_id = m.movie_id "
	          + "WHERE f.member_id = ? "
	          + "ORDER BY f.created_at DESC";

	    try (Connection conn = ds.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, memberId);
	        try (ResultSet rs = pstmt.executeQuery()) {

	            while (rs.next()) {

	                MovieDTO movie = new MovieDTO();

	                movie.setMovieId(rs.getInt("movie_id"));
	                movie.setTitle(rs.getString("title"));
	                movie.setGenre(rs.getString("genre"));
	                movie.setRunningTime(rs.getString("running_time"));
	                movie.setReleaseDate(rs.getString("release_date"));
	                movie.setPoster(rs.getString("poster"));
	                movie.setSummary(rs.getString("summary"));
	                movie.setDirector(rs.getString("director"));
	                movie.setActors(rs.getString("actors"));
	                movie.setCountry(rs.getString("country"));

	                list.add(movie);
	            }
	        }

	    } catch (Exception e) {
	        System.out.println("찜한 영화 상세 목록 조회 중 오류 발생");
	        e.printStackTrace();
	    }

	    return list;
	}
	// 회원이 작성한 리뷰 목록을 조회하는 메소드
	public List<ReviewDTO> getReviewsByMemberId(String memberId) {
		
		// memberId가 null이거나 공백인 경우 빈 리스트를 반환
		if (memberId == null || memberId.trim().isEmpty()) {
	        return java.util.Collections.emptyList();
	    }

	    List<ReviewDTO> list = new ArrayList<>();

	    String sql =
	            "SELECT r.review_id, r.movie_id, r.member_id, "
	          + "       r.rating, r.content, r.reg_date, r.like_count, "
	          + "       mv.title AS movie_title "
	          + "FROM review r "
	          + "LEFT JOIN movie mv ON r.movie_id = mv.movie_id "
	          + "WHERE r.member_id = ? "
	          + "ORDER BY r.reg_date DESC, r.review_id DESC";

	    try(Connection conn = ds.getConnection();
	    PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, memberId);
	        
	        try(ResultSet rs = pstmt.executeQuery()){
		        while (rs.next()) {
	
		            ReviewDTO dto = new ReviewDTO();
	
		            dto.setReviewId(rs.getInt("review_id"));
		            dto.setMovieId(rs.getInt("movie_id"));
		            dto.setMemberId(rs.getString("member_id"));
		            dto.setRating(rs.getInt("rating"));
		            dto.setContent(rs.getString("content"));
		            dto.setRegDate(rs.getTimestamp("reg_date"));
		            dto.setLikeCount(rs.getInt("like_count"));
		            dto.setMovieTitle(rs.getString("movie_title"));
	
		            list.add(dto);
		        }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();

	    } 
	    return list;
	}
}