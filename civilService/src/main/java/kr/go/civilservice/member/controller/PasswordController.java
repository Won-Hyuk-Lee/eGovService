// PasswordController.java
package kr.go.civilservice.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.go.civilservice.security.model.MemberVO;
import kr.go.civilservice.security.service.MemberService;

public class PasswordController extends AbstractController {

	private MemberService memberService;

	public void setMemberService(MemberService memberService) {
		this.memberService = memberService;
	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String method = request.getMethod();
		ModelAndView mav = new ModelAndView();

		if ("GET".equals(method)) {
			mav.setViewName("member/change-password");
			return mav;
		}

		// POST 요청 처리
		HttpSession session = request.getSession();
		MemberVO member = (MemberVO) session.getAttribute("member");

		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		try {
			if (!newPassword.equals(confirmPassword)) {
				throw new IllegalArgumentException("새 비밀번호가 일치하지 않습니다.");
			}

			memberService.changePassword(member.getMemberId(), currentPassword, newPassword);
			mav.setViewName("redirect:/logout");

		} catch (Exception e) {
			mav.addObject("error", e.getMessage());
			mav.setViewName("member/change-password");
		}

		return mav;
	}
}