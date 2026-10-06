package movie;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/movies/*")
public class MovieController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        process(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        process(request, response);
    }

    private void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");                 // 손님이 보낸 한글이 깨지지 않게 UTF-8 로 읽는다
		response.setContentType("text/html;charset=UTF-8");    // 돌려줄 결과는 HTML, 한글은 UTF-8
		
		// 2단계 요청 주소  예) /CarProject/member/join.me  ->  "/join.me"
		String action = request.getPathInfo(); // @WebServlet 의 /member 뒷부분만 꺼낸다
		System.out.println("[MovieController] 요청 주소 : " + action);

		PrintWriter out = response.getWriter();                // 브라우저로 글자를 써 보낼 펜

		// 세션에 저장된 로그인 아이디 (로그인 안 했으면 null)
		// (덧붙임) 세션 = 서버가 손님마다 하나씩 만들어 주는 보관함. 로그인하면 여기에 "id" 를 넣어 둔다
		HttpSession session = request.getSession();
		String loginId = (String) session.getAttribute("id"); // (String) = 꺼낸 값을 글자 자료형으로 바꿔 받는다

		// 화면 이동할 JSP 주소 (null 이면 아래에서 404 처리)
		String nextPage = null;
        
        try {
	        if("/MovieList.do".equals(action)) {
		        // 1. 사용자 요청 파라미터 받기
		        String country = request.getParameter("country");
		        String genre = request.getParameter("genre");
		        String sort = request.getParameter("sort");
		        String searchKeyword = request.getParameter("searchKeyword");
		     
		        // 2. DAO를 통해 영화 목록 가져오기
		        MovieDAO dao = new MovieDAO();
		
		        List<MovieDTO> movieList;
		
		        // 처음 들어왔을 때는 값이 없거나 "all"일 수 있으므로, 
		        // 기본값(전체 보기, 기본 정렬)을 세팅해서 필터 메서드를 태웁니다.
		        if (country == null || country.equals("")) { country = "all"; }
		        if (genre == null || genre.equals("")) { genre = "all"; }
		        if (sort == null || sort.equals("")) { sort = "date"; } // 기본값: 개봉순(date)
		        if (searchKeyword == null) {searchKeyword = "";}
		        // 무조건 필터 및 정렬 메서드를 호출하여 처음 접속 시에도 영화 목록이 쫙 뜨게 합니다!
		        movieList = dao.getFilteredAndSortedMovieList(country, genre, sort, searchKeyword);
		
		        // 3. View(JSP)로 보낼 데이터를 request 영역에 저장
		        request.setAttribute("movieList", movieList);
		        request.setAttribute("country", country);
		        request.setAttribute("genre", genre);
		        request.setAttribute("sort", sort);
		        request.setAttribute("searchKeyword", searchKeyword);
		
				request.setAttribute("center", "movie/MovieList.jsp");
				nextPage = "/Index.jsp";
	        }else if("/MovieDetail.do".equals(action)) {
	        	// 영화 상세 페이지 요청
				request.setAttribute("center", "movie/MovieDetail.jsp");
				nextPage = "/Index.jsp";
			}else if ("/MovieUpdate.do".equals(action)) {
				
				// session에 저장된 id값이 admin인지 확인
				if (session.getAttribute("id") == null || !session.getAttribute("id").equals("admin")) {

				    out.println("<script>");
				    out.println("alert('잘못된 요청입니다.');");
				    out.println("history.back();");
				    out.println("</script>");
				    return;
				}
				MovieDAO dao = new MovieDAO();

		        // KMDb API에서 영화를 가져와
		        // MySQL movie 테이블에 저장
		        int count = dao.insertMovieListFromAPI();

		        System.out.println(
		            "DB에 저장된 영화 수 : " + count
		        );
	        	
		     // 영화 목록 페이지를 다시 요청
		        response.sendRedirect(request.getContextPath() + "/movies/MovieList.do");

		        return;
	        }
	        // 결과 화면으로 이동 (주소창은 그대로, 화면만 바뀐다)
	        request.getRequestDispatcher(nextPage).forward(request, response);
        }catch (Exception e) {
			e.printStackTrace();
		}
    }
}
