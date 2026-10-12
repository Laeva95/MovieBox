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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getPathInfo();
        System.out.println("[MovieController] 요청 주소 : " + action);

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        String loginId = (String) session.getAttribute("id");

        String nextPage = null;
        
        try {
            if("/MovieList.do".equals(action)) {
                // 1. 요청 파라미터 받기
                String country = request.getParameter("country");
                String genre = request.getParameter("genre");
                String sort = request.getParameter("sort");
                String searchKeyword = request.getParameter("searchKeyword");
                
                if (country == null || country.equals("")) { country = "all"; }
                if (genre == null || genre.equals("")) { genre = "all"; }
                if (sort == null || sort.equals("")) { sort = "date"; }
                if (searchKeyword == null) { searchKeyword = ""; }

                // 페이지 번호 받기
                String pageNumStr = request.getParameter("pageNum");
                int pageNum = 1;
                if (pageNumStr != null && !pageNumStr.trim().isEmpty()) {
                    try {
                        pageNum = Integer.parseInt(pageNumStr);
                    } catch (NumberFormatException e) {
                        pageNum = 1;
                    }
                }
                
                int pageSize = 8;
                MovieDAO dao = new MovieDAO();

                // 필터링된 전체 목록의 size로 정확한 totalCount 및 totalPage 계산
                int totalCount = dao.getFilteredAndSortedMovieList(country, genre, sort, searchKeyword).size();
                int totalPage = (int) Math.ceil((double) totalCount / pageSize);
                if (totalPage == 0) totalPage = 1;

                // 페이징된 영화 목록 가져오기
                List<MovieDTO> movieList = dao.getPagingMovieList(country, genre, sort, searchKeyword, pageNum, pageSize);

                // 데이터 저장
                request.setAttribute("movieList", movieList);
                request.setAttribute("country", country);
                request.setAttribute("genre", genre);
                request.setAttribute("sort", sort);
                request.setAttribute("searchKeyword", searchKeyword);
                request.setAttribute("totalPage", totalPage);
                request.setAttribute("currentPage", pageNum);

                if (loginId != null) {
                    List<Integer> favoriteMovieIds = dao.getFavoriteMovieIds(loginId);
                    request.setAttribute("favoriteMovieIds", favoriteMovieIds);
                }
                
                request.setAttribute("center", "movie/MovieList.jsp");
                nextPage = "/Index.jsp";
                
            } else if("/MovieDetail.do".equals(action)) {
                // 1. 파라미터 받기
                String movieIdParam = request.getParameter("movieId");
                if (movieIdParam == null) {
                    movieIdParam = request.getParameter("movie_id");
                }
                
                // 2. DB 조회
                if (movieIdParam != null && !movieIdParam.trim().isEmpty()) {
                    int movieId = Integer.parseInt(movieIdParam);
                    MovieDAO dao = new MovieDAO();
                    MovieDTO movie = dao.getMovieDetails(movieId);
                    request.setAttribute("movie", movie);
                }
                
                // 3. 상세 페이지 포워딩 설정
                request.setAttribute("center", "movie/MovieDetail.jsp");
                nextPage = "/Index.jsp";
                
            } else if("/Favorite.do".equals(action)) {
                if (loginId == null) {
                    String ajaxHeader = request.getHeader("X-Requested-With");
                    if ("XMLHttpRequest".equals(ajaxHeader)) {
                        response.setContentType("application/json; charset=UTF-8");
                        out.write("{\"status\": \"unauthorized\"}");
                    } else {
                        out.println("<script>");
                        out.println("alert('로그인 후 이용할 수 있습니다.');");
                        out.println("location.href='" + request.getContextPath() + "/member/login.do';");
                        out.println("</script>");
                    }
                    return;
                }

                String movieIdParam = request.getParameter("movieId");
                if (movieIdParam == null) {
                    movieIdParam = request.getParameter("movie_id");
                }

                if (movieIdParam == null || movieIdParam.trim().equals("")) {
                    response.setContentType("application/json; charset=UTF-8");
                    out.write("{\"status\": \"error\", \"message\": \"영화 정보가 없습니다.\"}");
                    return;
                }

                int movieId = Integer.parseInt(movieIdParam);
                MovieDAO dao = new MovieDAO();
                boolean isFav = dao.isFavorite(loginId, movieId);
                int result = 0;

                response.setContentType("application/json; charset=UTF-8");

                if (isFav) {
                    result = dao.removeFavorite(loginId, movieId);
                    if (result > 0) {
                        out.write("{\"status\": \"removed\", \"success\": true}");
                    } else {
                        out.write("{\"status\": \"removed\", \"success\": false}");
                    }
                } else {
                    result = dao.addFavorite(loginId, movieId);
                    if (result > 0) {
                        out.write("{\"status\": \"added\", \"success\": true}");
                    } else {
                        out.write("{\"status\": \"added\", \"success\": false}");
                    }
                }
                return;
                
            } else if("/MovieUpdate.do".equals(action)) {
                if (session.getAttribute("id") == null || !session.getAttribute("id").equals("admin")) {
                    out.println("<script>");
                    out.println("alert('잘못된 요청입니다.');");
                    out.println("history.back();");
                    out.println("</script>");
                    return;
                }
                MovieDAO dao = new MovieDAO();
                int count = dao.insertMovieListFromAPI();
                System.out.println("DB에 저장된 영화 수 : " + count);
                
                response.sendRedirect(request.getContextPath() + "/movies/MovieList.do");
                return;
            }

            // 결과 화면으로 이동
            if (nextPage != null) {
                request.getRequestDispatcher(nextPage).forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}