package Service;

import java.util.List;

import VO.ReservationVO;
import dao.ReservationDAO;

public class ReservationService {

    private ReservationDAO reservationDAO;


    // ====================================================
    // 생성자
    // ====================================================

    public ReservationService() {

        reservationDAO =
                new ReservationDAO();
    }


    // ====================================================
    // 예매
    // ====================================================

    public boolean reservation(
            ReservationVO vo) {

        boolean check =
                reservationDAO.checkSeat(
                        vo.getMovieId(),
                        vo.getScreeningId(),
                        vo.getReservationDate(),
                        vo.getSeatNumber()
                );


        if (check) {

            return false;
        }


        int result =
                reservationDAO.insertReservation(
                        vo
                );


        return result > 0;
    }


    // ====================================================
    // 예약된 좌석 조회
    // 날짜 포함
    // ====================================================

    public List<String> getReservedSeats(
            int movieId,
            int screeningId,
            String reservationDate) {

        return reservationDAO.getReservedSeats(
                movieId,
                screeningId,
                reservationDate
        );
    }


    // ====================================================
    // 기존 호환용
    // ====================================================

    public List<String> getReservedSeats(
            int movieId,
            int screeningId) {

        return reservationDAO.getReservedSeats(
                movieId,
                screeningId
        );
    }


    // ====================================================
    // 회원 예약 목록
    // ====================================================

    public List<ReservationVO> getReservationList(
            String memberId) {

        return reservationDAO.getReservationList(
                memberId
        );
    }


    // ====================================================
    // 예약 취소
    // 본인 예약인지 회원 ID까지 확인
    // ====================================================

    public boolean deleteReservation(
            int reservationId,
            String memberId) {

        int result =
                reservationDAO.deleteReservation(
                        reservationId,
                        memberId
                );


        return result > 0;
    }


    // ====================================================
    // 기존 호환용
    // ====================================================

    public boolean deleteReservation(
            int reservationId) {

        int result =
                reservationDAO.deleteReservation(
                        reservationId
                );


        return result > 0;
    }
}