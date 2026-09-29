package movie;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/movie/MovieList.do")
public class MovieController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        process(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        process(request, response);
    }

    private void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");

        // 1. 사용자 요청 파라미터 받기
        String country = request.getParameter("country");
        String genre = request.getParameter("genre");
        String sort = request.getParameter("sort");

     // 2. DAO를 통해 영화 목록 가져오기
        MovieDAO dao = new MovieDAO();

        List<MovieDTO> movieList;

        // 처음 들어왔을 때는 값이 없거나 "all"일 수 있으므로, 
        // 기본값(전체 보기, 기본 정렬)을 세팅해서 필터 메서드를 태웁니다.
        if (country == null || country.equals("")) { country = "all"; }
        if (genre == null || genre.equals("")) { genre = "all"; }
        if (sort == null || sort.equals("")) { sort = "date"; } // 기본값: 개봉순(date)

        // 무조건 필터 및 정렬 메서드를 호출하여 처음 접속 시에도 영화 목록이 쫙 뜨게 합니다!
        movieList = dao.getFilteredAndSortedMovieList(country, genre, sort);

        // 3. View(JSP)로 보낼 데이터를 request 영역에 저장
        request.setAttribute("movieList", movieList);
        request.setAttribute("country", country);
        request.setAttribute("genre", genre);
        request.setAttribute("sort", sort);

        // 4. MovieList.jsp로 포워딩 (데이터를 유지한 채 화면 이동)
        javax.servlet.RequestDispatcher dispatcher = request.getRequestDispatcher("MovieList.jsp");
        dispatcher.forward(request, response);
    }
}
