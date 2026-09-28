package member;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import member.MemberDTO;
import member.MemberDAO;

@WebServlet("/member/*")
public class MemberController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MemberDAO memberDao;

    @Override
    public void init() {
        memberDao = new MemberDAO();
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");                 // 손님이 보낸 한글이 깨지지 않게 UTF-8 로 읽는다
		response.setContentType("text/html;charset=UTF-8");    // 돌려줄 결과는 HTML, 한글은 UTF-8
		
		// 2단계 요청 주소  예) /CarProject/member/join.me  ->  "/join.me"
		String action = request.getPathInfo(); // @WebServlet 의 /member 뒷부분만 꺼낸다
		System.out.println("[MemberController] 요청 주소 : " + action);
		PrintWriter out = response.getWriter();                // 브라우저로 글자를 써 보낼 펜

		// 세션에 저장된 로그인 아이디 (로그인 안 했으면 null)
		// (덧붙임) 세션 = 서버가 손님마다 하나씩 만들어 주는 보관함. 로그인하면 여기에 "id" 를 넣어 둔다
		HttpSession session = request.getSession();
		String loginId = (String) session.getAttribute("id"); // (String) = 꺼낸 값을 글자 자료형으로 바꿔 받는다

		// 화면 이동할 JSP 주소 (null 이면 아래에서 404 처리)
		String nextPage = null;
		
        try {
        	if ("/Login.do".equals(action)) {

        		response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
			    response.setHeader("Pragma", "no-cache");
			    response.setDateHeader("Expires", 0);
			    
			    // 이미 로그인한 상태라면 로그인 화면으로 가지 않음
			    if (session.getAttribute("id") != null) {
			    	out.println("<script>");
	        	    out.println("alert('이미 로그인된 상태입니다.');");
	        	    out.println("location.href='" + request.getContextPath() + "/Index.jsp';");
	        	    out.println("</script>");
			        return;
			    }
			    
				// ---------------------------------------------------- 로그인 화면
				request.setAttribute("center", "members/Login.jsp");
				nextPage = "/Index.jsp";
        	}else if ("/LoginPro.do".equals(action)) {
				// ---------------------------------------------------- 로그인 처리
				String id   = request.getParameter("member_id");
				String pass = request.getParameter("member_pass");

				// DB 에 저장된 비밀번호를 꺼내서 입력한 비밀번호와 비교한다
				String storedPass = memberDao.getPassword(id);

				if (storedPass == null || pass == null || !pass.equals(storedPass)) { // DB 에 없는 아이디
					session.removeAttribute("id");
					out.println("<script> window.alert('아이디 또는 비밀번호를 확인해주세요'); history.go(-1); </script>"); // history.go(-1) = 한 페이지 뒤로
					return;
				}
				// DB에서 이름을 가져온다
				String name = memberDao.getName(id);
				// 로그인 성공 : 예전 세션을 버리고 새 세션에 아이디를 저장한다 (세션 고정 공격 방지)
				// (덧붙임) 세션 고정 공격 = 해커가 미리 알아 둔 세션 번호로 남의 로그인 상태를 가로채는 수법. 새 번호를 발급해서 막는다
				session.invalidate();                  // 예전 보관함 폐기
				session = request.getSession(true);    // 새 보관함 발급 (true = 없으면 새로 만든다)
				session.setAttribute("id", id);        // 새 보관함에 로그인 아이디 저장 -> 이제부터 "로그인 상태"
				session.setAttribute("name", name);
				nextPage = "/Index.jsp";
        	}else if ("/Logout.do".equals(action)) {
        		// 로그아웃
        	    session.invalidate();
        	    
        	    
        	    out.println("<script>");
        	    out.println("alert('로그아웃 되었습니다.');");
        	    out.println("location.href='" + request.getContextPath() + "/Index.jsp';");
        	    out.println("</script>");
        	    return;

			}else if ("/Join.do".equals(action)) {
				// ---------------------------------------------------- 로그인 화면
				request.setAttribute("center", "members/Join.jsp");
				nextPage = "/Index.jsp";
        	} else if ("/JoinPro.do".equals(action)) {
				// ---------------------------------------------------- 회원가입 처리
				// (덧붙임) getParameter("이름") = 화면 form 의 <input name="이름"> 에 입력한 값을 꺼낸다. 없으면 null
				String member_id     = request.getParameter("member_id");
				String member_pass   = request.getParameter("member_pass");
				String member_name   = request.getParameter("member_name");
				int age  = Integer.parseInt(request.getParameter("age"));
				String gender    = request.getParameter("gender");
				String email     = request.getParameter("email");
				String tel = request.getParameter("tel"); // 화면에서 온 값은 전부 글자라서 나이도 일단 글자로 받는다
				String mtel = request.getParameter("mtel"); // 화면에서 온 값은 전부 글자라서 나이도 일단 글자로 받는다
				Timestamp reg_date = new Timestamp(System.currentTimeMillis());

				MemberDTO dto = new MemberDTO();
				dto.setMember_id(member_id);
				dto.setMember_pass(member_pass);
				dto.setMember_name(member_name);
				dto.setAge(age);
				dto.setGender(gender);
				dto.setEmail(email);
				dto.setTel(tel);
				dto.setMtel(mtel);
				dto.setReg_date(reg_date);

				int result = memberDao.insertMember(dto); // 사원에게 "DB 에 저장해" 라고 시킨다

				nextPage = "/Index.jsp"; // 가입 성공 -> 메인 화면 (CarController 가 받는 주소)

			}
        	// 결과 화면으로 이동 (주소창은 그대로, 화면만 바뀐다)
        	request.getRequestDispatcher(nextPage).forward(request, response);
        }catch(Exception e) {
        	System.out.println("[MemberController] 처리 중 오류 : " + action);
			e.printStackTrace(); // 오류가 난 위치(몇 번째 줄)까지 콘솔에 자세히 출력한다
        }
    }
}