package notice;

import java.util.List;

public class NoticeService {
	
    private NoticeDAO noticeDAO = new NoticeDAO();

    // 공지사항 목록을 가져오는 메서드
    public List<NoticeDTO> getNoticeList(String keyword, int page) {
    	
        return noticeDAO.getNoticeList(keyword, page);
    }
    
    // 공지사항 전체 개수 가져오기
    public int getNoticeCount(String keyword) {

        return noticeDAO.getNoticeCount(keyword);

    }
    
    // 특정 번호의 공지사항 상세 정보를 가져오는 메서드
    public NoticeDTO getNoticeDetail(int noticeId) {

    	// 1. 조회수 먼저 올리고
        noticeDAO.increaseViewCount(noticeId); 

        // 2. 상세 정보를 가져와서 반환
        return noticeDAO.getNoticeById(noticeId);
    }
    
    public void registerNotice(NoticeDTO notice) {
    	
        noticeDAO.insertNotice(notice); // DAO에 INSERT 메서드를 호출합니다.
    }
    
}