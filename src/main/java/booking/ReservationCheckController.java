package booking;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import movie.MovieDAO;
import movie.MovieDTO;

@WebServlet("/reservation/check")
public class ReservationCheckController extends HttpServlet {

    private ReservationService reservationService;

    @Override
    public void init() throws ServletException {
        reservationService = new ReservationService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);

        String memberId = null;

        if (session != null) {

            Object loginId = session.getAttribute("id");

            if (loginId == null) {
                loginId = session.getAttribute("memberId");
            }

            if (loginId != null) {
                memberId = loginId.toString();
            }
        }

        if (memberId == null || memberId.trim().isEmpty()) {

            request.setAttribute(
                    "message",
                    "로그인이 필요합니다. 로그인 후 다시 이용해주세요."
            );

            request.getRequestDispatcher(
                    "/reservation/ReservationCheck.jsp"
            ).forward(request, response);

            return;
        }

        List<ReservationVO> reservationList =
                reservationService.getReservationList(memberId);

        Map<Integer, String> movieTitles = new HashMap<>();

        if (reservationList != null && !reservationList.isEmpty()) {

            MovieDAO movieDAO = new MovieDAO();

            for (ReservationVO reservation : reservationList) {

                int movieId = reservation.getMovieId();

                if (!movieTitles.containsKey(movieId)) {

                    MovieDTO movie =
                            movieDAO.getMovieDetails(movieId);

                    if (movie != null) {
                        movieTitles.put(movieId, movie.getTitle());
                    } else {
                        movieTitles.put(movieId, "영화 정보 없음");
                    }
                }
            }
        }

        request.setAttribute("memberId", memberId);
        request.setAttribute("reservationList", reservationList);
        request.setAttribute("movieTitles", movieTitles);

        request.getRequestDispatcher(
                "/reservation/ReservationCheck.jsp"
        ).forward(request, response);
    }
}

