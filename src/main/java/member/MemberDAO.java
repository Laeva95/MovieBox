package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.InitialContext;
import javax.sql.DataSource;

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
		
		public int insertMember(MemberDTO dto) {
			
			
			
			return 0;
		}
		
}