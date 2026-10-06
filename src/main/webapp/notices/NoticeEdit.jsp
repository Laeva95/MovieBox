<%@ page language="java" 
		 contentType="text/html; charset=UTF-8" 
		 pageEncoding="UTF-8"%>
<%@ page import="notice.NoticeDAO"%>
<%@ page import="notice.NoticeDTO"%>

<%
    // URL 파라미터나 request 속성으로 id 가져오기
    String idParam = request.getParameter("id");
    if (idParam == null) {
        // 속성(Attribute)으로 넘어온 경우 처리
        NoticeDTO n = (NoticeDTO) request.getAttribute("notice");
        if (n != null) {
            idParam = String.valueOf(n.getNoticeId());
        }
    }

    if (idParam == null) {
        response.sendRedirect("list");
        return;
    }

    int id = Integer.parseInt(idParam);

    // DAO에서 해당 공지사항 가져오기
    NoticeDAO dao = new NoticeDAO();
    NoticeDTO notice = dao.getNoticeById(id);

    if (notice == null) {
        response.sendRedirect("list");
        return;
    }
%>
    
    <style>

        /* 전체 글쓰기 영역 */
        .notice-edit-container {
            width: 80%;
            max-width: 1000px;
            margin: 50px auto;
        }

        /* 제목 */
        .notice-edit-section-title {
            font-size: 28px;
            margin-bottom: 10px;
        }

        /* 설명 */
        .notice-edit-description {
            color: #888;
            margin-bottom: 35px;
        }

        /* 입력 영역 */
        .notice-edit-form-group {
            margin-bottom: 25px;
        }

        /* 입력 항목 이름 */
        .notice-edit-form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        /* 제목 입력칸 */
        .notice-edit-form-control {
            width: 100%;
            box-sizing: border-box;
            padding: 14px;
            border: 1px solid #ddd;
            font-size: 15px;
        }

        /* 내용 입력칸 */
        textarea.form-control {
            min-height: 350px;
            resize: vertical;
            line-height: 1.6;
        }

        /* 작성자 입력칸 */
        .notice-edit-writer-input {
            background-color: #f5f5f5;
            color: #666;
        }

        /* 버튼 영역 */
        .notice-edit-button-area {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 35px;
        }

        /* 버튼 공통 */
        .notice-edit-btn {
            padding: 12px 25px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        /* 등록 버튼 */
        .notice-edit-btn-primary {
            background-color: #222;
            color: white;
        }

        /* 목록 버튼 */
        .notice-edit-btn-secondary {
            background-color: #eee;
            color: #333;
        }

        /* 상단 고정 */
        .notice-edit-pin-area {
            margin-top: 10px;
        }

    </style>

<div class="notice-edit-container">
	<br>
	<br>
	<br>

    <!-- 제목 -->
    <h2 class="notice-edit-section-title">
        공지사항 작성
    </h2>
    
    <p class="notice-edit-description">
        MOVIE BOX의 새로운 공지사항을 등록합니다.
    </p>
    
    <!-- 파일 업로드를 위해 enctype 속성 필수 -->
    <form action="${pageContext.request.contextPath}/notice/editOk" 
	      method="post"
	      enctype="multipart/form-data">
	      
	 <input type="hidden" name="noticeId" value="${notice.noticeId}">
		  
        <!-- 제목 -->
        <div class="notice-edit-form-group">

            <label class="notice-edit-form-label" for="notice-edit-title-input">
                제목
            </label>

            <input type="text" 
            	   name="Title" 
            	   id="notice-edit-title-input" 
            	   class="notice-edit-form-control" 
            	   maxlength="200" 
            	   value="${notice.title}" 
            	   required>
        </div>


        <!-- 작성자 -->
        <div class="notice-edit-form-group">

            <label class="notice-edit-form-label" for="notice-edit-writer-input">
                작성자
            </label>

            <input
                type="text"
                name="noticeWriter"
                id="notice-edit-writer-input"
                class="notice-edit-form-control notice-edit-writer-input"
                value="${sessionScope.id}"
                readonly>

        </div>


        <!-- 첨부파일 -->
        <div class="notice-edit-form-group">

            <label class="notice-edit-form-label" for="notice-edit-file-input">
                첨부파일
            </label>

            <input
                type="file"
                name="uploadFile"
                id="notice-edit-file-input">

        </div>


        <!-- 내용 -->
        <div class="notice-edit-form-group">

            <label class="notice-edit-form-label" for="notice-edit-content-input">
                내용
            </label>

            <textarea
			    name="noticeContent"
			    id="notice-edit-content-input"
			    class="notice-edit-form-control"
			    required><%= notice.getContent() %>
			</textarea>
			
        </div>


        <!-- 상단 고정 -->
        <div class="notice-edit-pin-area">

            <label>
    			<input type="checkbox" 
    			       name="is_pinned" 
    			       value="1" <%= (notice.getIsPinned() == 1) ? "checked" : "" %>> 
    			       상단 고정
			</label>

        </div>


        <!-- 버튼 -->
        <div class="notice-edit-button-area">

            <button
                type="button"
                class="notice-edit-btn notice-edit-btn-secondary"
                onclick="location.href='${pageContext.request.contextPath}/notice/list'">
                목록
            </button>

            <button
                type="submit"
                class="notice-edit-btn notice-edit-btn-primary">
                등록
            </button>

        </div>

        
    </form>
