package booking;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/reservation/check")
public class ReservationCheckController extends HttpServlet {

    private ReservationService reservationService;

    @Override
    public void init() {
        reservationService = new ReservationService();
    }

    // ====================================================
    // GET
    // 예매 목록 조회
    // ====================================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // 회원 번호 받기
        String memberId = request.getParameter("memberId");

        // 회원 번호가 없으면 조회 화면으로 이동
        if (memberId == null || memberId.trim().isEmpty()) {

        	forwardReservationCheck(
        	        request,
        	        response
        	);

            return;
        }

        // 해당 회원의 예매 목록 조회
        List<ReservationVO> reservationList =
                reservationService.getReservationList(memberId);

        // JSP로 전달
        request.setAttribute(
                "reservationList",
                reservationList
        );

        request.setAttribute(
                "memberId",
                memberId
        );

        // 예약 확인 화면으로 이동
        forwardReservationCheck(
                request,
                response
        );
    }

    // ====================================================
    // POST
    // 예매 취소
    // ====================================================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 예약번호
        String reservationIdStr =
                request.getParameter("reservationId");

        // 회원번호
        String memberId =
                request.getParameter("memberId");

        // ====================================================
        // 예약번호 확인
        // ====================================================
        if (reservationIdStr == null
                || reservationIdStr.trim().isEmpty()) {

            request.setAttribute(
                    "message",
                    "예매번호가 없습니다."
            );

            request.setAttribute(
                    "memberId",
                    memberId
            );

            forwardReservationCheck(
                    request,
                    response
            );

            return;
        }

        // ====================================================
        // 예약번호 숫자 변환
        // ====================================================
        int reservationId;

        try {

            reservationId =
                    Integer.parseInt(reservationIdStr);

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "message",
                    "잘못된 예매번호입니다."
            );

            request.setAttribute(
                    "memberId",
                    memberId
            );

            forwardReservationCheck(
                    request,
                    response
            );

            return;
        }

        // ====================================================
        // 회원번호 확인
        // ====================================================
        if (memberId == null
                || memberId.trim().isEmpty()) {

            request.setAttribute(
                    "message",
                    "회원 정보가 없습니다."
            );

            forwardReservationCheck(
                    request,
                    response
            );

            return;
        }

        // ====================================================
        // 예매 취소
        // ====================================================
        boolean result =
                reservationService.deleteReservation(
                        reservationId,
                        memberId
                );

        // ====================================================
        // 취소 결과
        // ====================================================
        if (result) {

            request.setAttribute(
                    "message",
                    "예매 취소가 완료되었습니다."
            );

        } else {

            request.setAttribute(
                    "message",
                    "예매 취소에 실패했습니다."
            );
        }

        // ====================================================
        // 취소 후 예매 목록 다시 조회
        // ====================================================
        List<ReservationVO> reservationList =
                reservationService.getReservationList(memberId);

        request.setAttribute(
                "reservationList",
                reservationList
        );

        request.setAttribute(
                "memberId",
                memberId
        );

        // ====================================================
        // 예매 확인 화면
        // ====================================================
        forwardReservationCheck(
                request,
                response
        );
    }
    
    private void forwardReservationCheck(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "center",
                "/reservation/ReservationCheck.jsp"
        );

        request.getRequestDispatcher(
                "/Index.jsp"
        ).forward(
                request,
                response
        );
    }
}