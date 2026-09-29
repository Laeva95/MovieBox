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
				// 로그인 화면
				request.setAttribute("center", "members/Login.jsp");
				nextPage = "/Index.jsp";
        	}else if ("/LoginPro.do".equals(action)) {
				// ---------------------------------------------------- 로그인 처리
				String id   = request.getParameter("member_id");
				String pass = request.getParameter("member_pass");

				// DB 에 저장된 비밀번호를 꺼내서 입력한 비밀번호와 비교한다
				String storedPass = memberDao.getPassword(id);

				if (storedPass == null || pass == null || !PasswordUtil.checkPassword(pass, storedPass)) { // DB 에 없는 아이디
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
        	}else if ("/JoinPro.do".equals(action)) {
				// ---------------------------------------------------- 회원가입 처리
				// 주의: reg_date는 DB에서 자동으로 입력되므로 직접 입력하지 않음
				String member_id     = request.getParameter("member_id");
				String member_pass   = request.getParameter("member_pass");
				String member_name   = request.getParameter("member_name");
				String member_pass_confirm = request.getParameter("member_pass_confirm");
				String age  = request.getParameter("age");
				String gender    = request.getParameter("gender");
				String address = request.getParameter("address");
				String email     = request.getParameter("email");
				String tel = request.getParameter("tel"); 
				String mtel = request.getParameter("mtel");
				
				// 모든 입력값에 대해 null 값 방지
				if (member_id == null || member_pass == null || member_name == null
				        || member_pass_confirm == null || age == null
				        || gender == null || address == null || email == null
				        || tel == null || mtel == null) {

				    out.println("<script>");
				    out.println("alert('모든 입력값을 입력해주세요.');");
				    out.println("history.back();");
				    out.println("</script>");
				    return;
				}
				
				// id 형식 확인(영어, 숫자 4 ~ 12)
				if (!member_id.matches("^[a-zA-Z0-9]{4,12}$")) {
				    out.println("<script>");
				    out.println("alert('아이디는 영문 또는 숫자를 포함하여 4~12자로 입력해주세요.');");
				    out.println("history.back();");
				    out.println("</script>");
				    return;
				}
				
			    // id 중복 확인
			    boolean idDuplicate = memberDao.isMemberIdDuplicate(member_id);
			    
			    if (idDuplicate) {
			        out.println("<script>");
			        out.println("alert('이미 사용 중인 아이디입니다.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
				 // 비밀번호 형식 확인
				 if (!member_pass.matches("^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,20}$")) {
				     out.println("<script>");
				     out.println("alert('비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.');");
				     out.println("history.back();");
				     out.println("</script>");
				     return;
				 }
			    
			    // 비밀번호, 비밀번호 확인 값 일치 확인
			    if (!member_pass.equals(member_pass_confirm)) {
			        out.println("<script>");
			        out.println("alert('비밀번호와 비밀번호 확인이 일치하지 않습니다.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
			    // 이메일 형식 확인
			    if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
			        out.println("<script>");
			        out.println("alert('올바른 이메일 형식을 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
			    // 이름 형식 확인
			    if (!member_name.matches("^[가-힣]{1,20}$")) {
			        out.println("<script>");
			        out.println("alert('올바른 이름을 한글로 ');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
			    // 주소 형식 확인
			    if (!address.matches("^[가-힣0-9 ]{1,99}$")) {
			        out.println("<script>");
			        out.println("alert('올바른 한글 주소를 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
			    // 나이 형식 확인
			    if (!age.matches("^(0|[1-9][0-9]?|1[0-4][0-9]|150)$")) {

			        out.println("<script>");
			        out.println("alert('올바른 나이를 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");

			        return;
			    }
			    // 나이가 0~150 사이의 숫자임을 확인 후 정수 타입으로 변경
			    int ageInt = Integer.parseInt(age);
			    
			    // 전화번호 형식 확인
			    if (!tel.matches("^0\\d{1,2}\\d{3,4}\\d{4}$")) {

			        out.println("<script>");
			        out.println("alert('올바른 전화번호를 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");

			        return;
			    }
			    
			    // 휴대전화 형식 확인
			    if (!mtel.matches("^010\\d{7,8}$")) {

			        out.println("<script>");
			        out.println("alert('올바른 휴대폰 번호를 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");

			        return;
			    }
			    
			    // 비밀번호 해싱
			    String hashedPassword = PasswordUtil.createPasswordHash(member_pass);

			    // dto 객체에 회원 가입 정보 저장
				MemberDTO dto = new MemberDTO();
				dto.setMember_id(member_id);
				dto.setMember_pass(hashedPassword);
				dto.setMember_name(member_name);
				dto.setAge(ageInt);
				dto.setGender(gender);
				dto.setAddress(address);
				dto.setEmail(email);
				dto.setTel(tel);
				dto.setMtel(mtel);

				int result = memberDao.insertMember(dto); // DB에 쿼리를 사용해 저장
				
				if (result != 1) { 
					// 1줄이 저장되지 않았으면 실패
					// 이전 페이지 호출
					out.println("<script>");
					out.println(" alert('회원가입에 실패했습니다. 아이디를 다시 확인해주세요.');");
					out.println(" history.back();");
					out.println("</script>");
					return;
				}else if(result == 1){
					out.println("<script>");
					out.println(" alert('회원가입에 성공했습니다!');");
					out.println("location.href='" + request.getContextPath() + "/Index.jsp';");
				    out.println("</script>");

				    return;
				} 
				
				// 가입 성공시 메인 페이지 호출
				nextPage = "/Index.jsp"; //

			}else if ("/IdCheck.do".equals(action)) {

			    String memberId = request.getParameter("member_id");

			    boolean duplicate = memberDao.isMemberIdDuplicate(memberId);

			    response.setContentType("application/json; charset=UTF-8");

			    out.print("{\"duplicate\":" + duplicate + "}");

			    out.flush();

			    return;
			}else if ("/MyPage.do".equals(action)) {
				String id = (String)session.getAttribute("id");
				if(id == null || id.trim() == "") {
					out.println("<script>");
	        	    out.println("alert('로그인 전용 페이지입니다.');");
	        	    out.println("location.href='" + request.getContextPath() + "/member/Login.do';");
	        	    out.println("</script>");
	        	    return;
				}
				
				// id를 통해 회원 정보 dto 객체 하나를 조회해서 저장
				MemberDTO dto = memberDao.getMember(id);
				
				request.setAttribute("member", dto);
				
				// 회원 개인 화면
				request.setAttribute("center", "members/MyPage.jsp");
				nextPage = "/Index.jsp";
			}else if ("/UpdatePro.do".equals(action)) {
				
				String id = (String)session.getAttribute("id");
				
				if(id == null || id.trim() == "") {
					out.println("<script>");
	        	    out.println("alert('로그인 전용 페이지입니다.');");
	        	    out.println("location.href='" + request.getContextPath() + "/member/Login.do';");
	        	    out.println("</script>");
	        	    return;
				}
				
				// 회원 정보 페이지에서 수정할 데이터를 전달 받음
				String address = request.getParameter("address");
				String email     = request.getParameter("email");
				String tel = request.getParameter("tel"); 
				String mtel = request.getParameter("mtel");
				
				// 모든 입력값에 대해 null 값 방지
				if (address == null || email == null || tel == null || mtel == null) {
				    out.println("<script>");
				    out.println("alert('모든 입력값을 입력해주세요.');");
				    out.println("history.back();");
				    out.println("</script>");
				    return;
				}
				
				// 이메일 형식 확인
			    if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
			        out.println("<script>");
			        out.println("alert('올바른 이메일 형식을 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
			    // 주소 형식 확인
			    if (!address.matches("^[가-힣0-9 ]{1,99}$")) {
			        out.println("<script>");
			        out.println("alert('올바른 한글 주소를 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
			    // 전화번호 형식 확인
			    if (!tel.matches("^0\\d{1,2}\\d{3,4}\\d{4}$")) {
			        out.println("<script>");
			        out.println("alert('올바른 전화번호를 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
			    // 휴대전화 형식 확인
			    if (!mtel.matches("^010\\d{7,8}$")) {
			        out.println("<script>");
			        out.println("alert('올바른 휴대폰 번호를 입력해주세요.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			    
			    int result = memberDao.updateMember(id, email, address, tel, mtel);
			    
			    // 수정 성공
			    if (result > 0) {
			        out.println("<script>");
			        out.println("alert('회원정보가 수정되었습니다.');");
			        out.println("location.href='" + request.getContextPath() + "/Index.jsp';");
			        out.println("</script>");
			        return;
			    } else {
			        out.println("<script>");
			        out.println("alert('회원정보 수정에 실패했습니다.');");
			        out.println("history.back();");
			        out.println("</script>");
			        return;
			    }
			}
        	// 결과 화면으로 이동 (주소창은 그대로, 화면만 바뀐다)
        	request.getRequestDispatcher(nextPage).forward(request, response);
        }catch(Exception e) {
        	System.out.println("[MemberController] 처리 중 오류 : " + action);
			e.printStackTrace(); // 오류가 난 위치(몇 번째 줄)까지 콘솔에 자세히 출력한다
        }
    }
}