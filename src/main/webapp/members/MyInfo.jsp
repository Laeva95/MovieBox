<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="mypage-section-title">회원 정보</div>
<div class="mypage-section-description">
        개인 정보를 확인하고 수정할 수 있습니다.
        <br>
    </div>
     <br>
<div class="member-info-card">
    <form action="${pageContext.request.contextPath}/member/UpdatePro.do" method="post">

        <div class="member-info-section">
            <div class="member-info-section-title">기본 정보</div>

            <div class="member-info-group">
                <label class="member-info-label">아이디</label>
                <input type="text"
                       name="member_id"
                       class="member-info-input"
                       value="${member.member_id}"
                       readonly>
            </div>

            <div class="member-info-group">
                <label class="member-info-label">이름</label>
                <input type="text"
                       name="member_name"
                       class="member-info-input"
                       value="${member.member_name}"
                       readonly>
            </div>

            <div class="member-info-row">
                <div class="member-info-group">
                    <label class="member-info-label">나이</label>
                    <input type="text"
                           name="age"
                           class="member-info-input"
                           value="${member.age}">
                </div>

                <div class="member-info-group">
                    <label class="member-info-label">성별</label>
                    <input type="text"
                           name="gender"
                           class="member-info-input"
                           value="${member.gender}">
                </div>
            </div>
        </div>

        <div class="member-info-section">
            <div class="member-info-section-title">연락처 및 개인정보</div>

            <div class="member-info-group">
                <label class="member-info-label">이메일</label>
                <input type="email"
                       name="email"
                       class="member-info-input"
                       value="${member.email}">
            </div>

            <div class="member-info-group">
                <label class="member-info-label">주소</label>
                <input type="text"
                       name="address"
                       class="member-info-input"
                       value="${member.address}">
            </div>

            <div class="member-info-group">
                <label class="member-info-label">전화번호</label>
                <input type="text"
                       name="tel"
                       class="member-info-input"
                       value="${member.tel}">
            </div>

            <div class="member-info-group">
                <label class="member-info-label">휴대폰번호</label>
                <input type="text"
                       name="mtel"
                       class="member-info-input"
                       value="${member.mtel}">
            </div>
        </div>

        <div class="member-info-buttons">
            <button type="submit" class="member-info-submit-button">
                회원정보 수정
            </button>

            <button type="button"
                    class="member-info-cancel-button"
                    onclick="history.back();">
                취소
            </button>
        </div>
    </form>
</div>