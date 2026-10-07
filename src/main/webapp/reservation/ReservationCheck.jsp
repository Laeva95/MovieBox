<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="booking.ReservationVO"%>


    <style>



        .container {

            width: 700px;
            margin: 80px auto;

        }

        h1 {

            text-align: center;
            color: #e50914;
            margin-bottom: 40px;

        }

        .search-box {

            background-color: #111;
            padding: 25px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 30px;

        }

        .search-box input {

            width: 250px;
            padding: 10px;
            border: none;
            border-radius: 5px;

        }

        .search-box button {

            padding: 10px 20px;
            margin-left: 5px;

            background-color: #e50914;
            color: white;

            border: none;
            border-radius: 5px;

            cursor: pointer;

        }

        .reservation-box {

            background-color: #111;
            border: 1px solid #333;

            padding: 25px;
            margin-bottom: 15px;

            border-radius: 8px;

        }

        .reservation-box p {

            margin: 10px 0;

        }

        .empty {

            text-align: center;
            color: #aaa;
            padding: 40px;

        }

        .home-button {

            display: block;

            width: 150px;

            margin: 30px auto;

            padding: 12px;

            text-align: center;

            background-color: #e50914;

            color: white;

            text-decoration: none;

            border-radius: 5px;

        }

    </style>



<div class="container">

    <h1>예약 확인</h1>


    <!-- 회원 번호 입력 -->

    <div class="search-box">

        <form
            action="<%= request.getContextPath() %>/reservation/check"
            method="get">

            <input
                type="text"
                name="memberId"
                value="<%= request.getAttribute("memberId") != null
                        ? request.getAttribute("memberId")
                        : "" %>"
                placeholder="회원 번호 입력">

            <button type="submit">
                예약 확인
            </button>

        </form>

    </div>


<%

    List<ReservationVO> reservationList =
            (List<ReservationVO>)
            request.getAttribute("reservationList");

    if (reservationList != null && !reservationList.isEmpty()) {

        for (ReservationVO reservation : reservationList) {

%>

    <!-- 예약 정보 -->

    <div class="reservation-box">

        <p>
            <strong>예약 번호 :</strong>
            <%= reservation.getReservationId() %>
        </p>

        <p>
            <strong>회원 번호 :</strong>
            <%= reservation.getMemberId() %>
        </p>

        <p>
            <strong>상영 번호 :</strong>
            <%= reservation.getScreeningId() %>
        </p>

        <p>
            <strong>좌석 번호 :</strong>
            <%= reservation.getSeatNumber() %>
        </p>

    </div>

<%

        }

    } else if (request.getAttribute("reservationList") != null) {

%>

    <div class="empty">

        해당 회원의 예약 내역이 없습니다.

    </div>

<%

    }

%>


    <a
        href="<%= request.getContextPath() %>/"
        class="home-button">

        메인으로

    </a>

</div>
