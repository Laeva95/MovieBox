package booking;

import java.util.List;

public class PaymentRequest {

    private String memberId;

    private int movieId;

    private int screeningId;

    private String reservationDate;

    private List<String> seats;

    private int amount;


    // ====================================================
    // Getter / Setter
    // ====================================================

    public String getMemberId() {

        return memberId;
    }


    public void setMemberId(String memberId) {

        this.memberId = memberId;
    }


    public int getMovieId() {

        return movieId;
    }


    public void setMovieId(int movieId) {

        this.movieId = movieId;
    }


    public int getScreeningId() {

        return screeningId;
    }


    public void setScreeningId(int screeningId) {

        this.screeningId = screeningId;
    }


    public String getReservationDate() {

        return reservationDate;
    }


    public void setReservationDate(String reservationDate) {

        this.reservationDate = reservationDate;
    }


    public List<String> getSeats() {

        return seats;
    }


    public void setSeats(List<String> seats) {

        this.seats = seats;
    }


    public int getAmount() {

        return amount;
    }


    public void setAmount(int amount) {

        this.amount = amount;
    }

}