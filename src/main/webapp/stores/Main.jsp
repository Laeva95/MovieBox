<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<style>
/* 전체 레이아웃 */
.store-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 40px 24px 80px;
    color: #222;
    font-family: Arial, "Malgun Gothic", sans-serif;
    box-sizing: border-box;
}

.store-container *,
.store-container *::before,
.store-container *::after {
    box-sizing: border-box;
}

/* 지점 선택 */
.store-header-section {
    margin-bottom: 32px;
}

.theater-selector {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 24px;
    font-size: 14px;
}

.selected-theater {
    font-weight: bold;
}

.btn-change-theater {
    padding: 7px 13px;
    border: 1px solid #ddd;
    border-radius: 20px;
    background: white;
    cursor: pointer;
}

/* 패스트오더 배너 */
.fast-order-banner {
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 190px;
    padding: 32px 40px;
    border-radius: 16px;
    background: #f5f5f5;
}

.banner-text .highlight {
    display: block;
    margin-bottom: 12px;
    color: #c9283e;
    font-size: 14px;
    font-weight: bold;
}

.banner-text h2 {
    margin: 0;
    font-size: 28px;
    line-height: 1.5;
    letter-spacing: -1px;
}

.banner-icon {
    font-size: 64px;
}

/* 카테고리 메뉴 (가독성 및 디자인 대폭 개선) */
.store-nav-tabs {
    display: flex;
    gap: 16px;
    margin-bottom: 28px;
    border-bottom: 1px solid #eaeaea;
    overflow-x: auto;
    padding-bottom: 2px;
}

.tab-btn {
    flex-shrink: 0;
    padding: 12px 20px;
    border: 1px solid #e0e0e0;
    border-radius: 30px;
    background: #ffffff;
    color: #444;
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
}

.tab-btn:hover {
    background: #f8f9fa;
    color: #c9283e;
    border-color: #c9283e;
}

.tab-btn.active {
    background: #c9283e;
    color: #ffffff;
    border-color: #c9283e;
    font-weight: bold;
    box-shadow: 0 4px 10px rgba(201, 40, 62, 0.25);
}

/* 정렬 및 픽업 */
.store-filter-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 24px;
}

.sort-select {
    padding: 10px 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    background: white;
}

.pickup-toggle label {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #555;
    font-size: 14px;
    cursor: pointer;
}

.pickup-toggle input {
    width: 17px;
    height: 17px;
    accent-color: #c9283e;
}

/* 상품 목록 */
.store-item-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 28px 20px;
}

/* 상품 카드 */
.store-item-card {
    position: relative;
    min-width: 0;
    overflow: hidden;
    border: 1px solid #eee;
    border-radius: 12px;
    background: white;
    transition: transform 0.2s, box-shadow 0.2s;
}

.store-item-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

/* 상품 이미지 */
.item-image-box {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    aspect-ratio: 1 / 1;
    padding: 16px;
    background: #fafafa;
}

.item-image-box img {
    width: 100%;
    height: 100%;
    object-fit: contain;
}

.btn-cart-quick {
    position: absolute;
    right: 12px;
    bottom: 12px;
    width: 40px;
    height: 40px;
    border: 1px solid #ddd;
    border-radius: 50%;
    background: white;
    font-size: 18px;
    cursor: pointer;
}

.btn-cart-quick:hover {
    background: #f0f0f0;
}

/* BEST 배지 */
.item-badge {
    position: absolute;
    top: 12px;
    left: 12px;
    z-index: 1;
    padding: 5px 9px;
    border-radius: 4px;
    font-size: 11px;
    font-weight: bold;
}

.item-badge.best {
    background: #c9283e;
    color: white;
}

/* 상품 설명 */
.item-info {
    padding: 18px 16px 20px;
}

.item-name {
    margin: 0 0 10px;
    font-size: 16px;
    line-height: 1.5;
    word-break: keep-all;
}

.item-desc {
    min-height: 40px;
    margin: 0 0 16px;
    color: #888;
    font-size: 12px;
    line-height: 1.7;
    word-break: keep-all;
}

.item-price {
    margin: 0;
    font-size: 14px;
}

.item-price strong {
    font-size: 21px;
}

/* 태블릿 및 모바일 반응형 */
@media (max-width: 900px) {
    .store-item-grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 20px 14px;
    }
}

@media (max-width: 600px) {
    .store-item-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 16px 10px;
    }
}
</style>
    
<main class="store-container">
    
    <!-- 1. 지점 선택 및 패스트오더 배너 영역 -->
    <div class="store-header-section">
        <div class="theater-selector"></div>
        
        <div class="fast-order-banner">
            <div class="banner-text">
                <span class="highlight">키오스크에서 기다리지 말고</span>
                <h2>패스트오더로 주문하고 픽업하세요!</h2>
            </div>
            <div class="banner-icon">🛒🍿</div>
        </div>
    </div>

    <!-- 2. 카테고리 탭 영역 -->
    <form action="${pageContext.request.contextPath}/store/StoreList.do"
          method="get"
          class="store-nav-tabs">

        <button type="submit"
                name="category"
                value="전체"
                class="tab-btn ${empty selectedCategory or selectedCategory eq '전체' ? 'active' : ''}">
            전체
        </button>

        <button type="submit"
                name="category"
                value="팝콘"
                class="tab-btn ${selectedCategory eq '팝콘' ? 'active' : ''}">
            팝콘
        </button>

        <button type="submit"
                name="category"
                value="음료"
                class="tab-btn ${selectedCategory eq '음료' ? 'active' : ''}">
            음료
        </button>

        <button type="submit"
                name="category"
                value="스낵"
                class="tab-btn ${selectedCategory eq '스낵' ? 'active' : ''}">
            스낵
        </button>
    </form>

    <!-- 3. 필터 및 정렬 영역 -->
    <div class="store-filter-bar">
        <div class="sort-options">
            <form action="${pageContext.request.contextPath}/store/StoreList.do"
                  method="get"
                  id="sortForm">

                <input type="hidden"
                       name="category"
                       value="${empty selectedCategory ? '전체' : selectedCategory}">

                <select name="sort"
                        class="sort-select"
                        onchange="this.form.submit()">

                    <option value="recommend"
                        ${empty selectedSort or selectedSort eq 'recommend' ? 'selected' : ''}>
                        추천순
                    </option>

                    <option value="popular"
                        ${selectedSort eq 'popular' ? 'selected' : ''}>
                        인기순
                    </option>

                    <option value="low-price"
                        ${selectedSort eq 'low-price' ? 'selected' : ''}>
                        낮은가격순
                    </option>

                    <option value="high-price"
                        ${selectedSort eq 'high-price' ? 'selected' : ''}>
                        높은가격순
                    </option>
                </select>
            </form>
        </div>

        <div class="pickup-toggle">
            <label>
                <span>나중에 픽업 가능</span>
                <input type="checkbox" id="pickupToggle">
                <span class="slider"></span>
            </label>
        </div>
    </div>

    <!-- 4. 상품 목록 그리드 영역 -->
    <div class="store-item-grid">
        <c:forEach var="product" items="${storeList}">
            <div class="store-item-card" onclick="location.href='${pageContext.request.contextPath}/store/StoreDetail.do?productId=${product.id}'" style="cursor: pointer;">
                <div class="item-image-box">
                    <img src="${pageContext.request.contextPath}/images/${product.image}"
                         alt="${product.name}">

                    <form action="${pageContext.request.contextPath}/store/CartAdd.do"
					      method="post"
					      class="cart-add-form"
					      onclick="event.stopPropagation()">

                        <input type="hidden"
                               name="productId"
                               value="${product.id}">

                        <button type="submit"
                                class="btn-cart-quick"
                                title="장바구니 담기">🛒</button>
                    </form>
                </div>

                <div class="item-info">
                    <h3 class="item-name">${product.name}</h3>
                    <p class="item-desc">${product.description}</p>
                    <p class="item-price">
                        <strong>${product.price}</strong>원
                    </p>
                </div>
            </div>
        </c:forEach>
    </div>

</main>