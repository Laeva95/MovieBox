<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 상세 | MOVIE BOX</title>
<style>
    body { font-family: Arial, sans-serif; color: #222; margin: 0; padding: 40px; }
    .container { width: 800px; margin: 0 auto; }
    h2 { border-bottom: 2px solid #222; padding-bottom: 15px; }
    .info { color: #777; margin-bottom: 20px; font-size: 14px; }
    .content { padding: 30px 0; border-bottom: 1px solid #ddd; min-height: 200px; }
    .btn-wrap { margin-top: 30px; text-align: right; }
    .btn { padding: 10px 20px; background: #222; color: #fff; text-decoration: none; border-radius: 4px; }
</style>
</head>
<body>

<div class="container">
    <h2>${notice.title}</h2>
    <div class="info">
        작성일: ${notice.createdAt} &nbsp;|&nbsp; 조회수: ${notice.viewCount}
    </div>
    
    <div class="content">
        ${notice.content}
    </div>
    
    <div class="btn-wrap">
        <a href="list" class="btn">목록으로</a>
    </div>
</div>

</body>
</html>