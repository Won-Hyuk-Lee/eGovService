package kr.go.civilservice.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.go.civilservice.complaint.model.ComplaintVO;
import kr.go.civilservice.complaint.service.ComplaintService;
import kr.go.civilservice.member.model.MemberVO;
import kr.go.civilservice.member.service.MemberService;

public class AdminController extends AbstractController {

    private ComplaintService complaintService;
    private MemberService memberService;

    // Setter 메서드들
    public void setComplaintService(ComplaintService complaintService) {
        this.complaintService = complaintService;
    }

    public void setMemberService(MemberService memberService) {
        this.memberService = memberService;
    }

    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String requestURI = request.getRequestURI();
        ModelAndView mav = new ModelAndView();

        // 페이징 처리를 위한 파라미터
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = 10;

        if (requestURI.endsWith("/admin")) {
            mav.setViewName("redirect:/admin/members");
        } else if (requestURI.endsWith("/admin/members")) {
            // 회원 목록 조회
            List<MemberVO> members = memberService.getMemberList(page, pageSize);
            int totalMembers = memberService.getTotalMemberCount();
            int totalPages = (int) Math.ceil((double) totalMembers / pageSize);

            mav.addObject("members", members);
            mav.addObject("currentPage", page);
            mav.addObject("totalPages", totalPages);
            mav.addObject("activeTab", "members");
            mav.setViewName("admin/admin");
        } else if (requestURI.endsWith("/admin/complaints")) {
            // 민원 목록 조회 (회원별 필터링 포함)
            String memberId = request.getParameter("memberId");
            String memberName = "";
            
            // memberId가 있으면 해당 회원 정보 조회
            if (memberId != null && !memberId.isEmpty()) {
                MemberVO member = memberService.getMemberById(memberId);
                if (member != null) {
                    memberName = member.getName();
                }
            }
            
            Map<String, Object> params = new HashMap<>();
            params.put("start", (page - 1) * pageSize);
            params.put("size", pageSize);
            params.put("memberId", memberId);
            
            List<ComplaintVO> complaints = complaintService.getComplaintList(params);
            int totalComplaints = complaintService.getTotalComplaintCount(memberId);
            int totalPages = (int) Math.ceil((double) totalComplaints / pageSize);

            mav.addObject("complaints", complaints);
            mav.addObject("currentPage", page);
            mav.addObject("totalPages", totalPages);
            mav.addObject("activeTab", "complaints");
            if (!memberName.isEmpty()) {
                mav.addObject("filterMemberName", memberName);
            }
            mav.setViewName("admin/admin");
        } else if (requestURI.endsWith("/admin/member/status") && "POST".equals(request.getMethod())) {
            // 회원 상태 변경 처리
            String memberId = request.getParameter("memberId");
            String action = request.getParameter("action");
            
            if ("lock".equals(action)) {
                memberService.lockAccount(memberId);
            } else if ("unlock".equals(action)) {
                memberService.unlockAccount(memberId);
            }
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":true}");
            return null;
        } else if (requestURI.endsWith("/admin/member/reset-password") && "POST".equals(request.getMethod())) {
            // 비밀번호 초기화 처리
            String memberId = request.getParameter("memberId");
            String temporaryPassword = memberService.resetPassword(memberId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":true,\"temporaryPassword\":\"" + temporaryPassword + "\"}");
            return null;
        } else if (requestURI.endsWith("/admin/member/delete") && "POST".equals(request.getMethod())) {
            // 회원 삭제 처리
            String memberId = request.getParameter("memberId");
            memberService.deleteMember(memberId);
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":true}");
            return null;
        }

        return mav;
    }
}