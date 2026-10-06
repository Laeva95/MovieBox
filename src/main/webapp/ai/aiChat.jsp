<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/aiChat.css">
<!-- ============================================================
     MovieBox AI 영화 추천 챗봇
     
     역할
     1. 메인 화면 오른쪽 아래에 AI 버튼 표시
     2. AI 버튼 클릭 → 채팅창 열기
     3. 사용자 질문을 AIRecommendationController로 전송
     4. AI 추천 결과를 채팅창에 표시
     ============================================================ -->


<!-- ============================================================
     AI 챗봇 HTML
     ============================================================ -->

<div id="movieBoxAI">

    <!-- --------------------------------------------------------
         오른쪽 아래에 항상 보이는 AI 버튼
         -------------------------------------------------------- -->

    <button type="button"
            id="aiOpenButton"
            onclick="openAIChat()">

        🤖

        <span class="aiButtonText">
            AI 영화 추천
        </span>

    </button>


    <!-- --------------------------------------------------------
         AI 채팅창
         처음에는 숨겨져 있음
         -------------------------------------------------------- -->

    <div id="aiChatWindow">


        <!-- ====================================================
             채팅창 상단
             ==================================================== -->

        <div class="aiChatHeader">

            <div class="aiChatTitle">

                <span class="aiRobot">
                    🤖
                </span>

                <div>

                    <div class="aiTitle">
                        MovieBox AI
                    </div>

                    <div class="aiSubTitle">
                        영화 추천 도우미
                    </div>

                </div>

            </div>


            <!-- 닫기 버튼 -->

            <button type="button"
                    class="aiCloseButton"
                    onclick="closeAIChat()">

                ×

            </button>

        </div>



        <!-- ====================================================
             채팅 내용
             ==================================================== -->

        <div id="aiChatMessages">


            <!-- AI 첫 인사 -->

            <div class="aiMessage">

                <div class="aiMessageIcon">
                    🤖
                </div>

                <div class="aiMessageBubble">

                    안녕하세요! 👋<br>

                    MovieBox AI입니다.<br><br>

                    어떤 영화를 찾고 계신가요?<br>

                    장르나 원하는 분위기를 알려주세요.

                </div>

            </div>


            <!-- ------------------------------------------------
                 빠른 질문 버튼
                 ------------------------------------------------ -->

            <div class="aiQuickButtons">

                <button type="button"
                        onclick="sendQuickQuestion('액션 영화 추천해줘')">
                    액션 영화
                </button>

                <button type="button"
                        onclick="sendQuickQuestion('로맨스 영화 추천해줘')">
                    로맨스 영화
                </button>

                <button type="button"
                        onclick="sendQuickQuestion('코미디 영화 추천해줘')">
                    코미디 영화
                </button>

                <button type="button"
                        onclick="sendQuickQuestion('긴장감 있는 영화 추천해줘')">
                    긴장감 있는 영화
                </button>

                <button type="button"
                        onclick="sendQuickQuestion('혼자 보기 좋은 영화 추천해줘')">
                    혼자 보기 좋은 영화
                </button>

            </div>

        </div>



        <!-- ====================================================
             입력 영역
             ==================================================== -->

        <div class="aiInputArea">

            <input type="text"
                   id="aiPrompt"
                   placeholder="원하는 영화나 분위기를 입력하세요."
                   autocomplete="off"
                   onkeydown="handleAIEnter(event)">


            <button type="button"
                    id="aiSendButton"
                    onclick="sendAIMessage()">

                ➤

            </button>

        </div>

    </div>

</div>




<!-- ============================================================
     AI 챗봇 JavaScript
     ============================================================ -->

<script>

    // ============================================================
    // AI 채팅창 열기
    // ============================================================

    function openAIChat() {

        const chatWindow =
            document.getElementById("aiChatWindow");

        chatWindow.classList.add("active");

        document
            .getElementById("aiPrompt")
            .focus();

    }



    // ============================================================
    // AI 채팅창 닫기
    // ============================================================

    function closeAIChat() {

        const chatWindow =
            document.getElementById("aiChatWindow");

        chatWindow.classList.remove("active");

    }



    // ============================================================
    // 빠른 질문 버튼
    // ============================================================

    function sendQuickQuestion(question) {

        const input =
            document.getElementById("aiPrompt");

        input.value = question;

        sendAIMessage();

    }



    // ============================================================
    // Enter 키로 전송
    // ============================================================

    function handleAIEnter(event) {

        if (event.key === "Enter") {

            event.preventDefault();

            sendAIMessage();

        }

    }



    // ============================================================
    // AI 메시지 전송
    // ============================================================

    function sendAIMessage() {

        const input =
            document.getElementById("aiPrompt");

        const sendButton =
            document.getElementById("aiSendButton");

        const message =
            input.value.trim();


        // --------------------------------------------------------
        // 입력값이 없는 경우
        // --------------------------------------------------------

        if (message === "") {

            return;

        }


        // --------------------------------------------------------
        // 사용자 메시지를 화면에 표시
        // --------------------------------------------------------

        addUserMessage(message);


        // 입력창 비우기

        input.value = "";


        // 버튼 잠금

        sendButton.disabled = true;


        // --------------------------------------------------------
        // AI 로딩 표시
        // --------------------------------------------------------

        const loadingId =
            addLoadingMessage();


        // --------------------------------------------------------
        // AIRecommendationController 호출
        //
        // 현재 Controller 주소:
        //
        // /ai/recommendation
        // --------------------------------------------------------

        fetch(
            "${pageContext.request.contextPath}/ai/recommendation",
            {

                method: "POST",

                headers: {

                    "Content-Type":
                        "application/x-www-form-urlencoded; charset=UTF-8"

                },

                body:
                    "prompt="
                    + encodeURIComponent(message)

            }
        )


        // --------------------------------------------------------
        // 서버 응답 받기
        // --------------------------------------------------------

        .then(function(response) {

            return response.text();

        })


        // --------------------------------------------------------
        // AI 결과 처리
        // --------------------------------------------------------

        .then(function(result) {

            removeLoadingMessage(loadingId);

            addAIMessage(result);

        })


        // --------------------------------------------------------
        // 오류 처리
        // --------------------------------------------------------

        .catch(function(error) {

            console.error(
                "AI 추천 오류:",
                error
            );


            removeLoadingMessage(loadingId);


            addAIMessage(
                "AI 추천을 가져오는 중 오류가 발생했습니다.\n"
                + "잠시 후 다시 시도해주세요."
            );

        })


        // --------------------------------------------------------
        // 마지막에 버튼 다시 활성화
        // --------------------------------------------------------

        .finally(function() {

            sendButton.disabled = false;

            input.focus();

        });

    }



    // ============================================================
    // 사용자 메시지 추가
    // ============================================================

    function addUserMessage(message) {

        const messages =
            document.getElementById("aiChatMessages");


        const messageDiv =
            document.createElement("div");


        messageDiv.className =
            "userMessage";


        const bubble =
            document.createElement("div");


        bubble.className =
            "userMessageBubble";


        bubble.textContent =
            message;


        messageDiv.appendChild(
            bubble
        );


        messages.appendChild(
            messageDiv
        );


        scrollAIChat();

    }



    // ============================================================
    // AI 메시지 추가
    // ============================================================

    function addAIMessage(message) {

        const messages =
            document.getElementById("aiChatMessages");


        const messageDiv =
            document.createElement("div");


        messageDiv.className =
            "aiMessage";


        const icon =
            document.createElement("div");


        icon.className =
            "aiMessageIcon";


        icon.textContent =
            "🤖";


        const bubble =
            document.createElement("div");


        bubble.className =
            "aiMessageBubble";


        bubble.textContent =
            message;


        messageDiv.appendChild(
            icon
        );


        messageDiv.appendChild(
            bubble
        );


        messages.appendChild(
            messageDiv
        );


        scrollAIChat();

    }



    // ============================================================
    // AI 로딩 메시지
    // ============================================================

    function addLoadingMessage() {

        const messages =
            document.getElementById("aiChatMessages");


        const loadingId =
            "aiLoading_"
            + Date.now();


        const loadingDiv =
            document.createElement("div");


        loadingDiv.id =
            loadingId;


        loadingDiv.className =
            "aiLoading";


        loadingDiv.innerHTML =

            '<div class="aiMessageIcon">🤖</div>'
            + '<div class="aiLoadingBubble">'
            + '영화를 찾고 있어요...'
            + '</div>';


        messages.appendChild(
            loadingDiv
        );


        scrollAIChat();


        return loadingId;

    }



    // ============================================================
    // AI 로딩 메시지 삭제
    // ============================================================

    function removeLoadingMessage(id) {

        const loading =
            document.getElementById(id);


        if (loading) {

            loading.remove();

        }

    }


    // ============================================================
    // 채팅창 가장 아래로 이동
    // ============================================================

    function scrollAIChat() {

        const messages =
            document.getElementById("aiChatMessages");


        messages.scrollTop =
            messages.scrollHeight;

    }

</script>