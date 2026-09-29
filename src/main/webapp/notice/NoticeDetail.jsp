<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 목록에서 넘어온 id 값 받기 (기본값은 1) 
    String idParam = request.getParameter("id");
    int id = (idParam != null) ? Integer.parseInt(idParam) : 1;
    
 	// 전체 제목 배열 (1번부터 3번까지)
    String[] noticeTitles = {
        "", 
        "추석 연휴 영화관 운영 안내", 
        "시스템 점검 안내", 
        "주차장 이용 안내"
    };
    
    // 2. 변수 초기화
    String title = "";
    String content = "";
    String createdAt = "2026-09-23";
    int viewCount = 0;
    
    // 3. id 값에 따라 제목과 본문 내용 다르게 설정하기
    if (id == 1) {
        title = "추석 연휴 영화관 운영 안내";
        content = "<p>안녕하십니까, MOVIE BOX입니다.</p>" +
                  "<p>언제나 저희 MOVIE BOX를 사랑해 주시는 고객님께 진심으로 감사드립니다.</p>" +
                  "<br>" +
                  "<p>민족 대명절 추석 연휴를 맞아, 연휴 기간 동안의 영화관 운영 일정 및 고객센터 운영 안내해 드립니다.</p>" +
                  "<p>고객님께서는 아래 내용을 참고하시어 영화관 이용에 불편이 없으시길 바랍니다.</p>" +
                  "<br>" +
                  "<h3>1. 추석 연휴 영화관 정상 영업 안내</h3>" +
                  "<ul>" +
                  "<li><strong>기간 :</strong> 2026년 9월 28일(월) ~ 2026년 10월 2일(금) [추석 연휴 기간]</li>" +
                  "<li><strong>내용 :</strong> 연휴 기간 동안 전 영화관 및 상영관은 <strong>정상 영업</strong>합니다.</li>" +
                  "</ul>" +
                  "<br>" +
                  "<h3>2. 예매 및 취소 안내</h3>" +
                  "<ul>" +
                  "<li>연휴 기간 중 온라인(홈페이지 및 모바일 앱) 예매 및 결제, 취소는 평소와 동일하게 24시간 이용 가능합니다.</li>" +
                  "<li>현장 매표소 및 매점은 각 영화관 운영 시간에 맞춰 탄력적으로 운영됩니다.</li>" +
                  "</ul>" +
                  "<br>" +
                  "<h3>3. 고객센터 운영 안내</h3>" +
                  "<ul>" +
                  "<li><strong>운영 시간 :</strong> 09:00 ~ 21:00 (추석 당일 포함 연휴 기간 정상 상담 운영)</li>" +
                  "<li>1:1 문의 및 FAQ는 홈페이지를 통해 상시 접수 가능하오니 많은 이용 바랍니다.</li>" +
                  "</ul>" +
                  "<br>" +
                  "<p>풍성하고 행복한 한가위 보내시기를 바랍니다.</p>" +
                  "<p>감사합니다.</p>";
                  
    } else if (id == 2) {
        title = "시스템 점검 안내";
        content = "<p>안녕하십니까, MOVIE BOX입니다.</p>" +
                  "<p>보다 안정적이고 원활한 서비스 제공을 위해 시스템 정기 점검이 진행될 예정입니다.</p>" +
                  "<br>" +
                  "<h3>[점검 안내]</h3>" +
                  "<ul>" +
                  "<li><strong>점검 일시 :</strong> 2026년 10월 14일(수) 02:00 ~ 06:00 (약 4시간 소요)</li>" +
                  "<li><strong>점검 내용 :</strong> 서버 안정화 및 예매/결제 시스템 고도화 작업</li>" +
                  "<li><strong>영향 범위 :</strong> 작업 시간 동안 홈페이지 및 모바일 앱을 통한 영화 예매, 취소, MY PAGE 등 일부 서비스 이용 제한</li>" +
                  "</ul>" +
                  "<br>" +
                  "<p>서비스 이용에 불편을 드려 진심으로 사과드리며, 더욱 나은 서비스를 제공하기 위해 최선을 다하겠습니다.</p>" +
                  "<p>감사합니다.</p>";
                  
    } else if (id == 3) {
        title = "주차장 이용 안내";
        content = "<p>안녕하십니까, MOVIE BOX입니다.</p>" +
                  "<p>영화관 건물 내 주차장 이용 및 요금 정산 방법을 안내해 드립니다.</p>" +
                  "<br>" +
                  "<h3>[주차장 이용 안내]</h3>" +
                  "<ul>" +
                  "<li><strong>할인 대상 :</strong> 영화 관람객 (티켓 바코드 및 스마트 바코드 인증 시)</li>" +
                  "<li><strong>요금 안내 :</strong> 영화 관람 시 3시간 무료, 이후 초과 10분당 500원 부과</li>" +
                  "<li><strong>주의 사항 :</strong> 주차장이 혼잡할 수 있으니 대중교통을 이용해 주시기 바랍니다.</li>" +
                  "</ul>" +
                  "<br>" +
                  "<p>감사합니다.</p>";
    }
    
 	// 4. 이전글 / 다음글 계산
    int prevId = id - 1;
    int nextId = id + 1;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= title %> | MOVIE BOX</title>
<style>
    body { font-family: '맑은 고딕', Arial, sans-serif; color: #222; margin: 0; padding: 40px; background-color: #fff; }
    .container { width: 900px; margin: 0 auto; }
    
    /* 제목 스타일 */
    h2.notice-title { font-size: 22px; font-weight: bold; border-bottom: 2px solid #222; padding-bottom: 20px; margin-bottom: 0; }
    
    /* 상단 정보 박스 스타일 */
    .info-box { background-color: #f8f9fa; border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; padding: 15px 20px; margin-bottom: 30px; display: flex; font-size: 14px; color: #555; }
    .info-item { margin-right: 40px; }
    .info-item span.label { font-weight: bold; color: #222; margin-right: 10px; }
    
    /* 본문 내용 영역 */
    .content { padding: 10px 0 40px 0; min-height: 250px; line-height: 1.6; font-size: 15px; border-bottom: 1px solid #ddd; }
    .content h3 { font-size: 16px; margin-top: 20px; color: #111; }
    .content ul { padding-left: 20px; }
    .content li { margin-bottom: 8px; }
    
    /* 이전글 / 다음글 영역 */
    .nav-row { padding: 15px 10px; border-bottom: 1px solid #eee; font-size: 14px; color: #333; display: flex; align-items: center; }
    .nav-row span.nav-label { font-weight: bold; margin-right: 15px; color: #666; }
    
    /* 목록 버튼 영역 */
    .btn-wrap { margin-top: 40px; text-align: right; }
    .btn { display: inline-block; padding: 10px 30px; background: #333; color: #fff; text-decoration: none; font-size: 14px; border-radius: 2px; }
    .btn:hover { background: #555; }
</style>
</head>
<body>

<div class="container">
	<%-- 동적으로 바뀐 글 제목 출력 --%>
    <h2 class="notice-title"><%= title %></h2>
    
    <%-- 상단 메타 정보 박스 --%>
    <div class="info-box">
    	<div class="info-item"><span class="label">영화관</span> 전체</div>
        <div class="info-item"><span class="label">등록일</span> <%= createdAt %></div>
        <div class="info-item"><span class="label">조회수</span> 0</div>
    </div>
    
    <%-- 동적으로 바뀐 본문 내용 출력 --%>
    <div class="content">
        <%= content %>
    </div>
    
	<%-- 다음글 네비게이션 --%>
    <div class="nav-row">
        <span class="nav-label">다음글 &and;</span> 
        <% if (nextId <= 3) { %>
            <a href="NoticeDetail.jsp?id=<%= nextId %>" style="text-decoration: none; color: #333;"><%= noticeTitles[nextId] %></a>
        <% } else { %>
            <span style="color: #999;">다음글이 없습니다.</span>
        <% } %>
    </div>
    
    <%-- 이전글 네비게이션 --%>
    <div class="nav-row">
        <span class="nav-label">이전글 &or;</span> 
        <% if (prevId >= 1) { %>
            <a href="NoticeDetail.jsp?id=<%= prevId %>" style="text-decoration: none; color: #333;"><%= noticeTitles[prevId] %></a>
        <% } else { %>
            <span style="color: #999;">이전글이 없습니다.</span>
        <% } %>
    </div>

    <%-- 목록으로 가기 버튼 (NoticeList.jsp로 이동) --%>
    <div class="btn-wrap">
        <a href="NoticeList.jsp" class="btn">목록</a>
    </div>
</div>

</body>
</html>