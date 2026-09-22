package member;
import java.sql.*;
public class MemberDAO {
    private final String url = "jdbc:oracle:thin:@localhost:1521:xe";
    private final String uid = "moviebox";
    private final String upw = "1234";

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(url, uid, upw);
    }
    public int insertMember(MemberDTO dto) {
        String sql = "INSERT INTO member(id, pw, name, email) VALUES(?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, dto.getId());
            pstmt.setString(2, dto.getPw());
            pstmt.setString(3, dto.getName());
            pstmt.setString(4, dto.getEmail());
            return pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }
    public MemberDTO loginCheck(String id, String pw) {
        String sql = "SELECT * FROM member WHERE id = ? AND pw = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    MemberDTO dto = new MemberDTO();
                    dto.setId(rs.getString("id"));
                    dto.setName(rs.getString("name"));
                    return dto;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}