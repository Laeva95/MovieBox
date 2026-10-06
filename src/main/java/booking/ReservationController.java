package booking;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/reservation")
public class ReservationController extends HttpServlet {

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

        String movieId =
                request.getParameter("movieId");

        String memberId =
                request.getParameter("memberId");

        String screeningId =
                request.getParameter("screeningId");

        String reservationDate =
                request.getParameter("reservationDate");

        setSeatInfo(
                request,
                memberId,
                movieId,
                screeningId,
                reservationDate
        );

        request.setAttribute(
                "reservedSeats",
                getReservedSeats(
                        movieId,
                        screeningId,
                        reservationDate
                )
        );

        forwardSeatPage(
                request,
                response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String memberId =
                request.getParameter("memberId");

        String movieId =
                request.getParameter("movieId");

        String screeningId =
                request.getParameter("screeningId");

        String seatNumber =
                request.getParameter("seatNumber");

        String reservationDate =
                request.getParameter("reservationDate");

        if (isEmpty(memberId)
                || isEmpty(movieId)
                || isEmpty(screeningId)
                || isEmpty(seatNumber)
                || isEmpty(reservationDate)) {

            forwardError(
                    request,
                    response,
                    "예매 정보를 모두 입력해주세요.",
                    memberId,
                    movieId,
                    screeningId,
                    reservationDate
            );

            return;
        }

        int movieNo;
        int screeningNo;

        try {

            movieNo =
                    Integer.parseInt(movieId);

            screeningNo =
                    Integer.parseInt(screeningId);

        } catch (NumberFormatException e) {

            forwardError(
                    request,
                    response,
                    "잘못된 영화 또는 상영시간 정보입니다.",
                    memberId,
                    movieId,
                    screeningId,
                    reservationDate
            );

            return;
        }

        LocalDate selectedDate;

        try {

            selectedDate =
                    LocalDate.parse(
                            reservationDate
                    );

        } catch (Exception e) {

            forwardError(
                    request,
                    response,
                    "올바른 예약 날짜를 선택해주세요.",
                    memberId,
                    movieId,
                    screeningId,
                    reservationDate
            );

            return;
        }

        LocalDate today =
                LocalDate.now();

        if (selectedDate.isBefore(today)
                || selectedDate.isAfter(today.plusDays(7))) {

            forwardError(
                    request,
                    response,
                    "예약 가능한 날짜는 오늘부터 7일 이내입니다.",
                    memberId,
                    movieId,
                    screeningId,
                    reservationDate
            );

            return;
        }

        seatNumber =
                seatNumber.trim();

        ReservationVO vo =
                new ReservationVO();

        vo.setMemberId(
                memberId
        );

        vo.setMovieId(
                movieNo
        );

        vo.setScreeningId(
                screeningNo
        );

        vo.setSeatNumber(
                seatNumber
        );

        vo.setReservationDate(
                reservationDate
        );

        boolean result =
                reservationService.reservation(vo);

        if (!result) {

            forwardError(
                    request,
                    response,
                    "이미 예약된 좌석이거나 예매에 실패했습니다.",
                    memberId,
                    movieId,
                    screeningId,
                    reservationDate
            );

            return;
        }

        request.setAttribute(
                "reservation",
                vo
        );

        request.setAttribute(
                "memberId",
                memberId
        );

        request.setAttribute(
                "movieId",
                movieNo
        );

        request.setAttribute(
                "screeningId",
                screeningNo
        );

        request.setAttribute(
                "seatNumber",
                seatNumber
        );

        request.setAttribute(
                "reservationDate",
                reservationDate
        );

        request.setAttribute(
                "center",
                "/reservation/ReservationResult.jsp"
        );

        request.getRequestDispatcher(
                "/Index.jsp"
        ).forward(
                request,
                response
        );
    }

    private boolean isEmpty(String value) {

        return value == null
                || value.trim().isEmpty();
    }

    private void setSeatInfo(
            HttpServletRequest request,
            String memberId,
            String movieId,
            String screeningId,
            String reservationDate) {

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
    }

    private List<String> getReservedSeats(
            String movieId,
            String screeningId,
            String reservationDate) {

        if (isEmpty(movieId)
                || isEmpty(screeningId)
                || isEmpty(reservationDate)) {

            return new ArrayList<String>();
        }

        try {

            int movieNo =
                    Integer.parseInt(movieId);

            int screeningNo =
                    Integer.parseInt(screeningId);

            return reservationService.getReservedSeats(
                    movieNo,
                    screeningNo,
                    reservationDate
            );

        } catch (NumberFormatException e) {

            return new ArrayList<String>();
        }
    }

    private void forwardSeatPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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

    private void forwardError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message,
            String memberId,
            String movieId,
            String screeningId,
            String reservationDate)
            throws ServletException, IOException {

        request.setAttribute(
                "message",
                message
        );

        setSeatInfo(
                request,
                memberId,
                movieId,
                screeningId,
                reservationDate
        );

        request.setAttribute(
                "reservedSeats",
                getReservedSeats(
                        movieId,
                        screeningId,
                        reservationDate
                )
        );

        forwardSeatPage(
                request,
                response
        );
    }
}