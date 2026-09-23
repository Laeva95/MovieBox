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
}