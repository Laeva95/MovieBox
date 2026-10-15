package store;

import java.io.IOException; 
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/store/*")
public class StoreController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }

    private void process(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getPathInfo();

        System.out.println("[StoreController] 요청 주소: " + action);

        HttpSession session = request.getSession();

        try {



            // 매점 상품 목록 및 정렬
            if ("/Main.do".equals(action)
                    || "/StoreList.do".equals(action)) {

                StoreDAO dao = new StoreDAO();

                String category = request.getParameter("category");
                String sort = request.getParameter("sort");

                // 기본값 설정
                if (category == null || category.isEmpty()) {
                    category = "전체";
                }

                if (sort == null || sort.isEmpty()) {
                    sort = "recommend";
                }

                // 허용된 카테고리 확인
                if (!"전체".equals(category)
                        && !"콤보".equals(category)
                        && !"팝콘".equals(category)
                        && !"음료".equals(category)
                        && !"스낵".equals(category)
                        && !"캐릭터굿즈".equals(category)) {

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                // 허용된 정렬 기준 확인
                if (!"recommend".equals(sort)
                        && !"popular".equals(sort)
                        && !"low-price".equals(sort)
                        && !"high-price".equals(sort)) {

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                List<StoreDTO> storeList =
                        dao.getSortedStoreList(category, sort);
				
                request.setAttribute("storeList", storeList);
                request.setAttribute("selectedCategory", category);
                request.setAttribute("selectedSort", sort);
                request.setAttribute("center", "/stores/Main.jsp");

                request.getRequestDispatcher("/Index.jsp")
                       .forward(request, response);
                return;
            }



            // 2. 장바구니에 상품 추가
            else if ("/CartAdd.do".equals(action)) {

                int productId;

                try {
                    productId = Integer.parseInt(
                        request.getParameter("productId")
                    );

                    if (productId <= 0) {
                        response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST
                        );
                        return;
                    }

                } catch (NumberFormatException e) {
                    response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST
                    );
                    return;
                }

                // 세션에 저장된 장바구니 가져오기
                Map<Integer, Integer> cart =
                    (Map<Integer, Integer>) session.getAttribute("cart");

                // 장바구니가 없으면 새로 생성
                if (cart == null) {
                    cart = new HashMap<>();
                }

                // 이미 담긴 상품이면 수량 +1
                int quantity = cart.getOrDefault(productId, 0);
                cart.put(productId, quantity + 1);

                // 세션에 장바구니 저장
                session.setAttribute("cart", cart);

                System.out.println(
                    "장바구니 추가 - 상품 ID: " + productId
                    + ", 수량: " + cart.get(productId)
                );

                // 상품 목록으로 돌아가기
                response.sendRedirect(
                    request.getContextPath() + "/store/Cart.do"
                );

                return;
                

			} else if ("/CartRemove.do".equals(action)) {
			
			    // 삭제할 상품 ID 받기
			    int productId;
			

				try {
				    productId = Integer.parseInt(
				        request.getParameter("productId")
				    );
				
				    if (productId <= 0) {
				        response.sendError(
				            HttpServletResponse.SC_BAD_REQUEST
				        );
				        return;
				    }
				
				} catch (NumberFormatException e) {
				    response.sendError(
				        HttpServletResponse.SC_BAD_REQUEST
				    );
				    return;
				}
			
			    // 세션에서 장바구니 가져오기
			    Map<Integer, Integer> cart =
			            (Map<Integer, Integer>) session.getAttribute("cart");
			
			    // 해당 상품 삭제
			    if (cart != null) {
			        cart.remove(productId);
			        session.setAttribute("cart", cart);
			    }
			
			    // 삭제 후 장바구니 페이지로 이동
			    response.sendRedirect(
			            request.getContextPath() + "/store/Cart.do");
			    return;
    
                
            } else if ("/Cart.do".equals(action)) {

                // 세션에 저장된 장바구니 가져오기
                Map<Integer, Integer> cart =
                    (Map<Integer, Integer>) session.getAttribute("cart");

                List<Map<String, Object>> cartItems = new ArrayList<>();
                int cartTotal = 0;

                if (cart != null) {
                    StoreDAO dao = new StoreDAO();

                    for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {

                        int productId = entry.getKey();
                        int quantity = entry.getValue();

                        // 상품 ID로 DB에서 상품 정보 조회
                        StoreDTO product = dao.getStoreById(productId);

                        if (product != null) {
                            int subtotal = product.getPrice() * quantity;

                            Map<String, Object> item = new java.util.HashMap<>();
                            item.put("product", product);
                            item.put("quantity", quantity);
                            item.put("subtotal", subtotal);

                            cartItems.add(item);
                            cartTotal += subtotal;
                        }
                    }
                }

                request.setAttribute("cartItems", cartItems);
                request.setAttribute("cartTotal", cartTotal);

                request.setAttribute("center", "/stores/Cart.jsp");

                request.getRequestDispatcher("/Index.jsp")
                       .forward(request, response);

                return;
            }
            
	         // 결제 화면
            else if ("/Payment.do".equals(action)) {
	
	             // 로그인 확인
	             String memberId = (String) session.getAttribute("id");
	
	             if (memberId == null || memberId.isEmpty()) {
	                 response.sendRedirect(
	                     request.getContextPath() + "/member/Login.do"
	                 );
	                 return;
	             }
	
	             // 장바구니 확인
	             Map<Integer, Integer> cart =
	                 (Map<Integer, Integer>) session.getAttribute("cart");
	
	             if (cart == null || cart.isEmpty()) {
	                 response.sendRedirect(
	                     request.getContextPath() + "/store/Cart.do"
	                 );
	                 return;
	             }
	
	             // DAO 객체 생성
	             StoreDAO storeDAO = new StoreDAO();
	             
				 // 장바구니 상품 정보 조회
	             List<StoreDTO> products = storeDAO.getStoreList();
	
	             List<Map<String, Object>> cartItems = new ArrayList<>();
	             int cartTotal = 0;
	
	             for (StoreDTO product : products) {
	                 Integer quantity = cart.get(product.getId());
	
	                 if (quantity != null && quantity > 0) {
	                     int subtotal = product.getPrice() * quantity;
	
	                     Map<String, Object> item = new HashMap<>();
	                     item.put("product", product);
	                     item.put("quantity", quantity);
	                     item.put("subtotal", subtotal);
	
	                     cartItems.add(item);
	                     cartTotal += subtotal;
	                 }
	             }
	
	             request.setAttribute("cartItems", cartItems);
	             request.setAttribute("cartTotal", cartTotal);
	             request.setAttribute("center", "/stores/Payment.jsp");
	
	             request.getRequestDispatcher("/Index.jsp")
	                    .forward(request, response);
	
	             return;
	         }

			else if ("/Order.do".equals(action)) {
			
			    // 1. 로그인한 회원 ID 확인
			    String memberId = (String) session.getAttribute("id");
			
			    if (memberId == null || memberId.isEmpty()) {
			    	response.sendRedirect(request.getContextPath() + "/member/Login.do");
			        return;
			    }
			
			    // 2. 장바구니 확인
			    Map<Integer, Integer> cart =
			        (Map<Integer, Integer>) session.getAttribute("cart");
			
			    if (cart == null || cart.isEmpty()) {
			        response.sendRedirect(
			            request.getContextPath() + "/store/Cart.do"
			        );
			        return;
			    }
			
			    // 3. 주문 정보 DB 저장
			    StoreDAO dao = new StoreDAO();
			    int orderId = dao.createOrder(memberId, cart);
			
			    // 4. 주문 완료 화면에 전달할 정보
			    request.setAttribute("orderId", orderId);
			
			    // 5. 주문 성공 후 장바구니 비우기
			    session.removeAttribute("cart");
			
			    // 6. 주문 완료 페이지로 이동
			    request.setAttribute("center", "/stores/OrderComplete.jsp");
			
			    request.getRequestDispatcher("/Index.jsp")
			           .forward(request, response);
			
			    return;
			}

            // 3. 상품 상세
            else if ("/StoreDetail.do".equals(action)) {

                // 나중에 상세 기능 추가

            }

            // 4. 등록되지 않은 요청
            else {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND
                );
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();

            if (!response.isCommitted()) {
                response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                );
            }
        }
    }
}