package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dto.NoticeDTO;
// 주의: 프로젝트 내에 DB 연결을 관리하는 클래스(예: common.DBManager 등)가 있다면 패키지 경로를 맞춰주세요.
// import common.DBManager; 

public class NoticeDAO {

    // 공지사항 목록 조회 메서드
    public List<NoticeDTO> getNoticeList() {
        List<NoticeDTO> noticeList = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 1. 데이터베이스 연결 (프로젝트의 DB 연결 방식을 사용하세요. 예: conn = DBManager.getConnection();)
            // conn = DBManager.getConnection();

            // 2. SQL 쿼리 작성 (최신 글이 위로 오도록 내림차순 정렬)
            String sql = "SELECT notice_id, title, content, created_at, updated_at, view_count FROM notice ORDER BY notice_id DESC";
            
            // pstmt = conn.prepareStatement(sql);
            // rs = pstmt.executeQuery();

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
            // 4. 자원 해제 (Connection, PreparedStatement, ResultSet 닫기)
            // DBManager.close(conn, pstmt, rs);
        }

        return noticeList;
    }
    
}