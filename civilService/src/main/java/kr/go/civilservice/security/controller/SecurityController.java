package kr.go.civilservice.security.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.go.civilservice.security.model.MemberVO;
import kr.go.civilservice.security.service.MemberService;

@Controller
public class SecurityController {

	@Autowired
	private MemberService memberService;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	@GetMapping("/login")
	public ModelAndView login(@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "expired", required = false) String expired) {

		ModelAndView mav = new ModelAndView("security/login");

		if (error != null) {
			mav.addObject("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
		}

		if (expired != null) {
			mav.addObject("expired", "세션이 만료되었습니다. 다시 로그인해주세요.");
		}

		return mav;
	}

	@GetMapping("/access-denied")
	public String accessDenied() {
		return "security/access-denied";
	}

	@GetMapping("/signup")
	public String signupForm() {
		return "security/signup";
	}

	@PostMapping("/signup")
	public String signup(@ModelAttribute MemberVO memberVO) {
		// 비밀번호 암호화
		memberVO.setPassword(passwordEncoder.encode(memberVO.getPassword()));

		// 회원가입 처리
		memberService.registerMember(memberVO);

		return "redirect:/login";
	}

	@GetMapping("/checkId")
	@ResponseBody
	public Map<String, Boolean> checkId(@RequestParam String memberId) {
		Map<String, Boolean> response = new HashMap<>();
		response.put("duplicate", memberService.isIdDuplicate(memberId));
		return response;
	}

}