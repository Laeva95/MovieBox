package member;
public class MemberService {
    private MemberDAO dao = new MemberDAO();
    public boolean register(MemberDTO dto) {
        if (dto.getId() == null || dto.getPw() == null) return false;
        return dao.insertMember(dto) == 1;
    }
    public MemberDTO login(String id, String pw) {
        return dao.loginCheck(id, pw);
    }
}