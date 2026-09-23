<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Movie Box</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <header class="site-header">
    <jsp:include page="/inc/Top.jsp"/>
  </header>

	<main class="join-page">

    <div class="join-container">

        <!-- 제목 -->
        <div class="join-header">
            <h1>회원가입</h1>
            <p>MovieBox의 다양한 서비스를 이용해보세요.</p>
        </div>


        <!-- 회원가입 카드 -->
        <div class="join-card">

            <!-- 기본 정보 -->
            <section class="form-section">

                <h2 class="section-label">기본 정보</h2>

                <!-- 아이디 -->
                <div class="form-group">

                    <label class="form-label" for="memberId">
                        아이디<span class="required">*</span>
                    </label>

                    <div class="input-with-button">

                        <input
                            type="text"
                            id="memberId"
                            name="member_id"
                            class="form-input"
                            placeholder="아이디를 입력해주세요"
                            maxlength="12"
                            required
                        >

                        <button type="button" class="btn-check">
                            중복 확인
                        </button>

                    </div>

                    <p class="form-help">
                        영문, 숫자를 포함하여 4~12자로 입력해주세요.
                    </p>

                </div>


                <!-- 비밀번호 -->
                <div class="form-group">

                    <label class="form-label" for="memberPass">
                        비밀번호<span class="required">*</span>
                    </label>

                    <input
                        type="password"
                        id="memberPass"
                        name="member_pass"
                        class="form-input"
                        placeholder="비밀번호를 입력해주세요"
                        maxlength="255"
                        required
                    >

                </div>


                <!-- 비밀번호 확인 -->
                <div class="form-group">

                    <label class="form-label" for="memberPassConfirm">
                        비밀번호 확인<span class="required">*</span>
                    </label>

                    <input
                        type="password"
                        id="memberPassConfirm"
                        name="member_pass_confirm"
                        class="form-input"
                        placeholder="비밀번호를 다시 입력해주세요"
                        required
                    >

                </div>


                <!-- 이름 -->
                <div class="form-group">

                    <label class="form-label" for="memberName">
                        이름<span class="required">*</span>
                    </label>

                    <input
                        type="text"
                        id="memberName"
                        name="member_name"
                        class="form-input"
                        placeholder="이름을 입력해주세요"
                        maxlength="20"
                        required
                    >

                </div>

            </section>


            <!-- 개인 정보 -->
            <section class="form-section">

                <h2 class="section-label">개인 정보</h2>

                <div class="form-row">

                    <!-- 나이 -->
                    <div class="form-group">

                        <label class="form-label" for="age">
                            나이
                        </label>

                        <input
                            type="number"
                            id="age"
                            name="age"
                            class="form-input"
                            placeholder="나이를 입력해주세요"
                            min="1"
                            max="150"
                        >

                    </div>


                    <!-- 성별 -->
                    <div class="form-group">

                        <label class="form-label" for="gender">
                            성별
                        </label>

                        <select
                            id="gender"
                            name="gender"
                            class="form-select"
                        >
                            <option value="">선택해주세요</option>
                            <option value="남">남성</option>
                            <option value="여">여성</option>
                        </select>

                    </div>

                </div>


                <!-- 이메일 -->
                <div class="form-group">

                    <label class="form-label" for="email">
                        이메일
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-input"
                        placeholder="example@email.com"
                        maxlength="100"
                    >

                </div>


                <!-- 주소 -->
                <div class="form-group">

                    <label class="form-label" for="address">
                        주소
                    </label>

                    <input
                        type="text"
                        id="address"
                        name="address"
                        class="form-input"
                        placeholder="주소를 입력해주세요"
                        maxlength="500"
                    >

                </div>

            </section>


            <!-- 연락처 -->
            <section class="form-section">

                <h2 class="section-label">연락처</h2>

                <div class="form-row">

                    <!-- 전화번호 -->
                    <div class="form-group">

                        <label class="form-label" for="tel">
                            전화번호
                        </label>

                        <input
                            type="tel"
                            id="tel"
                            name="tel"
                            class="form-input"
                            placeholder="02-1234-5678"
                            maxlength="20"
                        >

                    </div>


                    <!-- 휴대폰 -->
                    <div class="form-group">

                        <label class="form-label" for="mtel">
                            휴대폰 번호
                        </label>

                        <input
                            type="tel"
                            id="mtel"
                            name="mtel"
                            class="form-input"
                            placeholder="010-1234-5678"
                            maxlength="20"
                        >

                    </div>

                </div>

            </section>


            <!-- 약관 -->
            <section class="form-section">

                <h2 class="section-label">약관 동의</h2>

                <div class="terms-box">

                    <label class="terms-label">

                        <input
                            type="checkbox"
                            id="agree"
                            name="agree"
                            required
                        >

                        <span>
                            MovieBox 이용약관 및 개인정보 처리방침에 동의합니다.
                        </span>

                    </label>

                </div>

            </section>


            <!-- 버튼 -->
            <div class="join-buttons">

                <button
                    type="button"
                    class="btn-cancel"
                    onclick="history.back();"
                >
                    취소
                </button>

                <button
                    type="submit"
                    class="btn-join"
                >
                    회원가입
                </button>

            </div>

        </div>

    </div>

</main>

  <footer class="site-footer">
  	<jsp:include page="/inc/Bottom.jsp"/>
  </footer>
</body>
</html>