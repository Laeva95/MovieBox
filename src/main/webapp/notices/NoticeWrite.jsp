<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
    <style>

        /* 전체 글쓰기 영역 */
        .notice-write-container {
            width: 80%;
            max-width: 1000px;
            margin: 50px auto;
        }

        /* 제목 */
        .notice-write-section-title {
            font-size: 28px;
            margin-bottom: 10px;
        }

        /* 설명 */
        .notice-write-description {
            color: #888;
            margin-bottom: 35px;
        }

        /* 입력 영역 */
        .notice-write-form-group {
            margin-bottom: 25px;
        }

        /* 입력 항목 이름 */
        .notice-write-form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        /* 제목 입력칸 */
        .notice-write-form-control {
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
        .notice-write-writer-input {
            background-color: #f5f5f5;
            color: #666;
        }

        /* 버튼 영역 */
        .notice-write-button-area {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 35px;
        }

        /* 버튼 공통 */
        .notice-write-btn {
            padding: 12px 25px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        /* 등록 버튼 */
        .notice-write-btn-primary {
            background-color: #222;
            color: white;
        }

        /* 목록 버튼 */
        .notice-write-btn-secondary {
            background-color: #eee;
            color: #333;
        }

        /* 상단 고정 */
        .notice-write-pin-area {
            margin-top: 10px;
        }

    </style>
 

<div class="notice-write-container">


    <!-- 제목 -->
    <h2 class="notice-write-section-title">
        공지사항 작성
    </h2>
    
    <p class="notice-write-description">
        MOVIE BOX의 새로운 공지사항을 등록합니다.
    </p>
    
    <!-- 파일 업로드를 위해 enctype 속성 필수 -->
    <form action="${pageContext.request.contextPath}/notice/writeOk" 
		  method="post"
		  enctype="multipart/form-data">
		  
        <!-- 제목 -->
        <div class="notice-write-form-group">

            <label class="notice-write-form-label" for="notice-write-title-input">
                제목
            </label>

            <input
                type="text"
                name="Title"
                id="notice-write-title-input"
                class="notice-write-form-control"
                maxlength="200"
                placeholder="공지사항 제목을 입력하세요."
                required>

        </div>


        <!-- 작성자 -->
        <div class="notice-write-form-group">

            <label class="notice-write-form-label" for="notice-write-writer-input">
                작성자
            </label>

            <input
                type="text"
                name="noticeWriter"
                id="notice-write-writer-input"
                class="notice-write-form-control notice-write-writer-input"
                value="${sessionScope.id}"
                readonly>

        </div>


        <!-- 첨부파일 -->
        <div class="notice-write-form-group">

            <label class="notice-write-form-label" for="notice-write-file-input">
                첨부파일
            </label>

            <input
                type="file"
                name="uploadFile"
                id="notice-write-file-input">

        </div>


        <!-- 내용 -->
        <div class="notice-write-form-group">

            <label class="notice-write-form-label" for="notice-write-content-input">
                내용
            </label>

            <textarea
                name="noticeContent"
                id="notice-write-content-input"
                class="notice-write-form-control"
                placeholder="공지사항 내용을 입력하세요."
                required></textarea>

        </div>


        <!-- 상단 고정 -->
        <div class="notice-write-pin-area">

            <label>
    			<input type="checkbox" name="is_pinned" value="1"> 상단 고정
			</label>

        </div>


        <!-- 버튼 -->
        <div class="notice-write-button-area">

            <button
                type="button"
                class="notice-write-btn notice-write-btn-secondary"
                onclick="location.href='${pageContext.request.contextPath}/notice/list'">
                목록
            </button>

            <button
                type="submit"
                class="notice-write-btn notice-write-btn-primary">
                등록
            </button>

        </div>

        
    </form>
    