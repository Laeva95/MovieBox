package exception;

public class ForbiddenException extends RuntimeException {
    // 기본 생성자
    public ForbiddenException() {
        super();
    }

    // 문자열(메시지)을 받는 생성자 (이게 없어서 에러가 난 것입니다!)
    public ForbiddenException(String message) {
        super(message);
    }
}