package kr.go.civilservice.member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.go.civilservice.member.model.MemberVO;
import kr.go.civilservice.member.service.MemberService;

public class MemberController extends AbstractController {

	private MemberService memberService;

	public void setMemberService(MemberService memberService) {
		this.memberService = memberService;
	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String requestURI = request.getRequestURI();
		ModelAndView mav = new ModelAndView();

		if (requestURI.endsWith("/signup")) {
			if ("POST".equals(request.getMethod())) {
				handleSignup(request, mav);
			} else {
				mav.setViewName("member/signup");
			}
		} else if (requestURI.endsWith("/check-id")) {
			handleCheckId(request, mav);
		}

		return mav;
	}

	private void handleSignup(HttpServletRequest request, ModelAndView mav) {
		try {
			MemberVO memberVO = new MemberVO();
			memberVO.setMemberId(request.getParameter("memberId"));
			memberVO.setPassword(request.getParameter("password"));
			memberVO.setName(request.getParameter("name"));
			memberVO.setEmail(request.getParameter("email"));
			memberVO.setPhone(request.getParameter("phone"));
			memberVO.setAddress(request.getParameter("address"));

			memberService.registerMember(memberVO);
			mav.setViewName("redirect:/member/login");

		} catch (Exception e) {
			mav.addObject("error", e.getMessage());
			mav.setViewName("member/signup");
		}
	}

	private void handleCheckId(HttpServletRequest request, ModelAndView mav) throws Exception {
		String memberId = request.getParameter("memberId");
		boolean isDuplicate = memberService.isIdDuplicate(memberId);

		Map<String, Boolean> response = new HashMap<>();
		response.put("duplicate", isDuplicate);

		mav.addObject("resultMap", response);
		mav.setViewName("jsonView");
	}
}