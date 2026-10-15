package member;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import booking.ReservationService;
import booking.ReservationVO;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import member.MemberDTO;
import movie.MovieDAO;
import movie.MovieDTO;
import review.ReviewDTO;
import member.MemberDAO;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/member/*")
public class MemberController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MemberDAO memberDao;
    private ReservationService reservationService;
    private MovieDAO movieDao;
    private EmailService emailService;
    
    // 카카오 로그인 요청을 위한 변수
    private String restApiKey;
    private String clientSecret;
    private String redirectUri;

    @Override
    public void init() throws ServletException {
        memberDao = new MemberDAO();
        reservationService = new ReservationService();
        movieDao = new MovieDAO();
       
        
        try {
        	emailService = new EmailService();
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:comp/env");

            restApiKey = (String) envContext.lookup("kakao/restApiKey");
            clientSecret = (String) envContext.lookup("kakao/clientSecret");
            redirectUri = (String) envContext.lookup("kakao/redirectUri");

        } catch (NamingException e) {
            throw new ServletException("카카오 로그인 설정을 불러오지 못했습니다.", e);
        }
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getPathInfo();
        System.out.println("[MemberController] 요청 주소 : " + action);

        try {
            if ("/Login.do".equals(action)) {
                showLoginPage(request, response);
            } else if ("/LoginPro.do".equals(action)) {
                login(request, response);
            } else if ("/Logout.do".equals(action)) {
                logout(request, response);
            } else if ("/Join.do".equals(action)) {
                showJoinPage(request, response);
            } else if ("/JoinPro.do".equals(action)) {
                join(request, response);
            } else if ("/IdCheck.do".equals(action)) {
                checkIdDuplicate(request, response);
            } else if ("/MyPage.do".equals(action)) {
                showMyPage(request, response);
            } else if ("/UpdatePro.do".equals(action)) {
                updateMemberInfo(request, response);
            } else if ("/KakaoLogin.do".equals(action)) {
                kakaoLogin(request, response);
            } else if ("/KakaoCallback.do".equals(action)) {
                kakaoCallback(request, response);
            } else if ("/CancelReservation.do".equals(action)) {
                cancelReservation(request, response);
            } else if ("/FindId.do".equals(action)) {
                showFindIdPage(request, response);
            } else if ("/FindIdSendCode.do".equals(action)) {
                sendFindIdVerificationCode(request, response);
            } else if ("/FindIdVerify.do".equals(action)) {
                showFindIdVerificationPage(request, response);
            } else if ("/FindIdVerifyPro.do".equals(action)) {
                verifyFindIdCode(request, response);
            } else if ("/ResetPassword.do".equals(action)) {
                showResetPasswordPage(request, response);
            } else if ("/ResetPasswordSendCode.do".equals(action)) {
                sendPasswordResetVerificationCode(request, response);
            } else if ("/ResetPasswordVerify.do".equals(action)) {
                showPasswordResetVerificationPage(request, response);
            } else if ("/ResetPasswordVerifyPro.do".equals(action)) {
                verifyPasswordResetCode(request, response);
            } else if ("/ResetPasswordPro.do".equals(action)) {
                resetPassword(request, response);
            } else if ("/MobileTicket.do".equals(action)) {
                showMobileTicket(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.out.println("[MemberController] 처리 중 오류 : " + action);
            e.printStackTrace();
        }
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        	// 로그인 화면
        	request.setAttribute("center", "/members/Login.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void login(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

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
        	session.invalidate();

        	session = request.getSession(true);
        	session.setAttribute("id", id);
        	session.setAttribute("name", name);

        	response.sendRedirect(request.getContextPath() + "/Index.jsp");
        	return;
    }
    private void logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();

                		// 로그아웃 전 캐시 방지
                	    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
                	    response.setHeader("Pragma", "no-cache");
                	    response.setDateHeader("Expires", 0);

                	    // 세션 삭제
                	    session.invalidate();

                	    // 메인 페이지로 이동
                	    response.sendRedirect(request.getContextPath() + "/Index.jsp");
                	    return;
    }
    private void showJoinPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        	// ---------------------------------------------------- 로그인 화면
        	request.setAttribute("center", "/members/Join.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void join(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();

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

        	// id 형식 확인(영어, 숫자 4 ~ 10)
        	if (!member_id.matches("^[a-zA-Z0-9]{4,10}$")) {
        	    out.println("<script>");
        	    out.println("alert('아이디는 영문 또는 숫자를 포함하여 4~10자로 입력해주세요.');");
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

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void checkIdDuplicate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();

            String memberId = request.getParameter("member_id");

            boolean duplicate = memberDao.isMemberIdDuplicate(memberId);

            response.setContentType("application/json; charset=UTF-8");

            out.print("{\"duplicate\":" + duplicate + "}");

            out.flush();

            return;
    }
    private void showMyPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        	 String id = (String) session.getAttribute("id");

        	 // session에 id가 없으면 로그인 전용 페이지이므로 로그인 화면으로 이동
        	    if (id == null || id.trim().isEmpty()) {
        	    	out.println("<script>");
                	    out.println("alert('로그인 전용 페이지입니다.');");
                	    out.println("location.href='" + request.getContextPath() + "/member/Login.do';");
                	    out.println("</script>");
        	        return;
        	    }

        	    String menu = request.getParameter("menu");

        	    if (menu == null || menu.trim().isEmpty()) {	
        	        menu = "info";
        	    }

        	    // menu 값이 "info", "reservation", "favorite", "review" 중 하나가 아니면 기본값으로 설정
        	    if (!"info".equals(menu) && !"reservation".equals(menu)
        	            && !"favorite".equals(menu) && !"review".equals(menu)) {
        	        menu = "info";
        	    }

        	    request.setAttribute("myPageMenu", menu);

        	    // 메뉴에 따라 다른 데이터를 조회하여 request에 저장
        	    if ("info".equals(menu)) {

        	    	// 회원 정보 조회 코드
        	        MemberDTO dto = memberDao.getMember(id);
        	        request.setAttribute("member", dto);

        	    } else if ("reservation".equals(menu)) {

        	        // 기존 예매 조회 코드
        	        List<ReservationVO> reservationList = reservationService.getReservationList(id);
        	        List<MyPageReservationVO> myPageReservationList = new ArrayList<>();
        	        for (ReservationVO reservation : reservationList) {

        	        	// 영화 정보 조회
        	            MovieDTO movie = movieDao.getMovieDetails(reservation.getMovieId());

        	            String screeningTime = getScreeningTime(reservation.getScreeningId());

        	            boolean past = isPast(reservation.getReservationDate(), screeningTime);

        	            // MyPageReservationVO 객체 생성 후 리스트에 추가
        	            myPageReservationList.add(new MyPageReservationVO(reservation, movie, screeningTime, past));
        	        }

        	        request.setAttribute("myPageReservationList", myPageReservationList);

        	    } else if ("favorite".equals(menu)) {
        	    	// 즐겨찾기 영화 조회 코드
        	        List<MovieDTO> favoriteMovies = memberDao.getFavoriteMovies(id);

        	        request.setAttribute("favoriteMovies", favoriteMovies);

        	    } else if ("review".equals(menu)) {
        	    	// 리뷰 조회 코드
        	        List<ReviewDTO> myReviewList = memberDao.getReviewsByMemberId(id);

        	        request.setAttribute("myReviewList", myReviewList);
        	    }

        	    request.setAttribute("center", "members/MyPage.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void updateMemberInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();


        	String id = (String)session.getAttribute("id");

        	if(id == null || id.trim().isEmpty()) {
        		out.println("<script>");
                	    out.println("alert('로그인 전용 기능입니다.');");
                	    out.println("location.href='" + request.getContextPath() + "/member/Login.do';");
                	    out.println("</script>");
                	    return;
        	}

        	// 회원 정보 페이지에서 수정할 데이터를 전달 받음
        	String age = request.getParameter("age");
        	String gender = request.getParameter("gender");
        	String address = request.getParameter("address");
        	String email     = request.getParameter("email");
        	String tel = request.getParameter("tel"); 
        	String mtel = request.getParameter("mtel");

        	// 모든 입력값에 대해 null 값 방지
        	if (age == null || gender == null || address == null || email == null || tel == null || mtel == null) {
        	    out.println("<script>");
        	    out.println("alert('모든 입력값을 입력해주세요.');");
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
            // 성별 형식 확인
            if (!gender.equals("남") && !gender.equals("여")) {
                out.println("<script>");
                out.println("alert('성별은 남 또는 여로 입력해주세요.');");
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

            int result = memberDao.updateMember(id, email, address, tel, mtel, age, gender);

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
    private void kakaoLogin(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();

        	// 카카오 로그인 화면
        	// 카카오 REST API KEY를 제대로 불러왔는지 확인
        	if (restApiKey == null || restApiKey.trim().isEmpty()) { // 아직 진짜 키를 넣지 않았으면
        		out.println("<script>");
        		out.println(" alert('카카오 로그인이 아직 설정되지 않았습니다.\\n"
        				+ "MemberController 의 restApiKey 를 확인해주세요.');");
        		out.println(" history.back();");
        		out.println("</script>");
        		return;
        	}

        	// rest api key와 리다이렉트 uri를 통해 카카오 로그인 요청
        	String kakaoLoginUrl =
                    "https://kauth.kakao.com/oauth/authorize"
                    + "?response_type=code"
                    + "&client_id=" + restApiKey
                    + "&redirect_uri=" + redirectUri;

            response.sendRedirect(kakaoLoginUrl);
            return;
    }
    private void kakaoCallback(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        	// 카카오에서 전달한 인가 코드
            String code = request.getParameter("code");

            System.out.println("카카오 인가 코드 : " + code);

            // 전달 받은 코드가 null 이거나 비어있는 값이라면 로그인 실패 처리
            if (code == null || code.trim().isEmpty()) {

                out.println("<script>");
                out.println("alert('카카오 로그인에 실패했습니다.');");
                out.println("history.back();");
                out.println("</script>");

                return;
            }

            try {

                // 인가 코드 → Access Token 요청
                String tokenResponse = getKakaoAccessToken(code);

                // 전달 받은 json 데이터에서 access_token 키의 값만 가져옴
                String accessToken = tokenResponse.substring(tokenResponse.indexOf("\"access_token\":\"")+ 16,
                                tokenResponse.indexOf("\"", tokenResponse.indexOf("\"access_token\":\"") + 16));

                // token을 통해 사용자 정보를 가져옴
                String data = getKakaoUserInfo(accessToken);

                // id, nickname 저장
                String kakaoId = getKakaoId(data);
                String kakaoNickname = getKakaoNickname(data);

                System.out.println("카카오 ID : " + kakaoId);
                System.out.println("카카오 닉네임 : " + kakaoNickname);

                // MemberDTO 객체를 생성하여 id, nickname 저장
                MemberDTO member = new MemberDTO();
                member.setMember_id("k" + kakaoId);
                member.setMember_name(kakaoNickname);

                // 로그인을 위한 db 접근 요청
                int result = memberDao.kakaoLogin(member);

                // result == 1 일시 로그인 성공
                if (result == 1) {
                	// 세션에 id, name 저장
                    session.setAttribute("id", member.getMember_id());
                    session.setAttribute("name", member.getMember_name());

                    // 메인 화면으로 이동
                    response.sendRedirect(request.getContextPath() + "/Index.jsp");

                    return;

                // 로그인 실패
                }else {
                	// 이전 화면으로 이동
                    out.println("<script>");
                    out.println("alert('카카오 로그인에 실패했습니다.');");
                    out.println("history.back();");
                    out.println("</script>");

                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>");
                out.println("alert('카카오 로그인 처리 중 오류가 발생했습니다.');");
                out.println("history.back();");
                out.println("</script>");

                return;
            }
    }
    private void cancelReservation(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

            String id = (String) session.getAttribute("id");

            // 로그인 전용 페이지이므로 로그인 상태가 아니면 로그인 화면으로 이동
            if (id == null || id.trim().isEmpty()) {
            	out.println("<script>");
                	    out.println("alert('로그인 전용 페이지입니다.');");
                	    out.println("location.href='" + request.getContextPath() + "/member/Login.do';");
                	    out.println("</script>");
                return;
            }

            // request에서 reservationId를 가져온다
            String reservationIdStr = request.getParameter("reservationId");

            int reservationId;

            try {
            	// reservationIdStr을 정수로 변환
                reservationId = Integer.parseInt(reservationIdStr);

            } catch (NumberFormatException e) {
            	// reservationIdStr이 정수가 아니면 예외 처리
                session.setAttribute("reservationMessage", "잘못된 예매번호입니다.");

                response.sendRedirect(request.getContextPath()+ "/member/MyPage.do?menu=reservation");
                return;
            }


            // 현재 회원의 예약 목록 조회
            List<ReservationVO> reservationList = reservationService.getReservationList(id);

            ReservationVO targetReservation = null;

            // reservationId에 해당하는 예약을 조회
            for (ReservationVO reservation : reservationList) {
                if (reservation.getReservationId() == reservationId) {
                    targetReservation = reservation;
                    break;
                }
            }


            // 본인의 예약인지 확인
            if (targetReservation == null) {

                session.setAttribute("reservationMessage", "취소할 수 없는 예매입니다.");

                response.sendRedirect(request.getContextPath() + "/member/MyPage.do?menu=reservation");

                return;
            }


            // 상영 시간이 지나지 않았는지 확인
            if (isPast(targetReservation.getReservationDate(), 
            		getScreeningTime(targetReservation.getScreeningId()))) {

                session.setAttribute("reservationMessage", "상영 시간이 지난 예매는 취소할 수 없습니다.");

                response.sendRedirect(request.getContextPath() + "/member/MyPage.do?menu=reservation");
                return;
            }

            // 예약 취소 처리
            boolean result = reservationService.deleteReservation(reservationId, id);


            if (result) {
                session.setAttribute("reservationMessage", "예매가 취소되었습니다.");

            } else {
                session.setAttribute("reservationMessage", "예매 취소에 실패했습니다.");
            }

            // MyPage로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/member/MyPage.do?menu=reservation");
            return;
    }
    private void showFindIdPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
            request.setAttribute("center", "/members/FindId.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void sendFindIdVerificationCode(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        	// 사용자가 입력한 이름과 이메일을 가져온다
            String name = request.getParameter("member_name");
            String email = request.getParameter("email");


            if (name == null || name.trim().isEmpty()
                    || email == null || email.trim().isEmpty()) {

                out.println("<script>");
                out.println("alert('이름과 이메일을 입력해주세요.');");
                out.println("history.back();");
                out.println("</script>");

                return;
            }


            // 이름 + 이메일로 회원 검색
            List<String> memberIds = memberDao.findMemberIds(name, email);


            if (memberIds.isEmpty()) {
            	// 입력한 정보와 일치하는 회원이 없을 경우
                out.println("<script>");
                out.println("alert('입력하신 정보와 일치하는 회원을 찾을 수 없습니다.');");
                out.println("history.back();");
                out.println("</script>");

                return;
            }


            // 인증번호 생성
            String code = emailService.createVerificationCode();


            // 세션에 인증정보 저장
            session.setAttribute("findIdName", name);
            session.setAttribute("findIdEmail", email);
            session.setAttribute("findIdCode", code);

            // 인증번호 만료 시간 설정 (5분 후)
            session.setAttribute("findIdCodeExpire", System.currentTimeMillis() + 5 * 60 * 1000);


            // 이메일 발송
            try {
                emailService.sendVerificationCode(email, code);
            } catch (Exception e) {

                e.printStackTrace();

                // 이메일 발송 실패 시 인증정보 제거
                session.removeAttribute("findIdName");
                session.removeAttribute("findIdEmail");
                session.removeAttribute("findIdCode");
                session.removeAttribute("findIdCodeExpire");

                // 이전 페이지로 이동
                out.println("<script>");
                out.println("alert('인증번호 발송에 실패했습니다.');");
                out.println("history.back();");
                out.println("</script>");

                return;
            }

            // 인증번호 입력 화면으로 이동
            response.sendRedirect(request.getContextPath()+ "/member/FindIdVerify.do");
            return;
    }
    private void showFindIdVerificationPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
            request.setAttribute("center", "/members/FindIdVerify.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void verifyFindIdCode(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

            String inputCode = request.getParameter("authCode");
            String savedCode = (String)session.getAttribute("findIdCode");
            // 세션에서 인증번호 만료 시간 가져오기
            Long expireTime = (Long)session.getAttribute("findIdCodeExpire");

            // 인증번호가 일치하지 않거나 만료되었는지 확인
            if (savedCode == null || expireTime == null
                    || inputCode == null || System.currentTimeMillis() > expireTime
                    || !savedCode.equals(inputCode)) {

                out.println("<script>");
                out.println("alert('인증번호가 올바르지 않거나 만료되었습니다.');");
                out.println("history.back();");
                out.println("</script>");
                return;
            }
            // 인증 성공 후 회원 아이디 조회
            String name = (String)session.getAttribute("findIdName");
            String email =(String)session.getAttribute("findIdEmail");

            // 인증 성공 후 다시 DB 조회
            List<String> memberIds =memberDao.findMemberIds(name, email);
            request.setAttribute("memberIds", memberIds);

            // 인증 관련 세션 삭제
            session.removeAttribute("findIdName");
            session.removeAttribute("findIdEmail");
            session.removeAttribute("findIdCode");
            session.removeAttribute("findIdCodeExpire");

            request.setAttribute("center", "/members/FindIdResult.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void showResetPasswordPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	// 세션 초기화
    	HttpSession session = request.getSession(false);
        if (session != null) {
            clearPasswordResetSession(session);
        }
        
    	request.setAttribute("center", "/members/ResetPassword.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void sendPasswordResetVerificationCode(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        // 세션 초기화
        clearPasswordResetSession(session);

            String memberId = request.getParameter("member_id");

            String name = request.getParameter("member_name");

            String email = request.getParameter("email");


            if (memberId == null || name == null
                    || email == null || memberId.trim().isEmpty()
                    || name.trim().isEmpty() || email.trim().isEmpty()) {

                out.println("<script>");
                out.println("alert('모든 정보를 입력해주세요.');");
                out.println("history.back();");
                out.println("</script>");
                return;
            }

            // 입력한 회원 정보가 DB에 존재하는지 확인
            boolean memberExists = memberDao.verifyMemberForPasswordReset(memberId, name, email);

            if (!memberExists) {
                out.println("<script>");
                out.println("alert('입력하신 회원정보가 일치하지 않습니다.');");
                out.println("history.back();");
                out.println("</script>");
                return;
            }

            // 인증번호 생성
            String code = emailService.createVerificationCode();

            // 인증번호와 관련 정보를 세션에 저장
            session.setAttribute("resetPasswordMemberId", memberId);
            session.setAttribute("resetPasswordEmail", email);
            session.setAttribute("resetPasswordCode", code);
            session.setAttribute("resetPasswordCodeExpire", System.currentTimeMillis() + 5 * 60 * 1000);


            try {
            	// 이메일 발송
                emailService.sendVerificationCode(email, code);
            } catch (Exception e) {
                e.printStackTrace();
                // 이메일 발송 실패 시 인증정보 제거
                session.removeAttribute("resetPasswordMemberId");
                session.removeAttribute("resetPasswordEmail");
                session.removeAttribute("resetPasswordCode");
                session.removeAttribute("resetPasswordCodeExpire");

                out.println("<script>");
                out.println("alert('인증번호 발송에 실패했습니다.');");
                out.println("history.back();");
                out.println("</script>");

                return;
            }

            // 인증번호 입력 화면으로 이동
            response.sendRedirect(request.getContextPath() + "/member/ResetPasswordVerify.do");
            return;
    }
    private void showPasswordResetVerificationPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
            request.setAttribute("center", "/members/ResetPasswordVerify.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void verifyPasswordResetCode(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        	// 세션에서 인증번호와 만료 시간을 가져온다
            String inputCode = request.getParameter("authCode");
            String savedCode = (String)session.getAttribute("resetPasswordCode");
            Long expireTime = (Long)session.getAttribute("resetPasswordCodeExpire");

            // 인증번호가 일치하지 않거나 만료되었는지 확인
            if (savedCode == null || expireTime == null
                    || inputCode == null || System.currentTimeMillis() > expireTime
                    || !savedCode.equals(inputCode)) {
                out.println("<script>");
                out.println("alert('인증번호가 올바르지 않거나 만료되었습니다.');");
                out.println("history.back();");
                out.println("</script>");
                return;
            }


            // 이메일 인증 성공
            session.setAttribute("passwordResetVerified", true);

            // 인증번호는 더 이상 필요 없음
            session.removeAttribute("resetPasswordCode");
            session.removeAttribute("resetPasswordCodeExpire");

            request.setAttribute("center", "/members/ResetPasswordForm.jsp");

        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }
    private void resetPassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        	// 세션에서 인증 여부와 회원 아이디를 가져온다
            Boolean verified = (Boolean)session.getAttribute("passwordResetVerified");
            String memberId = (String)session.getAttribute("resetPasswordMemberId");


            // 이메일 인증을 완료한 경우에만 허용
            if (!Boolean.TRUE.equals(verified)
                    || memberId == null) {

                out.println("<script>");
                out.println("alert('비밀번호 재설정 인증이 필요합니다.');");
                out.println("location.href='" + request.getContextPath() + "/member/ResetPassword.do';");
                out.println("</script>");
                return;
            }

            // 새로운 비밀번호와 확인 비밀번호를 가져온다
            String newPassword = request.getParameter("member_pass");
            String confirmPassword = request.getParameter("member_pass_confirm");

            // 비밀번호 일치 여부 확인
            if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
                out.println("<script>");
                out.println("alert('비밀번호가 일치하지 않습니다.');");
                out.println("history.back();");
                out.println("</script>");
                return;
            }


            // 현재 회원가입과 같은 비밀번호 규칙
            if (!newPassword.matches(
                    "^(?=.*[a-zA-Z])"
                  + "(?=.*[0-9])"
                  + "(?=.*[!@#$%^&*])"
                  + "[a-zA-Z0-9!@#$%^&*]{8,20}$")) {

                out.println("<script>");
                out.println("alert('비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.');");
                out.println("history.back();");
                out.println("</script>");

                return;
            }


            // 기존 PasswordUtil 사용
            String hashedPassword = PasswordUtil.createPasswordHash(newPassword);


            // DB 변경
            int result = memberDao.updatePassword(memberId, hashedPassword);

            if (result > 0) {
                // 인증 관련 세션 제거
            	clearPasswordResetSession(session);

                // 비밀번호 변경 성공 메시지와 로그인 페이지로 이동
                out.println("<script>");
                out.println("alert('비밀번호가 변경되었습니다.');");
                out.println("location.href='" + request.getContextPath() + "/member/Login.do';");
                out.println("</script>");
                return;
            } else {
            	// 비밀번호 변경 실패
                out.println("<script>");
                out.println("alert('비밀번호 변경에 실패했습니다.');");
                out.println("history.back();");
                out.println("</script>");
                return;
            }
    }
    private void showMobileTicket(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

            // 1. 로그인한 회원 확인
            String id = (String)session.getAttribute("id");

            // 로그인 상태가 아니면 로그인 화면으로 이동
            if (id == null || id.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/member/Login.do");
                return;
            }

            // 2. 로그인한 회원의 실제 예매 내역 조회
            List<ReservationVO> reservationList = reservationService.getReservationList(id);

            String reservationIdStr = request.getParameter("reservationId");

            int ticketMovieId = 0;
            int ticketScreeningId = 0;
            int ticketSeatCount = 0;

            String ticketDate = null;
            String ticketSeats = null;

            boolean ticketValid = false;

            // 3. 예매번호가 있으면 해당 예매 내역으로 티켓 생성
            if (reservationIdStr != null && !reservationIdStr.trim().isEmpty()) {

                try {
                    int reservationId = Integer.parseInt(reservationIdStr);

                    for (ReservationVO reservation : reservationList) {

                        // 로그인 회원의 예매 목록에서만 검색
                        if (reservation.getReservationId() == reservationId) {

                            ticketMovieId = reservation.getMovieId();
                            ticketScreeningId = reservation.getScreeningId();
                            ticketDate = reservation.getReservationDate();
                            ticketSeats = reservation.getSeatNumber();
                            ticketSeatCount = 1;

                            ticketValid = true;
                            break;
                        }
                    }

                } catch (NumberFormatException e) {
                    ticketValid = false;
                }

            } else {

                // 4. 예매 완료 페이지에서 접근한 경우
                // URL의 정보를 DB와 대조하여 실제 예매인지 확인

                String requestedMemberId = request.getParameter("memberId");
                String movieIdStr = request.getParameter("movieId");
                String screeningIdStr = request.getParameter("screeningId");
                String reservationDate = request.getParameter("reservationDate");
                String seats = request.getParameter("seats");

                boolean memberMatches = requestedMemberId == null 
                		|| requestedMemberId.trim().isEmpty() || id.equals(requestedMemberId);

                if (memberMatches && movieIdStr != null
                    && screeningIdStr != null && reservationDate != null
                    && !reservationDate.trim().isEmpty() && seats != null
                    && !seats.trim().isEmpty()) {

                    try {
                    	// URL에서 받은 movieId와 screeningId를 정수로 변환
                        int requestedMovieId = Integer.parseInt(movieIdStr);
                        int requestedScreeningId = Integer.parseInt(screeningIdStr);

                        // URL에서 받은 좌석 정보를 쉼표로 분리하여 배열로 변환
                        String[] requestedSeats = seats.split(",");

                        // 좌석 검증을 위해 중복 좌석과 빈 좌석을 허용하지 않음
                        List<String> verifiedSeats = new ArrayList<>();

                        // 첫 번째로 매칭된 ReservationVO를 저장하여 티켓 정보를 가져오기 위함
                        ReservationVO firstMatched = null;

                        boolean allSeatsValid = true;

                        for (String seatValue : requestedSeats) {

                            String seat = seatValue.trim();

                            // 빈 좌석이나 중복 좌석은 허용하지 않음
                            if (seat.isEmpty() || verifiedSeats.contains(seat)) {
                                allSeatsValid = false;
                                break;
                            }

                            ReservationVO matched = null;

                            // 해당 회원의 DB 예매 내역과 모든 조건 비교
                            for (ReservationVO reservation : reservationList) {
                            	// movieId, screeningId, reservationDate, seatNumber가 모두 일치하는지 확인
                                if (reservation.getMovieId() == requestedMovieId
                                		&& reservation.getScreeningId() == requestedScreeningId
                                        && reservationDate.equals( reservation.getReservationDate())
                                        && seat.equals(reservation.getSeatNumber())) {

                                    matched = reservation;
                                    break;
                                }
                            }

                            // 실제 예매 내역에 없는 좌석이면 티켓 생성 불가
                            if (matched == null) {
                                allSeatsValid = false;
                                break;
                            }

                            // 첫 번째로 매칭된 ReservationVO를 저장하여 티켓 정보를 가져오기 위함
                            if (firstMatched == null) {
                                firstMatched = matched;
                            }

                            // URL에서 받은 좌석명이 아니라
                            // DB에서 확인한 좌석명을 사용
                            verifiedSeats.add(matched.getSeatNumber());
                        }

                        // 모든 좌석이 유효하고, 첫 번째 매칭된 예약이 존재하며, 
                        // 검증된 좌석 목록이 비어있지 않다면 티켓 정보를 설정
                        if (allSeatsValid
                                && firstMatched != null
                                && !verifiedSeats.isEmpty()) {
                        	// 티켓 정보를 설정
                            ticketMovieId = firstMatched.getMovieId();
                            ticketScreeningId = firstMatched.getScreeningId();
                            ticketDate = firstMatched.getReservationDate();
                            ticketSeats = String.join(",", verifiedSeats);
                            ticketSeatCount = verifiedSeats.size();
                            ticketValid = true;
                        }

                    } catch (NumberFormatException e) {
                        ticketValid = false;
                    }
                }
            }

            // 5. 검증 실패 또는 DB에 없는 영화라면 접근 차단
            MovieDTO ticketMovie = null;

            // ticketValid이 true이면 movieDao를 통해 영화 정보를 가져온다
            if (ticketValid) {
                ticketMovie = movieDao.getMovieDetails(ticketMovieId);
            }

            // 5. 검증 실패 또는 DB에 없는 영화라면 접근 차단
            if (!ticketValid || ticketMovie == null) {
                out.println("<script>");
                out.println("alert('유효한 예매 내역을 찾을 수 없습니다.');");
                out.println("location.href='"
                    + request.getContextPath()
                    + "/member/MyPage.do?menu=reservation';");
                out.println("</script>");
                return;
            }

            // 6. 화면에 필요한 정보는 서버에서 검증한 값으로 전달
            request.setAttribute("ticketMemberId", id);
            request.setAttribute("ticketMovieId", String.valueOf(ticketMovieId));
            request.setAttribute("ticketScreeningId", String.valueOf(ticketScreeningId));
            request.setAttribute("ticketReservationDate", ticketDate);
            request.setAttribute("ticketSeats", ticketSeats);

            // 현재 프로젝트의 티켓 가격 10,000원 기준
            request.setAttribute("ticketAmount", String.valueOf(ticketSeatCount * 10000));
            request.setAttribute("ticketMovieTitle", ticketMovie.getTitle());

            // 검증이 끝난 정보만 JSP로 전달
            request.getRequestDispatcher("/reservation/MobileTicket.jsp").forward(request, response);

            return;
    }

    // 카카오 인가 코드로 Access Token을 가져오는 메소드
    private String getKakaoAccessToken(String code) throws Exception {

    	// 카카오 토큰 요청 URL
        String tokenUrl = "https://kauth.kakao.com/oauth/token";

        URL url = new URL(tokenUrl);

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        // POST 방식
        conn.setRequestMethod("POST");

        // 요청 데이터를 서버로 보낼 수 있도록 설정
        conn.setDoOutput(true);

        // 요청 데이터 형식
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

        // 카카오에 보낼 데이터
        String params =
                "grant_type=authorization_code"
                + "&client_id=" + URLEncoder.encode(restApiKey, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                + "&code=" + URLEncoder.encode(code, "UTF-8")
                + "&client_secret=" + URLEncoder.encode(clientSecret, "UTF-8");

        // 요청 데이터 전송
        try (OutputStream os = conn.getOutputStream()) {

        	// params 문자열을 바이트 배열로 변환하여 전송
            os.write(params.getBytes(StandardCharsets.UTF_8));
            os.flush();
        }

        // 카카오의 응답 코드 확인
        int responseCode = conn.getResponseCode();

        System.out.println("카카오 Token API 응답 코드 : " + responseCode);

        // 응답 읽기
        BufferedReader br;

        // 응답 코드가 200이면 정상 응답, 아니면 에러 응답을 읽는다
        if (responseCode == 200) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));

        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            
        }

        // 응답 내용을 StringBuilder에 저장
        StringBuilder response = new StringBuilder();

        String line;

        // 응답 내용을 한 줄씩 읽어와 StringBuilder에 추가
        while ((line = br.readLine()) != null) {
            response.append(line);
        }

        br.close();

        System.out.println("카카오 Token 응답 : " + response);

        return response.toString();
    }
// 카카오 사용자 정보 요청
    private String getKakaoUserInfo(String accessToken) throws Exception {

    	// 카카오 사용자 정보 요청 URL
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

        // HTTP GET 요청을 보내기 위해 URL 객체 생성
        URL url = new URL(userInfoUrl);

        // HttpURLConnection 객체를 생성하여 GET 요청 설정
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        // GET 요청 설정
        conn.setRequestMethod("GET");
        
        // Authorization 헤더에 Bearer 토큰 추가
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        
        // Content-Type 헤더 설정
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

        int responseCode = conn.getResponseCode();

        System.out.println("카카오 사용자 정보 응답 코드 : " + responseCode);

        BufferedReader br;

        // 응답 코드가 200이면 정상 응답, 아니면 에러 응답을 읽는다
        if (responseCode == 200) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
        }

        // 응답 내용을 StringBuilder에 저장
        StringBuilder response = new StringBuilder();

        String line;

        // 응답 내용을 한 줄씩 읽어와 StringBuilder에 추가
        while ((line = br.readLine()) != null) {
            response.append(line);
        }

        br.close();

        return response.toString();
    }
// json 데이터에서 카카오 id를 가져오는 메소드
    private String getKakaoId(String result) {

    	// JSON 문자열에서 "id" 키를 찾기 위한 문자열
        String key = "\"id\":";

        // "id" 키의 시작 위치를 찾는다
        int start = result.indexOf(key);

        // "id" 키가 없으면 null 반환
        if (start == -1) {
            return null;
        }

        // "id" 키의 값이 시작되는 위치로 이동
        start += key.length();

        // "id" 키의 값이 끝나는 위치를 찾는다 (콤마 위치)
        int end = result.indexOf(",", start);

        // "id" 키의 값이 끝나는 위치가 없으면 null 반환
        if (end == -1) {
            return null;
        }

        // "id" 키의 값만 추출하여 반환 (공백 제거)
        return result.substring(start, end).trim();
    }
// json 데이터에서 카카오 닉네임을 가져오는 메소드
    private String getKakaoNickname(String result) {

    	// JSON 문자열에서 "nickname" 키를 찾기 위한 문자열
        String key = "\"nickname\":\"";

        // "nickname" 키의 시작 위치를 찾는다
        int start = result.indexOf(key);

        // "nickname" 키가 없으면 null 반환
        if (start == -1) {
            return null;
        }

        // "nickname" 키의 값이 시작되는 위치로 이동
        start += key.length();

        // 	"nickname" 키의 값이 끝나는 위치를 찾는다 (따옴표 위치)
        int end = result.indexOf("\"", start);

        // "nickname" 키의 값이 끝나는 위치가 없으면 null 반환
        if (end == -1) {
            return null;
        }

        // "nickname" 키의 값만 추출하여 반환
        return result.substring(start, end);
    }
// screening_id를 실제 상영 시간으로 변환
    private String getScreeningTime(int screeningId) {

        switch (screeningId) {
            case 1:
                return "10:00";
            case 2:
                return "13:00";
            case 3:
                return "16:00";
            case 4:
                return "19:00";
            default:
                return null;
        }
    }
// 예약 날짜 + 상영 시간을 현재 시간과 비교
    private boolean isPast(String reservationDate, String screeningTime) {

        if (reservationDate == null || screeningTime == null) {
            return true;
        }

        try {
        	// 예약 날짜와 상영 시간을 LocalDateTime으로 변환
            LocalDateTime screeningDateTime = LocalDateTime.parse(reservationDate + "T" 
            + screeningTime,DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));

            LocalDateTime now = LocalDateTime.now();

            // 현재 시간이 상영 시간과 같거나 지나갔다면 지난 예약
            return !screeningDateTime.isAfter(now);

        } catch (Exception e) {
            e.printStackTrace();

            // 날짜 형식이 잘못된 경우 안전하게 지난 예약으로 처리
            return true;
        }
    }
    // 비밀번호 재설정 관련 세션 초기화 메소드
    private void clearPasswordResetSession(HttpSession session) {
        session.removeAttribute("passwordResetVerified");
        session.removeAttribute("resetPasswordMemberId");
        session.removeAttribute("resetPasswordEmail");
        session.removeAttribute("resetPasswordCode");
        session.removeAttribute("resetPasswordCodeExpire");
    }
}