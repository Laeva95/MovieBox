<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%
String movieId = request.getParameter("movieId");
%>

<!DOCTYPE html>

<html lang="ko">

<head>

```
<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>영화 예매 - Movie Box</title>

<style>


    .reservation-container {
        width: 600px;
        margin: 80px auto;
        padding: 40px;
        background-color: white;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    }

    .reservation-title {
        text-align: center;
        margin-bottom: 35px;
    }

    .reservation-title h1 {
        margin-bottom: 10px;
        font-size: 30px;
    }

    .reservation-title p {
        color: #777;
        font-size: 14px;
    }

    .form-group {
        margin-bottom: 25px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
    }

    .form-group select,
    .form-group input {
        width: 100%;
        padding: 13px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
    }

    .form-group select:focus,
    .form-group input:focus {
        outline: none;
        border-color: #e50914;
    }

    .info-text {
        margin-top: 6px;
        font-size: 12px;
        color: #888;
    }

    .button-area {
        margin-top: 35px;
    }

    .seat-button {
        width: 100%;
        padding: 15px;
        border: none;
        border-radius: 6px;
        background-color: #e50914;
        color: white;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
    }

    .seat-button:hover {
        background-color: #b20710;
    }

</style>
```

</head>

<body>

```
<div class="reservation-container">

    <div class="reservation-title">

        <h1>영화 예매</h1>

        <p>
            영화와 상영 정보를 선택한 후 좌석을 선택해주세요.
        </p>

    </div>


    <form action="${pageContext.request.contextPath}/reservation/seat"
          method="get">


        <!-- 영화 선택 -->

        <div class="form-group">

            <label for="movieId">
                영화 선택
            </label>

            <select name="movieId"
                    id="movieId"
                    required>

                <option value="">
                    영화를 선택하세요
                </option>

                <option value="1"
                    <%= "1".equals(movieId) ? "selected" : "" %>>
                    범죄도시 4
                </option>

                <option value="2"
                    <%= "2".equals(movieId) ? "selected" : "" %>>
                    인사이드 아웃 2
                </option>

                <option value="3"
                    <%= "3".equals(movieId) ? "selected" : "" %>>
                    파묘
                </option>

            </select>

        </div>


        <!-- 회원 번호 -->

        <div class="form-group">

            <label for="memberId">
                회원 번호
            </label>

            <input type="text"
                   name="memberId"
                   id="memberId"
                   placeholder="회원 번호를 입력하세요"
                   required>

            <div class="info-text">
                예매할 회원의 번호를 입력해주세요.
            </div>

        </div>


        <!-- 상영 번호 -->

        <div class="form-group">

            <label for="screeningId">
                상영 번호
            </label>

            <input type="text"
                   name="screeningId"
                   id="screeningId"
                   placeholder="상영 번호를 입력하세요"
                   required>

            <div class="info-text">
                선택한 영화의 상영 번호를 입력해주세요.
            </div>

        </div>


        <!-- 좌석 선택 -->

        <div class="button-area">

            <button type="submit"
                    class="seat-button">

                좌석 선택

            </button>

        </div>


    </form>

</div>
```

</body>

</html>
