<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<main style="text-align: center; padding: 80px 20px;">

    <h1>주문이 완료되었습니다!</h1>

    <p>주문 번호: <strong>${orderId}</strong></p>

    <p>MovieBox 매점을 이용해 주셔서 감사합니다.</p>

    <a href="${pageContext.request.contextPath}/store/StoreList.do"
       style="
           display: inline-block;
           margin-top: 20px;
           padding: 14px 32px;
           background-color: #222;
           color: #fff;
           text-decoration: none;
           border-radius: 8px;
           font-size: 16px;
           font-weight: bold;
           transition: background-color 0.2s;
       ">
        매점으로 돌아가기
    </a>

</main>