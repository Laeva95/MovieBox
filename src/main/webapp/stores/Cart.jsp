<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>장바구니 | MovieBox</title>

<style>
    .cart-container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 20px;
        color: #222;
    }

    .cart-container h1 {
        margin-bottom: 30px;
    }

    .cart-item {
        display: flex;
        align-items: center;
        gap: 20px;
        padding: 20px 0;
        border-bottom: 1px solid #ddd;
    }

    .cart-item img {
        width: 110px;
        height: 110px;
        object-fit: contain;
        border-radius: 8px;
        background: #f7f7f7;
    }

    .cart-item-info {
        flex: 1;
    }

    .cart-item-info h3 {
        margin: 0 0 10px;
    }

    .cart-item-info p {
        margin: 5px 0;
        color: #666;
    }

    .cart-quantity {
        min-width: 70px;
        text-align: center;
    }

    .cart-price {
        min-width: 130px;
        text-align: right;
        font-weight: bold;
    }

    .cart-total {
        margin-top: 30px;
        padding: 25px;
        text-align: right;
        background: #f7f7f7;
        border-radius: 8px;
    }

    .cart-total strong {
        font-size: 24px;
        color: #e31837;
    }

    .cart-empty {
        padding: 60px 20px;
        text-align: center;
        color: #777;
    }

	/* 장바구니 버튼 영역 */
	.cart-buttons {
	    display: flex;
	    justify-content: flex-end;
	    align-items: center;
	    gap: 10px;
	    margin-top: 20px;
	    flex-wrap: wrap;
	}
	
	/* 쇼핑 계속하기, 주문하기 공통 */
	.cart-buttons a,
	.cart-buttons button {
	    display: inline-block;
	    box-sizing: border-box;
	    padding: 12px 20px;
	    border-radius: 6px;
	    font-size: 16px;
	    text-decoration: none;
	    cursor: pointer;
	}
	
	/* 쇼핑 계속하기 */
	.btn-shopping {
	    color: #333;
	    border: 1px solid #ccc;
	    background: #fff;
	}
	
	/* 주문하기 */
	.btn-order {
	    color: #fff;
	    border: 1px solid #e31837;
	    background: #e31837;
	}
	
	/* 마우스를 올렸을 때 */
	.btn-order:hover {
	    background: #bd1230;
	}

	.btn-cart-remove {
	    padding: 10px 16px;
	    border: 1px solid #ddd;
	    border-radius: 6px;
	    background: #fff;
	    color: #d93025;
	    cursor: pointer;
	    white-space: nowrap;
	}
	
	.btn-cart-remove:hover {
	    background: #fff1f0;
	    border-color: #d93025;
	}
    
</style>
</head>

<body>

<div class="cart-container">

    <h1>장바구니</h1>

    <c:choose>
        <c:when test="${empty cartItems}">

            <div class="cart-empty">
                <h2>장바구니가 비어 있습니다.</h2>
                <p>마음에 드는 상품을 담아 보세요.</p>
            </div>

        </c:when>

        <c:otherwise>

            <c:forEach var="item" items="${cartItems}">

                <div class="cart-item">

                    <img
                        src="${pageContext.request.contextPath}${item.product.image}"
                        alt="${item.product.name}">

                    <div class="cart-item-info">
                        <h3>${item.product.name}</h3>
                        <p>${item.product.description}</p>
                        <p>상품 가격: ${item.product.price}원</p>
                    </div>

                    <div class="cart-quantity">
                        수량: ${item.quantity}
                    </div>

                    <div class="cart-price">
                        ${item.subtotal}원
                    </div>
                    
                    
					<form action="${pageContext.request.contextPath}/store/CartRemove.do"
					      method="post"
					      onsubmit="return confirm('이 상품을 장바구니에서 삭제할까요?');">
					
					    <input type="hidden"
					           name="productId"
					           value="${item.product.id}">
					
					    <button type="submit" class="btn-cart-remove">
					        삭제
					    </button>
					</form>
                    

                </div>

            </c:forEach>

            <div class="cart-total">
                총 주문 금액
                <br>
                <strong>${cartTotal}원</strong>
            </div>
            
            
			<div class="cart-buttons">
			    <a class="btn-shopping"
			       href="${pageContext.request.contextPath}/store/StoreList.do">
			        쇼핑 계속하기
			    </a>
		
				<form action="${pageContext.request.contextPath}/store/Payment.do"
				      method="get">
				
				    <button type="submit" class="btn-order">
				        결제하기
				    </button>
				</form>
				
			</div>
            

        </c:otherwise>
    </c:choose>

</div>

</body>
</html>