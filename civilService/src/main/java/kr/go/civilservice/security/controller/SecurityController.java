package kr.go.civilservice.security.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SecurityController {

    @GetMapping("/login")
    public ModelAndView login(
            @RequestParam(value = "error", required = false) String error,
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
}