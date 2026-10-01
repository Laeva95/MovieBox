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
	
    // 공지사항 목록 조회 메서드 (가짜 데이터 반환)
    public List<NoticeDTO> getNoticeList(String keyword, int page) {
    	
    	int pageSize = 10;
    	int offset = (page - 1) * pageSize;
    	
        List<NoticeDTO> noticeList = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            
            String sql = "";

         // 검색어가 없으면 전체 목록에서 페이지별 조회
            if (keyword == null || keyword.trim().isEmpty()) {
            	
            	 sql = "SELECT notice_id, title, content, created_at, updated_at, view_count "
                         + "FROM notice "
                         + "ORDER BY notice_id DESC "
                         + "LIMIT ? OFFSET ?";
            	 
                pstmt = conn.prepareStatement(sql);
                
                pstmt.setInt(1, pageSize);
                pstmt.setInt(2, offset);
                
            } else {
            	
            	// 검색어가 있으면 검색 결과에서 페이지별 조회
            	sql = "SELECT notice_id, title, content, created_at, updated_at, view_count "
                        + "FROM notice "
                        + "WHERE title LIKE ? OR content LIKE ? "
                        + "ORDER BY notice_id DESC "
                        + "LIMIT ? OFFSET ?";
            	
                pstmt = conn.prepareStatement(sql);
                
                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setString(2, "%" + keyword + "%");
                pstmt.setInt(3, pageSize);
                pstmt.setInt(4, offset);
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
            // 4. 자원 해제 반드시 닫아주기
        	try {
        		 if (rs != null) rs.close();
                 if (pstmt != null) pstmt.close();
                 if (conn != null) conn.close();
                 
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return noticeList;
    }
    
    public int getNoticeCount(String keyword) {

        int count = 0;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();

            String sql;

            if (keyword == null || keyword.trim().isEmpty()) {

                sql = "SELECT COUNT(*) FROM notice";

                pstmt = conn.prepareStatement(sql);

            } else {

                sql = "SELECT COUNT(*) FROM notice "
                    + "WHERE title LIKE ? OR content LIKE ?";

                pstmt = conn.prepareStatement(sql);

                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setString(2, "%" + keyword + "%");
            }

            rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {

            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return count;
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
            String sql = "SELECT notice_id, title, content, writer, created_at, updated_at, view_count, filename "
                    + "FROM notice "
                    + "WHERE notice_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId);
            
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
                notice.setFileName(rs.getString("filename"));
                notice.setWriter(rs.getString("writer"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            
        } finally {
        	
        	  try {
                  if (rs != null) rs.close();
                  if (pstmt != null) pstmt.close();
                  if (conn != null) conn.close();
                  
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return notice;
    }
    
    // 조회수 1 증가
    public void increaseViewCount(int noticeId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = ds.getConnection();
            String sql = "UPDATE notice SET view_count = view_count + 1 WHERE notice_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	// 사용한 자원 역순으로 닫기
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    
    }
    
    public void insertNotice(NoticeDTO notice) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = ds.getConnection();
            String sql = "INSERT INTO notice "
                    + "(title, content, writer, filename, created_at, view_count) "
                    + "VALUES (?, ?, ?, ?, NOW(), 0)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, notice.getTitle());
            pstmt.setString(2, notice.getContent());
            pstmt.setString(3, notice.getWriter());
            pstmt.setString(4, notice.getFileName());
            
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
}