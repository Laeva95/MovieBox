<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* 상세 페이지 전체 컨테이너 */
.store-detail-container {
    max-width: 900px;
    margin: 40px auto 80px;
    padding: 0 24px;
    color: #222;
    font-family: Arial, "Malgun Gothic", sans-serif;
    box-sizing: border-box;
}

.store-detail-container *,
.store-detail-container *::before,
.store-detail-container *::after {
    box-sizing: border-box;
}

/* 상품 상세 카드 레이아웃 (좌우 배치) */
.product-detail-wrapper {
    display: flex;
    gap: 40px;
    background: #ffffff;
    border: 1px solid #eaeaea;
    border-radius: 16px;
    padding: 40px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
}

/* 왼쪽 이미지 영역 */
.product-image-section {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fafafa;
    border-radius: 12px;
    overflow: hidden;
    aspect-ratio: 1 / 1;
    padding: 20px;
}

.product-image-section img {
    width: 100%;
    height: 100%;
    object-fit: contain;
}

/* 오른쪽 정보 및 액션 영역 */
.product-info-section {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.product-category-tag {
    display: inline-block;
    padding: 6px 12px;
    background: #f5f5f5;
    color: #c9283e;
    font-size: 12px;
    font-weight: bold;
    border-radius: 4px;
    margin-bottom: 14px;
    width: fit-content;
}

.product-title {
    margin: 0 0 16px;
    font-size: 26px;
    font-weight: bold;
    line-height: 1.4;
    word-break: keep-all;
}

.product-description {
    margin: 0 0 24px;
    color: #666;
    font-size: 14px;
    line-height: 1.8;
    word-break: keep-all;
    border-bottom: 1px solid #eaeaea;
    padding-bottom: 24px;
    min-height: 80px;
}

.product-price-area {
    margin-bottom: 32px;
}

.product-price-label {
    font-size: 13px;
    color: #888;
    display: block;
    margin-bottom: 4px;
}

.product-price-value {
    font-size: 28px;
    font-weight: bold;
    color: #222;
}

.product-price-value strong {
    color: #c9283e;
}

/* 버튼 그룹 */
.product-action-buttons {
    display: flex;
    gap: 12px;
}

.btn-back {
    flex: 1;
    padding: 14px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background: #fff;
    color: #444;
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    transition: background 0.2s;
}

.btn-back:hover {
    background: #f8f9fa;
}

.btn-add-cart {
    flex: 2;
    padding: 14px;
    border: none;
    border-radius: 8px;
    background: #c9283e;
    color: #fff;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    text-align: center;
    transition: background 0.2s;
}

.btn-add-cart:hover {
    background: #b02034;
}

/* 반응형 디자인 */
@media (max-width: 768px) {
    .product-detail-wrapper {
        flex-direction: column;
        padding: 24px;
        gap: 24px;
    }
}
</style>

<main class="store-detail-container">
    <div class="product-detail-wrapper">
        
        <!-- 왼쪽: 상품 이미지 -->
        <div class="product-image-section">
            <img src="${pageContext.request.contextPath}/images/${product.image}" 
                 alt="${product.name}">
        </div>

        <!-- 오른쪽: 상품 상세 정보 및 장바구니 담기 폼 -->
        <div class="product-info-section">
            <div>
                <span class="product-category-tag">${product.category}</span>
                <h1 class="product-title">${product.name}</h1>
                <p class="product-description">${product.description}</p>
                
                <div class="product-price-area">
                    <span class="product-price-label">판매 가격</span>
                    <span class="product-price-value"><strong>${product.price}</strong> 원</span>
                </div>
            </div>

            <!-- 하단 버튼 영역 -->
            <div class="product-action-buttons">
                <a href="${pageContext.request.contextPath}/store/StoreList.do" class="btn-back">
                    목록으로
                </a>
                
                <form action="${pageContext.request.contextPath}/store/CartAdd.do" method="post" style="flex: 2; margin: 0;">
                    <input type="hidden" name="productId" value="${product.id}">
                    <button type="submit" class="btn-add-cart" style="width: 100%;">
                        🛒 장바구니 담기
                    </button>
                </form>
            </div>
        </div>

    </div>
</main>