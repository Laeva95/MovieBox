package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import VO.ReservationVO;
import util.DUtil;

public class ReservationDAO {


    // ====================================================
    // 예매 등록
    // ====================================================

    public int insertReservation(
            ReservationVO vo) {

        String sql =
                "INSERT INTO reservation " +
                "(member_id, movie_id, reservation_date, " +
                "screening_id, seat_number) " +
                "VALUES (?, ?, ?, ?, ?)";


        try (
                Connection conn =
                        DUtil.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)
        ) {

            pstmt.setString(
                    1,
                    vo.getMemberId()
            );

            pstmt.setInt(
                    2,
                    vo.getMovieId()
            );

            pstmt.setString(
                    3,
                    vo.getReservationDate()
            );

            pstmt.setInt(
                    4,
                    vo.getScreeningId()
            );

            pstmt.setString(
                    5,
                    vo.getSeatNumber()
            );


            return pstmt.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();
        }


        return 0;
    }


    // ====================================================
    // 좌석 예약 여부 확인
    // 날짜 포함
    // ====================================================

    public boolean checkSeat(
            int movieId,
            int screeningId,
            String reservationDate,
            String seatNumber) {

        String sql =
                "SELECT COUNT(*) " +
                "FROM reservation " +
                "WHERE movie_id = ? " +
                "AND screening_id = ? " +
                "AND reservation_date = ? " +
                "AND seat_number = ?";


        try (
                Connection conn =
                        DUtil.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)
        ) {

            pstmt.setInt(
                    1,
                    movieId
            );

            pstmt.setInt(
                    2,
                    screeningId
            );

            pstmt.setString(
                    3,
                    reservationDate
            );

            pstmt.setString(
                    4,
                    seatNumber
            );


            try (
                    ResultSet rs =
                            pstmt.executeQuery()
            ) {

                if (rs.next()) {

                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }


    // ====================================================
    // 기존 호환용 좌석 확인
    // ====================================================

    public boolean checkSeat(
            int movieId,
            int screeningId,
            String seatNumber) {

        String sql =
                "SELECT COUNT(*) " +
                "FROM reservation " +
                "WHERE movie_id = ? " +
                "AND screening_id = ? " +
                "AND seat_number = ?";


        try (
                Connection conn =
                        DUtil.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)
        ) {

            pstmt.setInt(
                    1,
                    movieId
            );

            pstmt.setInt(
                    2,
                    screeningId
            );

            pstmt.setString(
                    3,
                    seatNumber
            );


            try (
                    ResultSet rs =
                            pstmt.executeQuery()
            ) {

                if (rs.next()) {

                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }


    // ====================================================
    // 예약된 좌석 조회
    // 날짜 포함
    // ====================================================

    public List<String> getReservedSeats(
            int movieId,
            int screeningId,
            String reservationDate) {

        List<String> reservedSeats =
                new ArrayList<>();


        String sql =
                "SELECT seat_number " +
                "FROM reservation " +
                "WHERE movie_id = ? " +
                "AND screening_id = ? " +
                "AND reservation_date = ? " +
                "ORDER BY reservation_id";


        try (
                Connection conn =
                        DUtil.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)
        ) {

            pstmt.setInt(
                    1,
                    movieId
            );

            pstmt.setInt(
                    2,
                    screeningId
            );

            pstmt.setString(
                    3,
                    reservationDate
            );


            try (
                    ResultSet rs =
                            pstmt.executeQuery()
            ) {

                while (rs.next()) {

                    reservedSeats.add(
                            rs.getString(
                                    "seat_number"
                            )
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }


        return reservedSeats;
    }


    // ====================================================
    // 기존 호환용
    // ====================================================

    public List<String> getReservedSeats(
            int movieId,
            int screeningId) {

        List<String> reservedSeats =
                new ArrayList<>();


        String sql =
                "SELECT seat_number " +
                "FROM reservation " +
                "WHERE movie_id = ? " +
                "AND screening_id = ? " +
                "ORDER BY reservation_id";


        try (
                Connection conn =
                        DUtil.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)
        ) {

            pstmt.setInt(
                    1,
                    movieId
            );

            pstmt.setInt(
                    2,
                    screeningId
            );


            try (
                    ResultSet rs =
                            pstmt.executeQuery()
            ) {

                while (rs.next()) {

                    reservedSeats.add(
                            rs.getString(
                                    "seat_number"
                            )
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }


        return reservedSeats;
    }


    // ====================================================
    // 회원 예약 목록
    // ====================================================

    public List<ReservationVO> getReservationList(
            String memberId) {

        List<ReservationVO> list =
                new ArrayList<>();


        String sql =
                "SELECT reservation_id, member_id, " +
                "movie_id, reservation_date, " +
                "screening_id, seat_number " +
                "FROM reservation " +
                "WHERE member_id = ? " +
                "ORDER BY reservation_id DESC";


        try (
                Connection conn =
                        DUtil.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)
        ) {

            pstmt.setString(
                    1,
                    memberId
            );


            try (
                    ResultSet rs =
                            pstmt.executeQuery()
            ) {

                while (rs.next()) {

                    ReservationVO vo =
                            new ReservationVO();


                    vo.setReservationId(
                            rs.getInt(
                                    "reservation_id"
                            )
                    );


                    vo.setMemberId(
                            rs.getString(
                                    "member_id"
                            )
                    );


                    vo.setMovieId(
                            rs.getInt(
                                    "movie_id"
                            )
                    );


                    vo.setReservationDate(
                            rs.getString(
                                    "reservation_date"
                            )
                    );


                    vo.setScreeningId(
                            rs.getInt(
                                    "screening_id"
                            )
                    );


                    vo.setSeatNumber(
                            rs.getString(
                                    "seat_number"
                            )
                    );


                    list.add(vo);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }


        return list;
    }


    // ====================================================
    // 예약 취소
    // 본인 예약인지 확인
    // ====================================================

    public int deleteReservation(
            int reservationId,
            String memberId) {

        String sql =
                "DELETE FROM reservation " +
                "WHERE reservation_id = ? " +
                "AND member_id = ?";


        try (
                Connection conn =
                        DUtil.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)
        ) {

            pstmt.setInt(
                    1,
                    reservationId
            );

            pstmt.setString(
                    2,
                    memberId
            );


            return pstmt.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();
        }


        return 0;
    }


    // ====================================================
    // 기존 호환용
    // ====================================================

    public int deleteReservation(
            int reservationId) {

        String sql =
                "DELETE FROM reservation " +
                "WHERE reservation_id = ?";


        try (
                Connection conn =
                        DUtil.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)
        ) {

            pstmt.setInt(
                    1,
                    reservationId
            );


            return pstmt.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();
        }


        return 0;
    }
}