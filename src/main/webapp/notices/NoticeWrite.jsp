<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>영화예매 - 공지사항 작성</title>
    
    <style>

        /* 전체 글쓰기 영역 */
        .notice-container {
            width: 80%;
            max-width: 1000px;
            margin: 50px auto;
        }

        /* 제목 */
        .section-title {
            font-size: 28px;
            margin-bottom: 10px;
        }

        /* 설명 */
        .notice-description {
            color: #888;
            margin-bottom: 35px;
        }

        /* 입력 영역 */
        .form-group {
            margin-bottom: 25px;
        }

        /* 입력 항목 이름 */
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        /* 제목 입력칸 */
        .form-control {
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
        .writer-input {
            background-color: #f5f5f5;
            color: #666;
        }

        /* 버튼 영역 */
        .button-area {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 35px;
        }

        /* 버튼 공통 */
        .btn {
            padding: 12px 25px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        /* 등록 버튼 */
        .btn-primary {
            background-color: #222;
            color: white;
        }

        /* 목록 버튼 */
        .btn-secondary {
            background-color: #eee;
            color: #333;
        }

        /* 상단 고정 */
        .pin-area {
            margin-top: 10px;
        }

    </style>
    
</head>
<body>

<div class="notice-container">


    <!-- 제목 -->
    <h2 class="section-title">
        공지사항 작성
    </h2>
    
    <p class="notice-description">
        MOVIE BOX의 새로운 공지사항을 등록합니다.
    </p>
    
    <!-- 파일 업로드를 위해 enctype 속성 필수 -->
    <form action="${pageContext.request.contextPath}/notice/writeOk" 
		  method="post"
		  enctype="multipart/form-data">
		  
        <!-- 제목 -->
        <div class="form-group">

            <label class="form-label" for="noticeTitle">
                제목
            </label>

            <input
                type="text"
                name="Title"
                id="noticeTitle"
                class="form-control"
                maxlength="200"
                placeholder="공지사항 제목을 입력하세요."
                required>

        </div>


        <!-- 작성자 -->
        <div class="form-group">

            <label class="form-label" for="noticeWriter">
                작성자
            </label>

            <input
                type="text"
                name="noticeWriter"
                id="noticeWriter"
                class="form-control writer-input"
                value="${sessionScope.id}"
                readonly>

        </div>


        <!-- 첨부파일 -->
        <div class="form-group">

            <label class="form-label" for="uploadFile">
                첨부파일
            </label>

            <input
                type="file"
                name="uploadFile"
                id="uploadFile">

        </div>


        <!-- 내용 -->
        <div class="form-group">

            <label class="form-label" for="noticeContent">
                내용
            </label>

            <textarea
                name="noticeContent"
                id="noticeContent"
                class="form-control"
                placeholder="공지사항 내용을 입력하세요."
                required></textarea>

        </div>


        <!-- 상단 고정 -->
        <div class="pin-area">

            <label>
                <input
                    type="checkbox"
                    name="is_pinned"
                    value="1">

                상단 고정
            </label>

        </div>


        <!-- 버튼 -->
        <div class="button-area">

            <button
                type="button"
                class="btn btn-secondary"
                onclick="location.href='${pageContext.request.contextPath}/notice/list'">
                목록
            </button>

            <button
                type="submit"
                class="btn btn-primary">
                등록
            </button>

        </div>

        
    </form>
    
</body>

</html>