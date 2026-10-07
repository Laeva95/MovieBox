package booking;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/bookings/payment-complete")
public class PaymentController extends HttpServlet {

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
    // POST
    // 결제 완료 처리
    // ====================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        PrintWriter out = response.getWriter();

        // ====================================================
        // 결제 정보 가져오기
        // ====================================================

        String memberId =
                request.getParameter("memberId");

        String movieIdStr =
                request.getParameter("movieId");

        String screeningIdStr =
                request.getParameter("screeningId");

        String reservationDate =
                request.getParameter("reservationDate");

        String seats =
                request.getParameter("seats");

        String amountStr =
                request.getParameter("amount");


        // ====================================================
        // 기본값 확인
        // ====================================================

        if (memberId == null
                || memberId.trim().isEmpty()
                || movieIdStr == null
                || screeningIdStr == null
                || reservationDate == null
                || reservationDate.trim().isEmpty()
                || seats == null
                || seats.trim().isEmpty()
                || amountStr == null) {

            out.print(
                    "{\"success\":false,\"message\":\"결제 정보가 부족합니다.\"}"
            );

            return;

        }


        // ====================================================
        // 숫자 변환
        // ====================================================

        int movieId;
        int screeningId;
        int amount;

        try {

            movieId =
                    Integer.parseInt(movieIdStr);

            screeningId =
                    Integer.parseInt(screeningIdStr);

            amount =
                    Integer.parseInt(amountStr);

        } catch (NumberFormatException e) {

            out.print(
                    "{\"success\":false,\"message\":\"잘못된 결제 정보입니다.\"}"
            );

            return;

        }


        // ====================================================
        // 날짜 확인
        // ====================================================

        try {

            LocalDate.parse(reservationDate);

        } catch (DateTimeParseException e) {

            out.print(
                    "{\"success\":false,\"message\":\"잘못된 예매 날짜입니다.\"}"
            );

            return;

        }


        // ====================================================
        // 선택 좌석 나누기
        // 예) A1,B2,C3
        // ====================================================

        String[] seatArray =
                seats.split(",");


        // ====================================================
        // 현재 예약된 좌석 가져오기
        // ====================================================

        List<String> reservedSeats =
                reservationService.getReservedSeats(
                        movieId,
                        screeningId,
                        reservationDate
                );


        // ====================================================
        // 좌석 중복 확인
        // ====================================================

        for (String seatNumber : seatArray) {

            seatNumber =
                    seatNumber.trim();

            if (seatNumber.isEmpty()) {

                continue;

            }


            if (reservedSeats.contains(seatNumber)) {

                out.print(
                        "{\"success\":false,\"message\":\"이미 예약된 좌석이 있습니다: "
                                + escapeJson(seatNumber)
                                + "\"}"
                );

                return;

            }

        }


        // ====================================================
        // 예매 정보 DB 저장
        // ====================================================

        for (String seatNumber : seatArray) {

            seatNumber =
                    seatNumber.trim();


            if (seatNumber.isEmpty()) {

                continue;

            }


            ReservationVO vo =
                    new ReservationVO(
                            0,
                            memberId,
                            movieId,
                            screeningId,
                            seatNumber,
                            reservationDate
                    );


            boolean result =
                    reservationService.reservation(vo);


            // ====================================================
            // 저장 실패
            // ====================================================

            if (!result) {

                out.print(
                        "{\"success\":false,\"message\":\"예매 처리에 실패했습니다.\"}"
                );

                return;

            }

        }


        // ====================================================
        // 결제 완료
        // ====================================================

        out.print(
                "{\"success\":true,"
                        + "\"message\":\"예매가 완료되었습니다.\","
                        + "\"memberId\":\""
                        + escapeJson(memberId)
                        + "\","
                        + "\"movieId\":"
                        + movieId
                        + ","
                        + "\"screeningId\":"
                        + screeningId
                        + ","
                        + "\"reservationDate\":\""
                        + escapeJson(reservationDate)
                        + "\","
                        + "\"seats\":\""
                        + escapeJson(seats)
                        + "\","
                        + "\"amount\":"
                        + amount
                        + "}"
        );

    }


    // ====================================================
    // JSON 문자열 처리
    // ====================================================

    private String escapeJson(String value) {

        if (value == null) {

            return "";

        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");

    }

}