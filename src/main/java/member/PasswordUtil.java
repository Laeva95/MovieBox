package member;

import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

    // salt 생성
    public static String createSalt() {
        SecureRandom random = new SecureRandom();

        byte[] salt = new byte[16];

        // 무작위 값을 통해 salt 생성
        random.nextBytes(salt);

        return Base64.getEncoder().encodeToString(salt);
    }
    
    // 비밀번호 해싱
    public static String hashPassword(String password, String salt) {

        try {

            // 문자열 형태의 salt를 다시 byte 배열로 변환
            byte[] saltBytes = Base64.getDecoder().decode(salt);

            // PBKDF2 설정
            PBEKeySpec spec = new PBEKeySpec(
                    password.toCharArray(), // 비밀번호
                    saltBytes,              // salt
                    65536,                  // 반복 횟수
                    256                     // 생성할 해시 길이
            );

            // PBKDF2 + HMAC + SHA-256 사용
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            byte[] hash = factory.generateSecret(spec).getEncoded();

            // 해시 byte[]를 문자열로 변환
            return Base64.getEncoder().encodeToString(hash);

        } catch (Exception e) {

            throw new RuntimeException(e);
        }
    }
    
    // 비밀번호와 salt를 해싱하여 하나의 문자열로 반환
    public static String createPasswordHash(String password) {

        // salt 생성
        String salt = createSalt();

        // 비밀번호 해싱
        String hash = hashPassword(password, salt);

        // salt와 hash를 하나의 문자열로 합침
        return salt + ":" + hash;
    }
    
 // 비밀번호가 기존 해시와 일치하는지 확인
    public static boolean checkPassword(String password, String storedPassword) {

        // salt와 hash를 ":" 기준으로 분리
        String[] parts = storedPassword.split(":");

        // salt와 hash가 둘 다 존재하지 않으면 잘못된 값
        if (parts.length != 2) {
            return false;
        }

        // DB에 저장되어 있던 salt
        String salt = parts[0];

        // DB에 저장되어 있던 hash
        String storedHash = parts[1];

        // 입력받은 비밀번호를 기존 salt로 다시 해싱
        String inputHash = hashPassword(password, salt);

        // 기존 hash와 새로 만든 hash 비교
        return storedHash.equals(inputHash);
    }
}