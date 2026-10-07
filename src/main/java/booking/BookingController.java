package booking;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import movie.MovieDAO;
import movie.MovieDTO;

@WebServlet("/movie/Booking.do")
public class BookingController extends HttpServlet {
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		request.setCharacterEncoding("UTF-8");                 // 손님이 보낸 한글이 깨지지 않게 UTF-8 로 읽는다
		response.setContentType("text/html;charset=UTF-8");    // 돌려줄 결과는 HTML, 한글은 UTF-8
		
		
		MovieDAO dao = new MovieDAO();

	    // 영화 목록
	    List<MovieDTO> movieList =
	            dao.getMovieList();

	    request.setAttribute(
	            "movieList",
	            movieList
	    );


	    // 선택된 영화
	    String movieIdStr =
	            request.getParameter("movie_id");

	    MovieDTO selectedMovie = null;

	    if (movieIdStr != null
	            && !movieIdStr.trim().isEmpty()) {

	        try {

	            int movieId =
	                    Integer.parseInt(movieIdStr);

	            selectedMovie =
	                    dao.getMovieDetails(movieId);

	        } catch (NumberFormatException e) {

	            selectedMovie = null;
	        }
	    }

	    request.setAttribute(
	            "selectedMovie",
	            selectedMovie
	    );
		
		
		request.setAttribute("center", "/movie/Booking.jsp");
		request.getRequestDispatcher("/Index.jsp").forward(request, response);
		
	}
}