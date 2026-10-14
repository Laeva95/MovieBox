<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>가상 결제 - MovieBox</title>

<style>
* {
    box-sizing: border-box;
}

.payment-container {
    width: 520px;
    max-width: calc(100% - 30px);
    margin: 50px auto;
    color: #fff;
    font-family: Arial, "Noto Sans KR", sans-serif;
}

.payment-box {
    padding: 30px;
    background: #191919;
    border: 1px solid #2c2c2c;
    border-radius: 10px;
}

.payment-header {
    margin-bottom: 25px;
}

.sub-title {
    margin-bottom: 8px;
    color: #e50914;
    font-size: 12px;
    font-weight: bold;
    letter-spacing: 2px;
}

.payment-header h1 {
    margin: 0;
    font-size: 28px;
}

.payment-header p {
    color: #999;
    font-size: 13px;
}

.info-box {
    margin-bottom: 20px;
    padding: 18px;
    background: #101010;
    border: 1px solid #2c2c2c;
    border-radius: 7px;
}

.info-row {
    display: flex;
    justify-content: space-between;
    gap: 15px;
    padding: 10px 0;
    border-bottom: 1px solid #222;
}

.info-row:last-child {
    border-bottom: none;
}

.info-label {
    flex-shrink: 0;
    color: #999;
    font-size: 13px;
}

.info-value {
    text-align: right;
    overflow-wrap: anywhere;
    font-size: 13px;
    font-weight: bold;
}

.amount {
    color: #e50914;
    font-size: 20px;
}

.input-group {
    margin-bottom: 17px;
}

.input-group label {
    display: block;
    margin-bottom: 8px;
    color: #bbb;
    font-size: 13px;
    font-weight: bold;
}

.input-group input {
    width: 100%;
    height: 44px;
    padding: 0 12px;
    border: 1px solid #3a3a3a;
    border-radius: 6px;
    outline: none;
    background: #101010;
    color: #fff;
    font-size: 14px;
}

.input-group input:focus {
    border-color: #e50914;
}

.payment-button,
.cancel-button {
    width: 100%;
    height: 48px;
    border-radius: 7px;
    cursor: pointer;
}

.payment-button {
    margin-top: 8px;
    border: none;
    background: #e50914;
    color: #fff;
    font-size: 15px;
    font-weight: bold;
}

.payment-button:hover {
    background: #b20710;
}

.payment-button:disabled {
    background: #444;
    cursor: not-allowed;
}

.cancel-button {
    margin-top: 10px;
    border: 1px solid #333;
    background: #111;
    color: #aaa;
}

.notice {
    margin-top: 18px;
    color: #888;
    font-size: 11px;
    line-height: 1.6;
    text-align: center;
}

@media (max-width: 600px) {
    .payment-container {
        margin: 20px auto;
    }

    .payment-box {
        padding: 20px;
    }
}
</style>
</head>

<body>

<div class="payment-container">
    <div class="payment-box">

        <div class="payment-header">
            <div class="sub-title">MOVIE BOX STORE</div>
            <h1>매점 결제</h1>
            <p>주문 상품과 결제 금액을 확인해 주세요.</p>
        </div>

        <div class="info-box">
            <c:choose>
                <c:when test="${not empty cartItems}">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="info-row">
                            <span class="info-label">
                                ${item.product.name} × ${item.quantity}
                            </span>
                            <span class="info-value">
                                <fmt:formatNumber value="${item.subtotal}"
                                    pattern="#,##0"/>원
                            </span>
                        </div>
                    </c:forEach>

                    <div class="info-row">
                        <span class="info-label">총 결제 금액</span>
                        <span class="info-value amount">
                            <fmt:formatNumber value="${cartTotal}"
                                pattern="#,##0"/>원
                        </span>
                    </div>
                </c:when>

                <c:otherwise>
                    <p>장바구니가 비어 있습니다.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <form id="paymentForm"
              action="${pageContext.request.contextPath}/store/Order.do"
              method="post">

            <div class="input-group">
                <label for="cardNumber">테스트 카드번호</label>
                <input type="text" id="cardNumber"
                       maxlength="16" inputmode="numeric"
                       autocomplete="off"
                       placeholder="숫자 16자리 입력">
            </div>

            <div class="input-group">
                <label for="expiry">유효기간</label>
                <input type="text" id="expiry"
                       maxlength="5" inputmode="numeric"
                       autocomplete="off"
                       placeholder="MM/YY">
            </div>

            <div class="input-group">
                <label for="cvc">CVC</label>
                <input type="password" id="cvc"
                       maxlength="3" inputmode="numeric"
                       autocomplete="off"
                       placeholder="숫자 3자리 입력">
            </div>

            <button type="submit" id="paymentButton"
                    class="payment-button"
                    <c:if test="${empty cartItems}">disabled</c:if>>
                가상 결제하기
            </button>
        </form>

        <button type="button" class="cancel-button"
                onclick="location.href='${pageContext.request.contextPath}/store/Cart.do'">
            장바구니로 돌아가기
        </button>

        <div class="notice">
            테스트용 가상 결제 화면입니다.<br>
            실제 카드 승인이나 결제는 발생하지 않습니다.
        </div>
    </div>
</div>

<script>
document.getElementById("paymentForm").addEventListener("submit", function(event) {
    event.preventDefault();

    const cardNumber = document.getElementById("cardNumber").value.trim();
    const expiry = document.getElementById("expiry").value.trim();
    const cvc = document.getElementById("cvc").value.trim();

    if (!/^[0-9]{16}$/.test(cardNumber)) {
        alert("카드번호 16자리를 입력해 주세요.");
        return;
    }

    if (!/^(0[1-9]|1[0-2])\/[0-9]{2}$/.test(expiry)) {
        alert("유효기간을 MM/YY 형식으로 입력해 주세요.");
        return;
    }

    if (!/^[0-9]{3}$/.test(cvc)) {
        alert("CVC 3자리를 입력해 주세요.");
        return;
    }

    if (!confirm("가상 결제를 진행할까요?")) {
        return;
    }

    const button = document.getElementById("paymentButton");
    button.disabled = true;
    button.textContent = "주문 처리 중...";

    // 카드번호, 유효기간, CVC는 서버로 전송하지 않습니다.
    // 현재 단계에서는 테스트 입력값 확인 후 기존 주문 처리를 호출합니다.
    this.submit();
});
</script>

</body>
</html>