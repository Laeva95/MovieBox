// 이 파일이 속한 폴더(패키지) 이름. 실제 폴더 경로 util 와 반드시 같아야 한다
package util;   // 이 파일이 속한 패키지(=폴더) 이름. 실제 폴더 구조와 반드시 같아야 한다
// java.io 안의 File 를 이 파일에서 쓰겠다는 선언
import java.io.File;   // 파일 하나를 가리키는 객체 (존재 확인·삭제 등)
// IOException 를 가져온다 — 입출력 중 생기는 오류를 받기 위해
import java.io.IOException;   // 파일/네트워크 입출력이 실패했을 때의 예외
// java.util 안의 Arrays 를 이 파일에서 쓰겠다는 선언
import java.util.Arrays;   // 배열을 다루는 도우미 모음
// java.util 안의 Collections 를 이 파일에서 쓰겠다는 선언
import java.util.Collections;   // 목록을 정렬·뒤집기 등 할 때 쓰는 도우미 모음
// java.util 안의 HashSet 를 이 파일에서 쓰겠다는 선언
import java.util.HashSet;   // Set 을 실제로 만들 때 쓰는 구현체
// java.util 안의 Set 를 이 파일에서 쓰겠다는 선언
import java.util.Set;   // 중복을 허용하지 않는 모음. "이 안에 들어 있나?" 를 빠르게 확인할 때 쓴다
// java.util 안의 UUID 를 이 파일에서 쓰겠다는 선언
import java.util.UUID;   // 겹치지 않는 임의의 문자열을 만들어 준다 (파일 이름 겹침 방지에 사용)
// exception 안의 ForbiddenException 를 이 파일에서 쓰겠다는 선언
import exception.ForbiddenException;   // 직접 만든 예외 클래스
// exception 안의 InvalidInputException 를 이 파일에서 쓰겠다는 선언
import exception.InvalidInputException;   // 직접 만든 예외 클래스
// exception 안의 NotFoundException 를 이 파일에서 쓰겠다는 선언
import exception.NotFoundException;   // 직접 만든 예외 클래스
/*
 ================================================================================
   FileRepo  -  첨부파일 저장 위치와 파일명을 관리하는 클래스
   [기존 코드의 문제 1 : 경로 하드코딩 3곳]
       FileBoardController : private static String ARTICLE_REPO = "C:\\file_repo";  (사용조차 안 됨)
       FileBoardService    : new File("C:\\file_repo")          (업로드)
       FileBoardService    : "C:\\file_repo\\" + articleNO      (이동)
       FileBoardService    : "C:\\file_repo\\" + idx            (다운로드)
     경로를 바꾸려면 여러 파일을 고쳐야 하고, C 드라이브가 없는 환경에서는 동작하지 않는다.
   [기존 코드의 문제 2 : 경로 조작(Path Traversal) 취약점]
     다운로드가 사용자 파라미터를 그대로 이어 붙였다.
         String idx  = request.getParameter("path");
         String name = request.getParameter("fileName");
         File f = new File("C:\\file_repo\\" + idx + "\\" + name);
     여기에 ..\ 를 넣으면 저장 폴더를 벗어나 서버의 아무 파일이나 내려받을 수 있다.
         /FileBoard/Download.do?path=..&fileName=..\web.xml
   [기존 코드의 문제 3 : 저장 파일명 = 원본 파일명]
         sfileNameList.add(fileName);   // 저장명
         ofileNameList.add(fileName);   // 원본명  <- 둘이 같다
     - 다른 사람이 같은 이름으로 올리면 서로 덮어쓴다
     - 파일명에 ';' 가 들어가면 목록 구분자가 깨진다
     - 확장자 제한이 없어 실행 가능한 파일도 올라간다
   [해결]
     - 경로는 설정값 file.repo.path 한 곳에서 관리 (기본값 C:\file_repo)
     - 저장명은 UUID + 확장자로 새로 만들고, 원본명은 DB에만 보관
     - 확장자는 허용 목록(화이트리스트) 방식으로 검사
     - 다운로드 파일은 getCanonicalPath()로 "저장 폴더 안"인지 반드시 확인
 ================================================================================
*/
public class FileRepo {
	/** 첨부파일 저장 폴더 — 필요하면 이 한 줄만 바꾼다 */
	// 자바 문자열에서 역슬래시(\)는 특별한 뜻이라 두 번 써야 한 번으로 읽힌다.
	// 즉 "C:\\file_repo_edu" 는 실제로는 C:\file_repo_edu 를 뜻한다.
	// 교육판이라 원본(C:\file_repo)과 폴더를 분리해 두었다.
	private static final String DEFAULT_ROOT   = "C:\\file_repo_edu";
	// 10L * 1024 * 1024 = 10,485,760 바이트 = 10MB.  L 은 long 타입이라는 표시다.
	// 1024 를 두 번 곱하면 바이트 → KB → MB 가 된다. 그냥 숫자로 적는 것보다 뜻이 분명하다.
	private static final long   DEFAULT_MAX_FILE = 10L * 1024 * 1024;  // 파일 1개 10MB
	// 한 번에 여러 개를 올릴 수 있으므로 요청 전체 한도를 따로 둔다
	private static final long   DEFAULT_MAX_REQ  = 30L * 1024 * 1024;  // 요청 전체 30MB
	/**
	 * 업로드 허용 확장자 기본값.
	 * 화이트리스트이므로 jsp, class, exe, bat, sh, php 등은 "적지 않는 것만으로" 차단된다.
	 */
	// 값을 여기서 바로 못 정하고 아래 static 블록에서 채운다.
	// 목록을 만드는 데 여러 줄이 필요하기 때문이다.
	private static final Set<String> DEFAULT_ALLOWED_EXT;
	// static 블록 = 이 클래스가 처음 메모리에 올라올 때 딱 한 번 실행되는 부분
	static {
		// Arrays.asList(...) 로 확장자들을 목록으로 만들고, 그걸 HashSet 에 담는다.
		// Set 에 담는 이유 : contains("jpg") 같은 "들어 있나?" 검사가 매우 빠르기 때문이다.
		Set<String> s = new HashSet<String>(Arrays.asList(
				"jpg", "jpeg", "png", "gif", "bmp", "webp",       // 이미지
				"pdf", "txt", "csv", "hwp", "hwpx",               // 문서
				"doc", "docx", "xls", "xlsx", "ppt", "pptx",      // 오피스
				"zip", "7z"                                       // 압축
		));
		// unmodifiableSet = "읽기 전용" 으로 잠근다.
		// 누군가 실수로 목록에 "jsp" 를 추가하면 보안 구멍이 뚫리므로 아예 못 바꾸게 막는다.
		DEFAULT_ALLOWED_EXT = Collections.unmodifiableSet(s);
	}
	// 도구 모음 클래스라 객체를 만들 필요가 없다 (HtmlUtil·ParamUtil 과 같은 이유)
	private FileRepo() {}
	//===========================================================
	// 1. 경로
	//===========================================================
	/** 첨부파일 최상위 저장 폴더 */
	public static File getRoot() {
		// File 객체를 만든다고 해서 폴더가 생기는 것은 아니다.
		// "이 경로를 가리키는 이름표" 를 만드는 것뿐이다. 실제 생성은 mkdirs() 가 한다.
		return new File(DEFAULT_ROOT);
	}
	// 저장 폴더의 전체 경로를 글자로 돌려준다 (화면 안내나 로그에 쓴다)
	public static String getRootPath() {
		// getAbsolutePath() = "C:\file_repo_edu" 처럼 처음부터 끝까지의 경로 문자열
		return getRoot().getAbsolutePath();
	}
	/** 업로드 도중 임시로 받아두는 폴더 (글번호를 아직 모르는 단계) */
	public static File getTempDir() {
		// new File(부모폴더, "이름") 형태로 쓰면 경로를 문자열로 이어 붙이지 않아도 된다.
		// 운영체제마다 다른 구분자(\ 와 /)를 자바가 알아서 처리해 준다.
		return new File(getRoot(), "temp");
	}
	/** 글 1건의 첨부파일이 모이는 폴더 (글번호별) */
	public static File getArticleDir(int articleNo) {
		// 글번호 7번이면 C:\file_repo_edu\7 폴더가 된다.
		// String.valueOf(숫자) 는 숫자를 글자로 바꾸는 방법이다(폴더 이름은 글자여야 하므로).
		return new File(getRoot(), String.valueOf(articleNo));
	}
	/**
	 * 서버 시작 시 폴더를 만들어 둔다.
	 * (기존에는 업로드하는 순간 폴더가 없으면 예외가 났다)
	 */
	public static void prepareDirectories() {
		// 최상위 저장 폴더를 만든다
		makeDir(getRoot());
		// 임시 폴더도 미리 만들어 둔다
		makeDir(getTempDir());
	}
	// 폴더가 없으면 만들어 주는 도우미. private 이라 이 클래스 안에서만 쓴다.
	private static void makeDir(File dir) {
		// exists() = 이미 있는가.  mkdirs() = 중간 폴더까지 한꺼번에 만든다(성공하면 true).
		// "없고(!exists) 만들기도 실패했다(!mkdirs)" 면 문제 상황이다.
		if (!dir.exists() && !dir.mkdirs()) {
			// 권한이 없거나 경로가 잘못된 경우다. 서버를 멈추지는 않고 콘솔에만 알린다.
			System.out.println("[FileRepo] 폴더 생성 실패 : " + dir.getAbsolutePath());
		}
	}
	//===========================================================
	// 2. 업로드 제한
	//===========================================================
	// 파일 하나의 최대 크기를 알려 준다 (업로드 처리 쪽에서 이 값과 비교한다)
	public static long getMaxFileSize() {
		return DEFAULT_MAX_FILE;   // 위에 정해 둔 10MB 를 알려 준다
	}
	// 요청 하나(=여러 파일을 합친) 최대 크기를 알려 준다
	public static long getMaxRequestSize() {
		return DEFAULT_MAX_REQ;   // 위에 정해 둔 30MB 를 알려 준다
	}
	/** 허용 확장자 목록 */
	public static Set<String> getAllowedExtensions() {
		// 위에서 읽기 전용으로 잠가 뒀으므로 그대로 내보내도 바깥에서 못 고친다
		return DEFAULT_ALLOWED_EXT;
	}
	//===========================================================
	// 3. 파일명 처리
	//===========================================================
	/**
	 * 브라우저가 보내온 파일명에서 "이름만" 안전하게 뽑아낸다.
	 *   - IE는 "C:\Users\...\사진.jpg" 처럼 전체 경로를 보낸다 -> 마지막 이름만 사용
	 *   - 경로 구분자, 제어문자, 목록 구분자로 쓰는 ; 를 제거
	 */
	public static String cleanOriginalName(String rawName) {
		// 파일명이 아예 없으면 더 진행할 수 없다
		if (rawName == null) {
			// InvalidInputException 를 던져 여기서 중단한다. 위쪽 공통 처리기가 받아 알맞은 오류 화면을 보여준다
			throw new InvalidInputException("첨부파일 이름이 없습니다");
		}
		// 원본은 그대로 두고 작업용 변수에 옮겨 담는다 (아래에서 여러 번 다듬을 것이다)
		String name = rawName;
		// 윈도우/유닉스 경로 제거
		// lastIndexOf = 그 글자가 마지막으로 나오는 위치. 없으면 -1.
		// 윈도우는 \ , 맥/리눅스는 / 를 쓰므로 둘 중 더 뒤에 있는 위치를 고른다.
		int slash = Math.max(name.lastIndexOf('\\'), name.lastIndexOf('/'));
		// 0 이상이면 경로 구분자가 들어 있다는 뜻이다
		if (slash >= 0) {
			// 그 다음 글자부터 끝까지만 남긴다 → "C:\Users\사진.jpg" 에서 "사진.jpg" 만
			name = name.substring(slash + 1);
		}
		// 위험/혼란 문자 제거
		// [ ] 안의 글자들 중 하나라도 나오면 "_" 로 바꾼다.
		//   \\\\ = 역슬래시,  / : * ? " < > | = 윈도우가 파일명에 못 쓰게 하는 글자들
		//   ;      = 이 프로젝트가 파일 목록을 구분할 때 쓰는 글자라 섞이면 목록이 깨진다
		//   \\r \\n \\t = 줄바꿈·탭 같은 눈에 안 보이는 글자
		// 마지막 trim() 으로 앞뒤 공백까지 정리한다.
		name = name.replaceAll("[\\\\/:*?\"<>|;\\r\\n\\t]", "_").trim();
		// 앞에 붙은 점 제거 ( ".." 이나 숨김파일 형태 차단 )
		// while = 조건이 참인 동안 계속 반복. "...파일" 처럼 점이 여러 개여도 전부 없앤다.
		while (name.startsWith(".")) {
			// 첫 글자를 잘라내고 나머지를 다시 담는다
			name = name.substring(1);
		}
		// 다듬고 나니 아무것도 안 남은 경우(예: 이름이 "..." 뿐이었다)
		if (name.isEmpty()) {
			// InvalidInputException 를 던져 여기서 중단한다. 위쪽 공통 처리기가 받아 알맞은 오류 화면을 보여준다
			throw new InvalidInputException("첨부파일 이름이 올바르지 않습니다");
		}
		// DB 컬럼 길이를 넘지 않게 자른다 (확장자는 살린다)
		if (name.length() > 120) {
			// 먼저 확장자를 따로 빼 둔다 (자를 때 확장자까지 날아가면 안 되므로)
			String ext = getExtension(name);
			// 확장자와 점(.) 이 차지할 자리를 뺀 만큼만 이름에 쓸 수 있다
			int keep = 120 - (ext.isEmpty() ? 0 : ext.length() + 1);
			// 앞에서부터 keep 글자만 남기고, 빼 뒀던 확장자를 다시 붙인다.
			// Math.max(1, keep) 은 확장자가 아주 길 때 keep 이 0 이하가 되는 것을 막는 안전장치다.
			name = name.substring(0, Math.max(1, keep)) + (ext.isEmpty() ? "" : "." + ext);
		}
		// 안전하게 다듬어진 원본 파일명을 돌려준다 (이 값은 DB 에만 저장된다)
		return name;
	}
	/** 확장자만 소문자로 반환 (없으면 빈 문자열) */
	public static String getExtension(String fileName) {
		// 이름이 없으면 확장자도 없다
		if (fileName == null) {
			// 결과 "" 를 불러준 쪽에 돌려준다
			return "";
		}
		// 마지막 점의 위치를 찾는다. "내.사진.jpg" 처럼 점이 여러 개일 수 있어 "마지막" 을 본다.
		int dot = fileName.lastIndexOf('.');
		// 점이 아예 없거나(-1), 점이 맨 끝에 있으면(예: "파일.") 확장자가 없는 것이다
		if (dot < 0 || dot == fileName.length() - 1) {
			// 결과 "" 를 불러준 쪽에 돌려준다
			return "";
		}
		// 점 다음부터 끝까지를 잘라내고 소문자로 통일한다.
		// 소문자로 맞추는 이유 : "JPG" 와 "jpg" 를 같은 것으로 취급해야 허용 목록 검사가 정확해진다.
		return fileName.substring(dot + 1).toLowerCase();
	}
	/** 허용된 확장자인지 검사하고, 아니면 400 예외를 던진다 */
	public static void validateExtension(String fileName) {
		// 확장자를 뽑아낸다
		String ext = getExtension(fileName);
		// 확장자가 없는 파일은 무엇인지 알 수 없으므로 막는다
		if (ext.isEmpty()) {
			// InvalidInputException 를 던져 여기서 중단한다. 위쪽 공통 처리기가 받아 알맞은 오류 화면을 보여준다
			throw new InvalidInputException("확장자가 없는 파일은 올릴 수 없습니다 : " + fileName);
		}
		// contains = 허용 목록 안에 있는가. ! 를 붙였으니 "목록에 없으면" 이라는 뜻이다.
		// 이것이 화이트리스트 방식이다. jsp·exe 를 막는 코드는 없지만 목록에 없으므로 자동으로 막힌다.
		if (!getAllowedExtensions().contains(ext)) {
			// 무엇이 허용되는지 함께 알려 줘야 사용자가 다시 시도할 수 있다
			throw new InvalidInputException(
					"허용되지 않는 파일 형식입니다 : ." + ext
					// String.join(", ", 목록) = 목록을 쉼표로 이어 한 줄 글자로 만든다
					+ " (허용 : " + String.join(", ", getAllowedExtensions()) + ")");
		}
	}
	/**
	 * 실제 디스크에 저장할 파일명을 새로 만든다.
	 *   원본 : 여행사진.jpg
	 *   저장 : 3f2b9c1e8a7d4f60b1c2d3e4f5a6b7c8.jpg
	 * 겹칠 확률이 사실상 없고, 원본 파일명이 경로/스크립트로 해석될 여지도 없다.
	 */
	public static String newStoredName(String originalName) {
		// 확장자는 살려 둔다. 확장자가 없으면 브라우저가 파일 종류를 몰라 다운로드가 어색해진다.
		String ext = getExtension(originalName);
		// UUID = 전 세계에서 겹치지 않도록 만들어진 임의의 값.
		// toString() 하면 8-4-4-4-12 형태라 보기 나쁘므로 replace 로 하이픈을 없앤다.
		String uuid = UUID.randomUUID().toString().replace("-", "");
		// 확장자가 없으면 UUID 만, 있으면 "UUID.확장자" 형태로 만든다
		return ext.isEmpty() ? uuid : (uuid + "." + ext);
	}
	//===========================================================
	// 4. 다운로드 대상 파일 확인 (경로 조작 차단)
	//===========================================================
	/**
	 * 글번호 폴더 안의 저장파일을 가리키는 File을 돌려준다.
	 * 아래 두 가지를 반드시 확인한다.
	 *   1) 최종 경로가 저장 루트 "안"에 있는지  (../ 같은 경로 조작 차단)
	 *   2) 파일이 실제로 존재하는지
	 *
	 * 주의 : storedName은 반드시 "DB에서 조회한 값"을 넘겨야 한다.
	 *        사용자가 보낸 파라미터를 그대로 넘기면 이 검사만으로는 부족하다.
	 */
	public static File resolveStoredFile(int articleNo, String storedName) {
		// 파일명이 비었으면 찾을 수가 없다.  || 는 "또는" 이라는 뜻이다.
		if (storedName == null || storedName.trim().isEmpty()) {
			// InvalidInputException 를 던져 여기서 중단한다. 위쪽 공통 처리기가 받아 알맞은 오류 화면을 보여준다
			throw new InvalidInputException("다운로드할 파일명이 없습니다");
		}
		// 경로 구분자가 섞여 오면 즉시 거부 (정상 저장명에는 있을 수 없다)
		// 저장명은 우리가 UUID 로 만든 것이라 / \ .. 가 들어갈 일이 없다.
		// 들어 있다면 누군가 일부러 경로를 조작하려는 것이므로 바로 403 으로 막는다.
		if (storedName.contains("/") || storedName.contains("\\") || storedName.contains("..")) {
			// ForbiddenException 를 던져 여기서 중단한다. 위쪽 공통 처리기가 받아 알맞은 오류 화면을 보여준다
			throw new ForbiddenException("잘못된 파일 경로 요청입니다 : " + storedName);
		}
		// "글번호 폴더 + 저장파일명" 을 가리키는 File 을 만든다 (아직 존재 확인 전이다)
		File target = new File(getArticleDir(articleNo), storedName);
		// getCanonicalPath() 는 파일 시스템을 실제로 확인하므로 IOException 이 날 수 있다
		try {
			// 저장 루트의 "정리된" 실제 경로
			String rootPath   = getRoot().getCanonicalPath();
			// 요청된 파일의 "정리된" 실제 경로
			String targetPath = target.getCanonicalPath();
			// getCanonicalPath()는 ..\ 를 실제 경로로 정리해준다.
			// 정리된 경로가 저장 루트로 시작하지 않으면 폴더를 벗어난 요청이다.
			// File.separator = 운영체제별 구분자(윈도우는 \). 루트 뒤에 구분자까지 붙여 비교해야
			// "C:\file_repo_edu2" 같은 비슷한 이름의 다른 폴더가 통과하는 것을 막을 수 있다.
			if (!targetPath.startsWith(rootPath + File.separator)) {
				// ForbiddenException 를 던져 여기서 중단한다. 위쪽 공통 처리기가 받아 알맞은 오류 화면을 보여준다
				throw new ForbiddenException("저장 폴더를 벗어난 파일 요청입니다");
			}
			// 경로는 안전한데 파일이 없거나, 파일이 아니라 폴더인 경우
			if (!target.exists() || !target.isFile()) {
				// 없는 것은 잘못된 요청(400)이 아니라 "찾을 수 없음(404)" 이다
				throw new NotFoundException("파일을 찾을 수 없습니다 : " + storedName);
			}
			// 두 검사를 모두 통과한 안전한 파일을 돌려준다
			return target;
		// 앞 구간에서 IOException 오류가 나면 여기로 온다
		} catch (IOException e) {
			// 디스크 문제 등으로 경로 확인 자체가 실패한 경우도 "못 찾음" 으로 처리한다
			throw new NotFoundException("파일 경로를 확인할 수 없습니다 : " + storedName);
		}
	}
}