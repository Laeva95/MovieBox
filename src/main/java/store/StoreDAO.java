package store;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class StoreDAO {
	// 커넥션풀 (DB 연결을 미리 여러 개 만들어 둔 보관함)
	private DataSource ds;
	
	//-----------------------------------
	// 생성자
	//-----------------------------------
	public StoreDAO() {
		try {
			InitialContext ctx = new InitialContext(); 
			ds = (DataSource) ctx.lookup("java:comp/env/jdbc/moviebox"); // context.xml 설정이 틀렸거나 DB 드라이버(jar)가 없으면 여기로 온다.
		} catch (Exception e) {
		}
	}
}
