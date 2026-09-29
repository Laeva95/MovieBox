<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <style>
  	@charset "UTF-8";

/* ========================================
   회원가입 페이지
   ======================================== */

.join-page {
    min-height: 100vh;
    padding: 150px 0 100px;
}

.join-container {
    width: 100%;
    max-width: 720px;
    margin: 0 auto;
    padding: 0 24px;
}


/* ========================================
   페이지 제목
   ======================================== */

.join-header {
    text-align: center;
    margin-bottom: 36px;
}

.join-header h1 {
    margin-bottom: 10px;
    color: var(--text-white);
    font-size: 36px;
    font-weight: 800;
    letter-spacing: -1px;
}

.join-header p {
    color: var(--text-muted);
    font-size: 15px;
}


/* ========================================
   회원가입 카드
   ======================================== */

.join-card {
    padding: 40px;
    background-color: var(--bg-surface-card);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.35);
}


/* ========================================
   입력 영역
   ======================================== */

.form-section {
    margin-bottom: 32px;
}

.form-section:last-child {
    margin-bottom: 0;
}

.section-label {
    padding-bottom: 14px;
    margin-bottom: 20px;

    color: var(--text-white);
    border-bottom: 1px solid var(--border-color);

    font-size: 18px;
    font-weight: 700;
}


.form-group {
    margin-bottom: 20px;
}

.form-group:last-child {
    margin-bottom: 0;
}


.form-label {
    display: block;
    margin-bottom: 8px;

    color: var(--text-on-surface);
    font-size: 14px;
    font-weight: 600;
}

.required {
    margin-left: 3px;
    color: var(--primary-red);
}


/* ========================================
   input / select
   ======================================== */

.form-input,
.form-select {
    width: 100%;
    height: 48px;

    padding: 0 14px;

    color: var(--text-white);
    background-color: var(--bg-surface-low);

    border: 1px solid var(--border-color);
    border-radius: 8px;

    font-family: inherit;
    font-size: 14px;

    outline: none;

    transition: 0.2s ease-in-out;
}


.form-input::placeholder {
    color: #64748b;
}


.form-input:focus,
.form-select:focus {
    border-color: var(--primary-red);

    box-shadow:
        0 0 0 3px rgba(229, 9, 20, 0.12);
}


.form-select {
    cursor: pointer;
}

.form-select option {
    color: var(--text-white);
    background-color: var(--bg-surface-card);
}


/* ========================================
   아이디 중복확인
   ======================================== */

.input-with-button {
    display: flex;
    gap: 10px;
}

.input-with-button .form-input {
    flex: 1;
}

.btn-check {
    width: 110px;
    flex-shrink: 0;

    color: var(--text-white);
    background-color: var(--bg-surface-high);

    border: 1px solid var(--border-color);
    border-radius: 8px;

    font-size: 13px;
    font-weight: 600;

    cursor: pointer;
    transition: 0.2s ease-in-out;
}

.btn-check:hover {
    background-color: #38393f;
}


/* ========================================
   2열 입력
   ======================================== */

.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}


/* ========================================
   도움말
   ======================================== */

.form-help {
    margin-top: 7px;

    color: var(--text-muted);
    font-size: 12px;
}


/* ========================================
   약관
   ======================================== */

.terms-box {
    padding: 18px;

    background-color: var(--bg-surface-low);

    border: 1px solid var(--border-color);
    border-radius: 10px;
}

.terms-label {
    display: flex;
    align-items: center;
    gap: 10px;

    color: var(--text-on-surface);
    font-size: 14px;

    cursor: pointer;
}

.terms-label input {
    width: 17px;
    height: 17px;

    accent-color: var(--primary-red);

    cursor: pointer;
}


/* ========================================
   버튼
   ======================================== */

.join-buttons {
    display: flex;
    gap: 12px;

    margin-top: 36px;
}


.btn-join,
.btn-cancel {
    height: 52px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 9999px;

    font-size: 16px;
    font-weight: 700;

    cursor: pointer;

    transition: 0.2s ease-in-out;
}


.btn-join {
    flex: 1;

    color: var(--text-white);
    background-color: var(--primary-red);

    box-shadow:
        0 8px 24px rgba(229, 9, 20, 0.3);
}

.btn-join:hover {
    background-color: var(--primary-hover);

    transform: translateY(-1px);
}


.btn-cancel {
    width: 140px;

    color: var(--text-white);
    background-color: var(--bg-surface-high);
}

.btn-cancel:hover {
    background-color: #38393f;
}


/* ========================================
   반응형
   ======================================== */

@media (max-width: 768px) {

    .join-page {
        padding-top: 130px;
    }

    .join-card {
        padding: 28px 20px;
    }

    .join-header h1 {
        font-size: 30px;
    }

    .form-row {
        grid-template-columns: 1fr;
        gap: 20px;
    }

    .join-buttons {
        flex-direction: column;
    }

    .btn-cancel {
        width: 100%;
        order: 2;
    }

}
/* =========================
   회원가입 약관 영역
   ========================= */

	.terms-box {
	    width: 100%;
	    box-sizing: border-box;
	}
	
	.terms-content {
	    margin-bottom: 20px;
	    padding: 18px;
	    border: 1px solid #ddd;
	    border-radius: 6px;
	    background-color: #fafafa;
	}
	
	.terms-title {
	    margin: 0 0 12px;
	    font-size: 16px;
	    font-weight: 600;
	    color: #333;
	}
	
	.terms-text {
	    height: 130px;
	    padding: 14px;
	    box-sizing: border-box;
	
	    overflow-y: auto;
	
	    border: 1px solid #e2e2e2;
	    background-color: #fff;
	
	    font-size: 13px;
	    line-height: 1.7;
	    color: #666;
	}
	
	.terms-text p {
	    margin: 0 0 12px;
	}
	
	.terms-text p:last-child {
	    margin-bottom: 0;
	}
	
	.terms-label {
	    display: flex;
	    align-items: center;
	    gap: 8px;
	
	    margin-top: 18px;
	
	    font-size: 14px;
	    color: #333;
	    cursor: pointer;
	}
	
	.terms-label input[type="checkbox"] {
	    width: 16px;
	    height: 16px;
	    margin: 0;
	
	    cursor: pointer;
	}
	
	.terms-label span {
	    line-height: 1.5;
	    color: #fff;
	}
 </style>
<script>
function idCheck() {

    // 입력한 아이디 가져오기
    const memberId = document.getElementById("memberId").value.trim();

    // 아이디를 입력하지 않은 경우
    if (memberId === "") {
        alert("아이디를 입력해주세요.");
        return;
    }

    // Servlet으로 비동기 요청
    fetch("${pageContext.request.contextPath}/member/IdCheck.do?member_id=" + encodeURIComponent(memberId))
        .then(response => response.json())
        .then(data => {

            const idCheckText = document.getElementById("joinIdCheckText");

            if (data.duplicate) {
                // 중복된 아이디
                idCheckText.textContent = "이미 사용 중인 아이디입니다.";
                idCheckText.style.color = "red";
            } else {
                // 사용 가능한 아이디
                idCheckText.textContent = "사용 가능한 아이디입니다.";
                idCheckText.style.color = "green";
            }

        })
        .catch(error => {
            console.error("아이디 중복 확인 오류:", error);
            alert("아이디 중복 확인 중 오류가 발생했습니다.");
        });
}
</script>
<main class="join-page">
    <div class="join-container">
        <!-- 제목 -->
        <div class="join-header">
            <h1>회원가입</h1>
            <p>MovieBox의 다양한 서비스를 이용해보세요.</p>
        </div>
        <!-- 회원가입 카드 -->
        <div class="join-card">
        <form method="post" action="${pageContext.request.contextPath}/member/JoinPro.do">
            <!-- 기본 정보 -->
            <section class="form-section">
                <h2 class="section-label">기본 정보</h2>
                <!-- 아이디 -->
                <div class="form-group">
                    <label class="form-label" for="memberId">
                        아이디<span class="required">*</span>
                    </label>
                    <div class="input-with-button">
                        <input
                            type="text"
                            id="memberId"
                            name="member_id"
                            class="form-input"
                            placeholder="아이디를 입력해주세요"
                            maxlength="12"
                            required
                        >
                        <button type="button" class="btn-check" onclick="idCheck();">
                            중복 확인
                        </button>

                    </div>

                    <p class="form-help" id="joinIdCheckText">
                        영문, 숫자를 포함하여 4~12자로 입력해주세요.
                    </p>

                </div>


                <!-- 비밀번호 -->
                <div class="form-group">

                    <label class="form-label" for="memberPass">
                        비밀번호<span class="required">*</span>
                    </label>

                    <input
                        type="password"
                        id="memberPass"
                        name="member_pass"
                        class="form-input"
                        placeholder="비밀번호를 입력해주세요"
                        maxlength="20"
                        required
                    >
              		<p class="form-help">
                        영문, 숫자를 포함하여 8~20자로 입력해주세요.
                    </p>
                </div>
  


                <!-- 비밀번호 확인 -->
                <div class="form-group">

                    <label class="form-label" for="memberPassConfirm">
                        비밀번호 확인<span class="required">*</span>
                    </label>

                    <input
                        type="password"
                        id="memberPassConfirm"
                        name="member_pass_confirm"
                        class="form-input"
                        placeholder="비밀번호를 다시 입력해주세요"
                        maxlength="20"
                        required
                    >
                    <p class="form-help">
                        비밀번호와 동일한 값을 입력해주세요
                    </p>

                </div>


                <!-- 이름 -->
                <div class="form-group">

                    <label class="form-label" for="memberName">
                        이름<span class="required">*</span>
                    </label>

                    <input
                        type="text"
                        id="memberName"
                        name="member_name"
                        class="form-input"
                        placeholder="이름을 입력해주세요"
                        maxlength="20"
                        required
                    >

                </div>

            </section>


            <!-- 개인 정보 -->
            <section class="form-section">

                <h2 class="section-label">개인 정보</h2>

                <div class="form-row">

                    <!-- 나이 -->
                    <div class="form-group">

                        <label class="form-label" for="age">
                            나이<span class="required">*</span>
                        </label>

                        <input
                            type="number"
                            id="age"
                            name="age"
                            class="form-input"
                            placeholder="나이를 입력해주세요"
                            min="1"
                            max="150"
                            required
                        >

                    </div>


                    <!-- 성별 -->
                    <div class="form-group">

                        <label class="form-label" for="gender">
                            성별<span class="required">*</span>
                        </label>

                        <select
                            id="gender"
                            name="gender"
                            class="form-select"
                            required
                        >
                            <option value="">선택해주세요</option>
                            <option value="남">남성</option>
                            <option value="여">여성</option>
                        </select>

                    </div>

                </div>


                <!-- 이메일 -->
                <div class="form-group">

                    <label class="form-label" for="email">
                        이메일<span class="required">*</span>
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-input"
                        placeholder="example@email.com"
                        maxlength="100"
                        required
                    >

                </div>


                <!-- 주소 -->
                <div class="form-group">

                    <label class="form-label" for="address">
                        주소<span class="required">*</span>
                    </label>

                    <input
                        type="text"
                        id="address"
                        name="address"
                        class="form-input"
                        placeholder="주소를 입력해주세요"
                        maxlength="500"
                        required
                    >
                </div>
            </section>
            <!-- 연락처 -->
            <section class="form-section">
                <h2 class="section-label">연락처</h2>
                <div class="form-row">
                    <!-- 전화번호 -->
                    <div class="form-group">

                        <label class="form-label" for="tel">
                            전화번호<span class="required">*</span>
                        </label>
                        <input
                            type="tel"
                            id="tel"
                            name="tel"
                            class="form-input"
                            placeholder="0212345678"
                            maxlength="20"
                            required
                        >
                        <p class="form-help">
                        하이픈(-)기호 없이 숫자만 입력해주세요
                    </p>
                    </div>
                    <!-- 휴대폰 -->
                    <div class="form-group">
                        <label class="form-label" for="mtel">
                            휴대폰 번호<span class="required">*</span>
                        </label>
                        <input
                            type="tel"
                            id="mtel"
                            name="mtel"
                            class="form-input"
                            placeholder="01012345678"
                            maxlength="20"
                            required
                        >
                        <p class="form-help">
                        하이픈(-)기호 없이 숫자만 입력해주세요
                    </p>
                    </div>
                </div>
            </section>
            <!-- 약관 -->
<section class="form-section">
    <h2 class="section-label">약관 동의</h2>

    <div class="terms-box">

        <!-- 이용약관 -->
        <div class="terms-content">
            <h3 class="terms-title">MovieBox 이용약관</h3>

            <div class="terms-text">
                <p>
                    제1조 (목적)<br>
                    본 약관은 MovieBox에서 제공하는 영화 관련 서비스의 이용 조건 및
                    절차에 관한 사항을 규정하는 것을 목적으로 합니다.
                </p>

                <p>
                    제2조 (서비스 이용)<br>
                    회원은 MovieBox에서 제공하는 영화 정보, 영화 예매, 리뷰 등의
                    서비스를 이용할 수 있습니다.
                </p>

                <p>
                    제3조 (회원의 의무)<br>
                    회원은 서비스를 이용하는 과정에서 다른 회원에게 불쾌감을 주는
                    행위를 하거나 타인의 정보를 무단으로 이용해서는 안 됩니다.
                </p>

                <p>
                    제4조 (서비스 이용 제한)<br>
                    서비스 운영에 중대한 지장을 주는 행위가 확인될 경우 서비스 이용이
                    제한될 수 있습니다.
                </p>
            </div>
        </div>

        <!-- 개인정보 처리방침 -->
        <div class="terms-content">
            <h3 class="terms-title">개인정보 처리방침</h3>

            <div class="terms-text">
                <p>
                    MovieBox는 회원가입 및 서비스 이용을 위해 필요한 최소한의
                    개인정보를 수집합니다.
                </p>

                <p>
                    수집하는 개인정보에는 아이디, 비밀번호, 이름, 이메일,
                    전화번호 및 주소 등이 포함될 수 있습니다.
                </p>

                <p>
                    수집된 개인정보는 회원 관리 및 영화 예매 등의 서비스 제공을
                    위한 목적으로 사용됩니다.
                </p>

                <p>
                    회원의 개인정보는 관련 법령에 따라 안전하게 관리되며,
                    이용 목적이 달성된 후 관련 규정에 따라 처리됩니다.
                </p>
            </div>
        </div>

        <!-- 약관 동의 -->
        <label class="terms-label">
            <input
                type="checkbox"
                id="agree"
                name="agree"
                required
            >
            <span>
                MovieBox 이용약관 및 개인정보 처리방침에 동의합니다.
            </span>
        </label>

    </div>
</section>
            <!-- 버튼 -->
            <div class="join-buttons">
                <button
                    type="reset"
                    class="btn-cancel"
                >
                    재입력
                </button>
                <button type="submit" class="btn-join">
                    회원가입
                </button>
            </div>
            </form>
        </div>
    </div>
</main>
