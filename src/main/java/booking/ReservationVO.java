package booking;

public class ReservationVO {

    private int reservationId;
    private String memberId;
    private int movieId;
    private int screeningId;
    private String seatNumber;

    // ★ 예약 날짜 추가
    private String reservationDate;


    // ====================================================
    // 기본 생성자
    // ====================================================

    public ReservationVO() {
    }


    // ====================================================
    // 기존 생성자
    // ====================================================

    public ReservationVO(
            int reservationId,
            String memberId,
            int screeningId,
            String seatNumber) {

        this.reservationId = reservationId;
        this.memberId = memberId;
        this.screeningId = screeningId;
        this.seatNumber = seatNumber;
    }


    // ====================================================
    // 영화 ID 포함 생성자
    // ====================================================

    public ReservationVO(
            int reservationId,
            String memberId,
            int movieId,
            int screeningId,
            String seatNumber) {

        this.reservationId = reservationId;
        this.memberId = memberId;
        this.movieId = movieId;
        this.screeningId = screeningId;
        this.seatNumber = seatNumber;
    }


    // ====================================================
    // 날짜 포함 생성자
    // ====================================================

    public ReservationVO(
            int reservationId,
            String memberId,
            int movieId,
            int screeningId,
            String seatNumber,
            String reservationDate) {

        this.reservationId = reservationId;
        this.memberId = memberId;
        this.movieId = movieId;
        this.screeningId = screeningId;
        this.seatNumber = seatNumber;
        this.reservationDate = reservationDate;
    }


    // ====================================================
    // reservationId
    // ====================================================

    public int getReservationId() {

        return reservationId;
    }


    public void setReservationId(int reservationId) {

        this.reservationId = reservationId;
    }


    // ====================================================
    // memberId
    // ====================================================

    public String getMemberId() {

        return memberId;
    }


    public void setMemberId(String memberId) {

        this.memberId = memberId;
    }


    // ====================================================
    // movieId
    // ====================================================

    public int getMovieId() {

        return movieId;
    }


    public void setMovieId(int movieId) {

        this.movieId = movieId;
    }


    // ====================================================
    // screeningId
    // ====================================================

    public int getScreeningId() {

        return screeningId;
    }


    public void setScreeningId(int screeningId) {

        this.screeningId = screeningId;
    }


    // ====================================================
    // seatNumber
    // ====================================================

    public String getSeatNumber() {

        return seatNumber;
    }


    public void setSeatNumber(String seatNumber) {

        this.seatNumber = seatNumber;
    }


    // ====================================================
    // reservationDate
    // ====================================================

    public String getReservationDate() {

        return reservationDate;
    }


    public void setReservationDate(String reservationDate) {

        this.reservationDate = reservationDate;
    }
}