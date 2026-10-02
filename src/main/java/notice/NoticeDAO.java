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
            	sql = "SELECT notice_id, title, content, created_at, updated_at, view_count, is_pinned "
                        + "FROM notice "
                        + "WHERE is_pinned = 0 " // 일반 글만 조회
                        + "ORDER BY is_pinned DESC, notice_id DESC "
                        + "LIMIT ? OFFSET ?";
            	 
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, pageSize);
                pstmt.setInt(2, offset);
                
            } else {
            	// 검색어가 있으면 검색 결과에서 페이지별 조회
            	sql = "SELECT notice_id, title, content, created_at, updated_at, view_count, is_pinned "
                        + "FROM notice "
                        + "WHERE is_pinned = 0 AND (title LIKE ? OR content LIKE ?) " // 일반 글 + 검색어
                        + "ORDER BY is_pinned DESC, notice_id DESC "
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
                notice.setIsPinned(rs.getInt("is_pinned"));

                noticeList.add(notice);
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
            String sql = "SELECT notice_id, title, content, writer, created_at, updated_at, view_count, filename, is_pinned "
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
                notice.setIsPinned(rs.getInt("is_pinned")); 
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
    
    // 상단 고정된 공지사항 목록만 조회하는 메서드 (페이징 없음, 항상 최신순)
    public List<NoticeDTO> getPinnedNoticeList() {
        List<NoticeDTO> pinnedList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            String sql = "SELECT notice_id, title, content, created_at, updated_at, view_count, is_pinned "
                       + "FROM notice "
                       + "WHERE is_pinned = 1 "
                       + "ORDER BY notice_id DESC";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs != null && rs.next()) {
                NoticeDTO notice = new NoticeDTO();
                notice.setNoticeId(rs.getInt("notice_id"));
                notice.setTitle(rs.getString("title"));
                notice.setContent(rs.getString("content"));
                notice.setCreatedAt(rs.getTimestamp("created_at"));
                notice.setUpdatedAt(rs.getTimestamp("updated_at"));
                notice.setViewCount(rs.getInt("view_count"));
                notice.setIsPinned(rs.getInt("is_pinned"));

                pinnedList.add(notice);
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
        return pinnedList;
    }
    
    // 이전글 조회 메서드
    public NoticeDTO getPrevNotice(int noticeId) {
        NoticeDTO notice = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            String sql = "SELECT notice_id, title FROM notice WHERE notice_id < ? ORDER BY notice_id DESC LIMIT 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId);
            rs = pstmt.executeQuery();

            if (rs != null && rs.next()) {
                notice = new NoticeDTO();
                notice.setNoticeId(rs.getInt("notice_id"));
                notice.setTitle(rs.getString("title"));
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

    // 다음글 조회 메서드
    public NoticeDTO getNextNotice(int noticeId) {
        NoticeDTO notice = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            String sql = "SELECT notice_id, title FROM notice WHERE notice_id > ? ORDER BY notice_id ASC LIMIT 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId);
            rs = pstmt.executeQuery();

            if (rs != null && rs.next()) {
                notice = new NoticeDTO();
                notice.setNoticeId(rs.getInt("notice_id"));
                notice.setTitle(rs.getString("title"));
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
    
    public void insertNotice(NoticeDTO notice) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = ds.getConnection();
            String sql = "INSERT INTO notice "
                    + "(title, content, writer, filename, created_at, view_count, is_pinned) "
                    + "VALUES (?, ?, ?, ?, NOW(), 0, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, notice.getTitle());
            pstmt.setString(2, notice.getContent());
            pstmt.setString(3, notice.getWriter());
            pstmt.setString(4, notice.getFileName());
            pstmt.setInt(5, notice.getIsPinned());
            
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

	public void increaseViewCount(int noticeId) {
		// TODO Auto-generated method stub
		
	}

	public void updateNotice(NoticeDTO notice) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        conn = ds.getConnection();
	        // 첨부파일을 새로 올렸을 때와 아닐 때 처리가 필요할 수 있으므로, 기본 title, content, is_pinned 수정 쿼리
	        String sql = "UPDATE notice SET title = ?, content = ?, is_pinned = ?, updated_at = NOW() WHERE notice_id = ?";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, notice.getTitle());
	        pstmt.setString(2, notice.getContent());
	        pstmt.setInt(3, notice.getIsPinned());
	        pstmt.setInt(4, notice.getNoticeId());

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
	
	public void deleteNotice(int noticeId) {
		System.out.println("★ [DAO 진입 성공!] 전달받은 id: " + noticeId);
		
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        conn = ds.getConnection();
	        String sql = "DELETE FROM notice WHERE notice_id = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, noticeId);
	        
	        // 이 쿼리가 실제로 실행되는지 확인
	        int result = pstmt.executeUpdate();
	        System.out.println("[DAO] DELETE 쿼리 실행 결과 - 삭제된 행 개수: " + result); // 콘솔에 0이 찍히면 조건에 맞는 데이터가 없는 것!

	    } catch (Exception e) {
	    	System.out.println("★ [DAO 에러 발생!]");
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	}
    
}