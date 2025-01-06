package kr.go.civilservice.member.controller;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.go.civilservice.member.model.MemberVO;
import kr.go.civilservice.member.service.MemberService;

public class MemberController extends AbstractController {
	private static final Logger logger = Logger.getLogger(MemberController.class.getName());
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
				handleSignup(request, response, mav);
				if (mav == null) { // redirect가 발생한 경우
					return null;
				}
			} else {
				mav.setViewName("member/signup");
			}
		} else if (requestURI.endsWith("/check-id")) {
			handleCheckId(request, response);
			return null;
		}

		return mav;
	}

	private void handleSignup(HttpServletRequest request, HttpServletResponse response, ModelAndView mav)
			throws IOException {
		try {
			if (memberService == null) {
				throw new IllegalStateException("memberService가 주입되지 않았습니다.");
			}

			MemberVO memberVO = new MemberVO();
			memberVO.setMemberId(request.getParameter("memberId"));
			memberVO.setPassword(request.getParameter("password"));
			memberVO.setName(request.getParameter("name"));
			memberVO.setEmail(request.getParameter("email"));
			memberVO.setPhone(request.getParameter("phone"));
			memberVO.setAddress(request.getParameter("address"));

			logger.info("회원가입 시도: " + memberVO.getMemberId());
			memberService.registerMember(memberVO);
			logger.info("회원가입 성공: " + memberVO.getMemberId());

			response.sendRedirect(request.getContextPath() + "/member/login");
			mav = null;
		} catch (Exception e) {
			logger.severe("회원가입 실패: " + e.getMessage());
			e.printStackTrace();
			mav.addObject("error", e.getMessage());
			mav.setViewName("member/signup");
		}
	}

	private void handleCheckId(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String memberId = request.getParameter("memberId");
		boolean isDuplicate = memberService.isIdDuplicate(memberId);

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write("{\"duplicate\": " + isDuplicate + "}");
	}
}