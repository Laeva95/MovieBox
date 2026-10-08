package member;

import java.security.SecureRandom;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {
	private String smtpHost;
    private String smtpPort;
    private String smtpUsername;
    private String smtpPassword;

    public EmailService() throws NamingException {
    	// smtpHost, smtpPort, smtpUsername, smtpPassword 값을 context.xml에서 가져오기
        Context initContext = new InitialContext();
        Context envContext = (Context) initContext.lookup("java:comp/env");

        // context.xml에서 정의한 리소스 이름을 사용하여 값을 가져오기
        smtpHost = (String) envContext.lookup("email/smtpHost");
        smtpPort = (String) envContext.lookup("email/smtpPort");
        smtpUsername = (String) envContext.lookup("email/smtpUsername");
        smtpPassword = (String) envContext.lookup("email/smtpPassword");
    }
    
    // 인증코드 생성
    public String createVerificationCode() {

        SecureRandom random = new SecureRandom();

        int code =
            random.nextInt(1000000);

        return String.format("%06d", code);
    }

    // 인증코드 이메일 전송
    public void sendVerificationCode(
            String receiver,
            String code) throws Exception {

    	// SMTP 서버 설정
        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", "587");

        props.put("mail.smtp.auth", "true");

        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");

        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // SMTP 서버 인증을 위한 세션 생성
        Session mailSession =
            Session.getInstance(
                props,
                new Authenticator() {

                    @Override
                    protected PasswordAuthentication
                    getPasswordAuthentication() {

                        return new PasswordAuthentication(
                            smtpUsername,
                            smtpPassword
                        );
                    }
                }
            );
        
        mailSession.setDebug(true);
        // 이메일 메시지 작성
        Message message = new MimeMessage(mailSession);

        // 보내는 사람, 받는 사람, 제목, 내용 설정
        message.setFrom(new InternetAddress(smtpUsername));

        // 받는 사람 설정
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(receiver));

        // 제목 설정
        message.setSubject("[MovieBox] 이메일 인증번호");

        // 내용 설정
        message.setText("MovieBox 인증번호는 [" + code + "] 입니다.\n\n" + "인증번호는 5분 동안 유효합니다.");

        Transport.send(message);
    }
}
