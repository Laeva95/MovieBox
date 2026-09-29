package notice;

import java.sql.Connection; 
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;
import javax.naming.InitialContext;

public class NoticeDAO {

	private DataSource ds;
	
	public NoticeDAO() {
		try {
			InitialContext ctx = new InitialContext();
			ds = (DataSource)ctx.lookup("java:comp/env/jdbc/moviebox");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 1. 파라미터가 없을 때 호출되는 메서드 (에러 방지용 오버로딩) --> 굳이...?
    public List<NoticeDTO> getNoticeList() {
        return getNoticeList(null);
    }
	
    // 공지사항 목록 조회 메서드 (가짜 데이터 반환)
    public List<NoticeDTO> getNoticeList(String keyword) {
        List<NoticeDTO> noticeList = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            String sql = "";

         // 검색어가 없거나 비어있으면 전체 목록 조회
            if (keyword == null || keyword.trim().isEmpty()) {
                sql = "SELECT notice_id, title, content, created_at, updated_at, view_count FROM notice ORDER BY notice_id DESC";
                pstmt = conn.prepareStatement(sql);
            } else {
                // 검색어가 있으면 제목이나 내용에 검색어가 포함된 글만 조회
                sql = "SELECT notice_id, title, content, created_at, updated_at, view_count FROM notice WHERE title LIKE ? OR content LIKE ? ORDER BY notice_id DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setString(2, "%" + keyword + "%");
            }
            
            rs = pstmt.executeQuery();

            // 3. 결과 데이터를 NoticeDTO에 담아서 리스트에 추가
            while (rs != null && rs.next()) {
                NoticeDTO notice = new NoticeDTO();
                notice.setNoticeId(rs.getInt("notice_id"));
                notice.setTitle(rs.getString("title"));
                notice.setContent(rs.getString("content"));
                notice.setCreatedAt(rs.getTimestamp("created_at"));
                notice.setUpdatedAt(rs.getTimestamp("updated_at"));
                notice.setViewCount(rs.getInt("view_count"));

                noticeList.add(notice);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 4. 자원 해제 (생략 가능하나 가급적 닫아주기)
        }

        return noticeList;
    }
 // 특정 번호의 공지사항 상세 조회 메서드
    public NoticeDTO getNoticeById(int noticeId) {
        NoticeDTO notice = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 1. 데이터베이스 연결 (프로젝트 내에 사용 중인 연결 방식을 넣어주세요.)
            conn = ds.getConnection();
        	
            // 2. 특정 ID의 글만 조회하는 SQL 쿼리 작성
            String sql = "SELECT notice_id, title, content, created_at, updated_at, view_count FROM notice WHERE notice_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId); // ? 자리에 클릭한 글 번호(noticeId)를 넣어줍니다.
            rs = pstmt.executeQuery();

            // 3. 가져온 데이터를 NoticeDTO 객체에 담기
            if (rs != null && rs.next()) {
                notice = new NoticeDTO();
                notice.setNoticeId(rs.getInt("notice_id"));
                notice.setTitle(rs.getString("title"));
                notice.setContent(rs.getString("content"));
                notice.setCreatedAt(rs.getTimestamp("created_at"));
                notice.setUpdatedAt(rs.getTimestamp("updated_at"));
                notice.setViewCount(rs.getInt("view_count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 4. 자원 해제 (연결 역순으로 닫기)
        }

        return notice;
    }
    
}