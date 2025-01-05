package kr.go.civilservice.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AuthInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		String requestURI = request.getRequestURI();

		// 관리자 영역 체크
		if (requestURI.startsWith("/admin/")) {
			if (!"ADMIN".equals(session.getAttribute("memberRole"))) {
				response.sendRedirect("/access-denied");
				return false;
			}
		}

		// 로그인이 필요한 영역 체크
		if (requestURI.startsWith("/complaint/create") || requestURI.startsWith("/complaint/my")) {
			if (session.getAttribute("member") == null) {
				response.sendRedirect("/login");
				return false;
			}
		}

		return true;
	}
}