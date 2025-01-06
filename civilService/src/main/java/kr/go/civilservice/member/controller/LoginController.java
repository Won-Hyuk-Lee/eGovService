package kr.go.civilservice.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.go.civilservice.member.model.MemberVO;
import kr.go.civilservice.member.service.MemberService;

public class LoginController extends AbstractController {

	private MemberService memberService;
	private static final int MAX_LOGIN_FAILS = 5;

	public void setMemberService(MemberService memberService) {
		this.memberService = memberService;
	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String method = request.getMethod();
		ModelAndView mav = new ModelAndView();

		if ("GET".equals(method)) {
			String error = request.getParameter("error");
			String expired = request.getParameter("expired");

			if (error != null) {
				mav.addObject("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
			}
			if (expired != null) {
				mav.addObject("expired", "세션이 만료되었습니다. 다시 로그인해주세요.");
			}

			mav.setViewName("member/login");
			return mav;
		}

		// POST 요청 처리 (로그인 처리)
		String memberId = request.getParameter("username");
		String password = request.getParameter("password");

		try {
			if (memberService == null) {
				throw new IllegalStateException("memberService가 주입되지 않았습니다.");
			}

			// 계정 잠금 여부 확인
			if (memberService.isAccountLocked(memberId)) {
				mav.addObject("error", "계정이 잠금되었습니다. 관리자에게 문의하세요.");
				mav.setViewName("member/login");
				return mav;
			}

			// 로그인 시도
			MemberVO member = memberService.login(memberId, password);

			if (member != null) {
				// 로그인 성공
				HttpSession session = request.getSession();
				session.setAttribute("member", member);
				session.setAttribute("memberRole", memberService.getMemberRole(memberId));

				// 로그인 실패 횟수 초기화
				memberService.resetLoginFailCount(memberId);

				response.sendRedirect(request.getContextPath() + "/");
				return null;
			} else {
				// 로그인 실패
				int failCount = memberService.increaseLoginFailCount(memberId);

				String errorMessage = "아이디 또는 비밀번호가 올바르지 않습니다.";
				if (failCount >= MAX_LOGIN_FAILS) {
					errorMessage = "로그인 실패 횟수 초과로 계정이 잠금되었습니다.";
				} else {
					errorMessage += " (실패 횟수: " + failCount + "/" + MAX_LOGIN_FAILS + ")";
				}

				mav.addObject("error", errorMessage);
				mav.setViewName("member/login");
			}

		} catch (Exception e) {
			e.printStackTrace();
			mav.addObject("error", "로그인 처리 중 오류가 발생했습니다.");
			mav.setViewName("member/login");
		}

		return mav;
	}
}