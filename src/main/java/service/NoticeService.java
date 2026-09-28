package service;

import java.util.List; 
import dao.NoticeDAO;
import dto.NoticeDTO;

public class NoticeService {
    private NoticeDAO noticeDAO = new NoticeDAO();

    // 공지사항 목록을 가져오는 메서드
    public List<NoticeDTO> getNoticeList() {
        return noticeDAO.getNoticeList();
    }
    
 // 특정 번호의 공지사항 상세 정보를 가져오는 메서드
    public NoticeDTO getNoticeDetail(int noticeId) {
        return noticeDAO.getNoticeById(noticeId);
    }
}