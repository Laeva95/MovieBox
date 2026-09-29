package notice;

import java.util.Date;

public class NoticeDTO {
    private int noticeId;       // notice_id
    private String title;       // title
    private String content;     // content
    private Date createdAt;     // created_at
    private Date updatedAt;     // updated_at
    private int viewCount;      // view_count

    // 기본 생성자
    public NoticeDTO() {}

    // 매개변수가 있는 생성자
    public NoticeDTO(int noticeId, String title, String content, Date createdAt, Date updatedAt, int viewCount) {
        this.noticeId = noticeId;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.viewCount = viewCount;
    }

    // Getter & Setter 메서드
    public int getNoticeId() {
        return noticeId;
    }

    public void setNoticeId(int noticeId) {
        this.noticeId = noticeId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    @Override
    public String toString() {
        return "NoticeDTO [noticeId=" + noticeId + ", title=" + title + ", content=" + content + ", createdAt="
                + createdAt + ", updatedAt=" + updatedAt + ", viewCount=" + viewCount + "]";
    }
}