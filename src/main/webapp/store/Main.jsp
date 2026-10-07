<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<main class="store-container">
    
    <!-- 1. 지점 선택 및 패스트오더 배너 영역 -->
    <div class="store-header-section">
        <div class="theater-selector">
            <span class="location-pin">📍</span>
            <span class="selected-theater">부산서면점</span>
            <button type="button" class="btn-change-theater">극장변경</button>
        </div>
        
        <div class="fast-order-banner">
            <div class="banner-text">
                <span class="highlight">키오스크에서 기다리지 말고</span>
                <h2>패스트오더로 주문하고 픽업하세요!</h2>
            </div>
            <div class="banner-icon">🛒🍿</div>
        </div>
    </div>

    <!-- 2. 카테고리 탭 영역 -->
    <div class="store-nav-tabs">
        <button type="button" class="tab-btn active" data-category="all">전체</button>
        <button type="button" class="tab-btn" data-category="combo">콤보</button>
        <button type="button" class="tab-btn" data-category="popcorn">팝콘</button>
        <button type="button" class="tab-btn" data-category="drink">음료</button>
        <button type="button" class="tab-btn" data-category="snack">스낵</button>
        <button type="button" class="tab-btn" data-category="goods">캐릭터굿즈</button>
    </div>

    <!-- 3. 필터 및 정렬 영역 -->
    <div class="store-filter-bar">
        <div class="sort-options">
            <select name="sort" class="sort-select">
                <option value="recommend">추천순</option>
                <option value="popular">인기순</option>
                <option value="low-price">낮은가격순</option>
                <option value="high-price">높은가격순</option>
            </select>
        </div>
        <div class="pickup-toggle">
            <label>
                <span>나중에 픽업 가능</span>
                <input type="checkbox" id="pickupToggle">
                <span class="slider"></span>
            </label>
        </div>
    </div>

    <!-- 4. 상품 목록 그리드 영역 (DB 데이터를 타임리프로 반복 출력) -->
    <div class="store-item-grid">
        <!-- 반복 구간 (th:each 활용 예시) -->
        <div class="store-item-card">
            <div class="item-badge best">Best</div>
            <div class="item-image-box">
                <!-- 상품 이미지 -->
                <img src="/images/store/sample_goods.png" alt="상품 이미지">
                <button type="button" class="btn-cart-quick" title="장바구니 담기">🛒</button>
            </div>
            <div class="item-info">
                <h3 class="item-name">영화관 한정 팝콘 춘식이 콤보</h3>
                <p class="item-desc">고소팝콘(L) + 탄산음료(M)2 + 춘식이 피규어 컵</p>
                <p class="item-price"><strong>18,500</strong>원</p>
            </div>
        </div>
        
        <!-- 추가 상품 카드들... -->
    </div>

</main>