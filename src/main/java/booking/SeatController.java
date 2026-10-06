package booking;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/reservation/seat")
public class SeatController extends HttpServlet {

    private ReservationService reservationService;


    // ====================================================
    // 초기화
    // ====================================================

    @Override
    public void init() throws ServletException {

        reservationService =
                new ReservationService();
    }


    // ====================================================
    // 좌석 선택 화면
    // 예매 화면에서 "좌석 선택"을 눌렀을 때 실행
    // ====================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        // ====================================================
        // 예매 정보 받기
        // ====================================================

        String memberId =
                request.getParameter("memberId");

        String movieId =
                request.getParameter("movieId");

        String screeningId =
                request.getParameter("screeningId");

        String reservationDate =
                request.getParameter("reservationDate");


        System.out.println(
                "===== 좌석 선택 화면 요청 ====="
        );

        System.out.println(
                "memberId = " + memberId
        );

        System.out.println(
                "movieId = " + movieId
        );

        System.out.println(
                "screeningId = " + screeningId
        );

        System.out.println(
                "reservationDate = " + reservationDate
        );


        // ====================================================
        // JSP로 전달
        // ====================================================

        request.setAttribute(
                "memberId",
                memberId
        );

        request.setAttribute(
                "movieId",
                movieId
        );

        request.setAttribute(
                "screeningId",
                screeningId
        );

        request.setAttribute(
                "reservationDate",
                reservationDate
        );


        // ====================================================
        // 예약 좌석 조회
        // ====================================================

        List<String> reservedSeats =
                new ArrayList<>();


        if (movieId != null
                && !movieId.trim().isEmpty()
                && screeningId != null
                && !screeningId.trim().isEmpty()
                && reservationDate != null
                && !reservationDate.trim().isEmpty()) {


            try {

                int movieNo =
                        Integer.parseInt(movieId);

                int screeningNo =
                        Integer.parseInt(screeningId);


                // ★ 현재 선택한
                // 영화 + 상영시간 + 날짜
                // 의 예약 좌석 조회

                reservedSeats =
                        reservationService.getReservedSeats(
                                movieNo,
                                screeningNo,
                                reservationDate
                        );


                System.out.println(
                        "예약된 좌석 = "
                        + reservedSeats
                );

                System.out.println(
                        "예약된 좌석 수 = "
                        + reservedSeats.size()
                );


            } catch (NumberFormatException e) {

                e.printStackTrace();

            } catch (Exception e) {

                e.printStackTrace();
            }
        }


        // ====================================================
        // 예약 좌석 JSP 전달
        // ====================================================

        request.setAttribute(
                "reservedSeats",
                reservedSeats
        );


        System.out.println(
                "Seat.jsp로 전달할 reservedSeats = "
                + reservedSeats
        );


        // ====================================================
        // 좌석 선택 화면으로 이동
        // ====================================================

        request.setAttribute(
        	    "center",
        	    "/reservation/Seat.jsp"
        	);

        	request.getRequestDispatcher(
        	    "/Index.jsp"
        	).forward(
        	    request,
        	    response
        	);
    }
}