package member;

import booking.ReservationVO;
import movie.MovieDTO;

public class MyPageReservationVO {

    private ReservationVO reservation;
    private MovieDTO movie;
    private String screeningTime;
    private boolean past;

    public MyPageReservationVO(ReservationVO reservation, MovieDTO movie, String screeningTime, boolean past) {

        this.reservation = reservation;
        this.movie = movie;
        this.screeningTime = screeningTime;
        this.past = past;
    }

    public ReservationVO getReservation() {
        return reservation;
    }

    public MovieDTO getMovie() {
        return movie;
    }

    public String getScreeningTime() {
        return screeningTime;
    }

    public boolean isPast() {
        return past;
    }
}