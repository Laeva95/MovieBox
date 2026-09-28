package member;

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
				ds = (DataSource) ctx.lookup("java:comp/env/jdbc/jspbeginner"); // 이름으로 커넥션풀을 찾는다. (DataSource) = 찾은 물건을 커넥션풀 자료형으로 바꿔 받는다
			} catch (Exception e) {
				System.out.println("[MemberDAO] 커넥션풀 찾기 실패 : " + e); // context.xml 설정이 틀렸거나 DB 드라이버(jar)가 없으면 여기로 온다
			}
		}
		
		
}