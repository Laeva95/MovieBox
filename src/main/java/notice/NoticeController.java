package notice;

import java.io.File;    
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("/notice/*") // /notice/ 이하의 모든 요청을 이 컨트롤러가 받음
public class NoticeController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NoticeService noticeService = new NoticeService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        process(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        process(request, response);
    }


private void process(HttpServletRequest request,
                     HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");

    String action = request.getPathInfo();
    String command = null;

    if ("/Notice.do".equals(action)) {
        command = "/list";
    } else if ("/NoticeDetail.do".equals(action)) {
        command = "/detail";
    } else if ("/NoticeWrite.do".equals(action)) {
        command = "/write";
    } else if ("/NoticeWriteOk.do".equals(action)) {
        command = "/writeOk";
    } else if ("/NoticeEdit.do".equals(action)) {
        command = "/edit";
    } else if ("/NoticeEditOk.do".equals(action)) {
        command = "/editOk";
    } else if ("/NoticeDeleteOk.do".equals(action)) {
        command = "/deleteOk";
    }

    System.out.println("요청 주소: " + action);
    System.out.println("command: " + command);

    if (command == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
        return;
    }

    switch (command) {
        case "/list":
            listNotice(request, response);
            break;
            
        case "/detail":
            detailNotice(request, response);
            break;
            
        case "/write":
            writeForm(request, response);
            break;
            
        case "/writeOk":
            writeOk(request, response);
            break;
            
        case "/edit":
            editForm(request, response);
            break;
            
        case "/editOk":
            editOk(request, response);
            break;
            
        case "/deleteOk":
            deleteOk(request, response);
            break;
    }
   }

    // 1. 목록 조회 로직 
    private void listNotice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageParam = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        
        int page = 1; // 기본값은 1페이지
        
		if (pageParam != null && !pageParam.isEmpty()) {
				page = Integer.parseInt(pageParam);
		}
		
		 // 한 페이지에 보여줄 게시글 수
	    int pageSize = 10;
	    
	    // 전체 게시글 개수
	    int totalCount = noticeService.getNoticeCount(keyword);

	    // 전체 페이지 수 계산
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
		// 기존 목록 조회
	    List<NoticeDTO> pinnedList = noticeService.getPinnedNoticeList(); // 고정글 목록
	    List<NoticeDTO> noticeList = noticeService.getNoticeList(keyword, page); // 일반 글 목록 (페이징)
        
        // JSP에 전달
	    request.setAttribute("pinnedList", pinnedList);
        request.setAttribute("noticeList", noticeList);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("center", "/notices/Notice.jsp");
        
        
        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }

    // 2. 상세 보기 로직 (기존 NoticeDetailController 내용)
    private void detailNotice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int noticeId = Integer.parseInt(idParam);
                NoticeDTO notice = noticeService.getNoticeDetail(noticeId);
                request.setAttribute("notice", notice);
                request.setAttribute("center", "/notices/NoticeDetail.jsp");
                request.getRequestDispatcher("/Index.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(
        	    request.getContextPath() + "/notice/Notice.do"
        	);
    }

    // 3. 글쓰기 폼 이동 로직
    private void writeForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setAttribute("center", "/notices/NoticeWrite.jsp");
        request.getRequestDispatcher("/Index.jsp").forward(request, response);
    }

    // 4. 글 등록 처리 로직 (파일 업로드 대응 버전)
    private void writeOk(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 파일을 저장할 폴더
        String uploadPath = "/var/www/file_repo";

        // 폴더가 없으면 자동으로 생성
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 최대 업로드 크기: 10MB
        int maxSize = 10 * 1024 * 1024;

        try {
            // COS로 multipart/form-data 요청 처리
            MultipartRequest multi = new MultipartRequest(
                    request,
                    uploadPath,
                    maxSize,
                    "UTF-8",
                    new DefaultFileRenamePolicy()
            );

            // 일반 폼 데이터
            String title = multi.getParameter("Title");
            String writer = multi.getParameter("noticeWriter");
            String content = multi.getParameter("noticeContent");
            
            // 체크박스 값 받아오기 (체크되면 "1" 또는 지정한 값, 안 되면 null)
            String isPinnedStr = multi.getParameter("is_pinned");
            int isPinned = (isPinnedStr != null) ? 1 : 0; // 체크되었으면 1, 아니면 0

            // 업로드된 파일 이름
            String fileName = multi.getFilesystemName("uploadFile");

            System.out.println("전달받은 제목: " + title);
            System.out.println("전달받은 글쓴이: " + writer);
            System.out.println("전달받은 글내용: " + content);
            System.out.println("상단 고정 여부: " + isPinned);
            System.out.println("첨부파일: " + fileName);

            // DTO에 담기
            NoticeDTO notice = new NoticeDTO();

            notice.setTitle(title);
            notice.setWriter(writer);
            notice.setContent(content);
            notice.setFileName(fileName);
            notice.setIsPinned(isPinned);

            // DB에 저장
            noticeService.registerNotice(notice);

            // 등록 후 목록으로 이동
            response.sendRedirect(
            	    request.getContextPath() + "/notice/Notice.do"
            	);

        } catch (Exception e) {
            e.printStackTrace();}
        }
        
     // 수정 화면으로 이동
        private void editForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            try {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    int noticeId = Integer.parseInt(idParam);
                    
                    // 1. 서비스나 DAO를 통해 해당 글 정보 가져오기
                    NoticeDTO notice = noticeService.getNoticeDetail(noticeId);
                    
                    // 2. request에 담아서 jsp로 보내기
                    request.setAttribute("notice", notice);
                    request.setAttribute("center", "/notices/NoticeEdit.jsp");
                    request.getRequestDispatcher("/Index.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(
            	    request.getContextPath() + "/notice/Notice.do"
            	);
        }
        
        // 글 수정 처리 로직
        private void editOk(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String uploadPath = "/var/www/file_repo";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            int maxSize = 10 * 1024 * 1024;

            try {
                MultipartRequest multi = new MultipartRequest(
                        request,
                        uploadPath,
                        maxSize,
                        "UTF-8",
                        new DefaultFileRenamePolicy()
                );

                // 폼에서 넘어온 데이터 받기 (hidden으로 보낸 noticeId 포함!)
                int noticeId = Integer.parseInt(multi.getParameter("noticeId"));
                String title = multi.getParameter("Title");
                String content = multi.getParameter("noticeContent");
                
                String isPinnedStr = multi.getParameter("is_pinned");
                int isPinned = (isPinnedStr != null) ? 1 : 0;

                String fileName = multi.getFilesystemName("uploadFile");
                
                // 만약새로 파일을 올리지 않았다면 기존 파일명을 유지하거나 처리하는 로직이 필요할 수 있습니다.
                // 일단 DTO에 담기
                NoticeDTO notice = new NoticeDTO();
                notice.setNoticeId(noticeId);
                notice.setTitle(title);
                notice.setContent(content);
                notice.setFileName(fileName);
                notice.setIsPinned(isPinned);

                // DB 업데이트 서비스/DAO 호출 (아직 안 만들었다면 3번 단계 참고)
                noticeService.updateNotice(notice);

                // 수정 완료 후 상세 페이지나 목록으로 이동
                response.sendRedirect(
                	    request.getContextPath() + "/notice/NoticeDetail.do?id=" + noticeId
                	);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 삭제 처리 로직
        private void deleteOk(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            try {
                String idParam = request.getParameter("id");
                System.out.println("삭제하려 넘어온 id 파라미터: " + idParam); 
                
                if (idParam != null && !idParam.isEmpty()) {
                    int noticeId = Integer.parseInt(idParam);
                    
                    // DAO 또는 Service에 삭제 메서드 호출 (예: noticeService.deleteNotice(noticeId);)
                    noticeService.deleteNotice(noticeId);
                    System.out.println("삭제 서비스 호출 완료!");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            // 삭제 후 목록으로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/notice/Notice.do");
    }
}