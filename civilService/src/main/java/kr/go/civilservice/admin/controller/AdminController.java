package kr.go.civilservice.admin.controller;

import java.util.List;

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
			List<MemberVO> members = memberService.getMemberList(page, pageSize);
			int totalMembers = memberService.getTotalMemberCount();
			int totalPages = (int) Math.ceil((double) totalMembers / pageSize);

			mav.addObject("members", members);
			mav.addObject("currentPage", page);
			mav.addObject("totalPages", totalPages);
			mav.addObject("activeTab", "members");
			mav.setViewName("admin/admin");
		} else if (requestURI.endsWith("/admin/complaints")) {
			List<ComplaintVO> complaints = complaintService.getComplaintList(page, pageSize);
			int totalComplaints = complaintService.getTotalComplaintCount();
			int totalPages = (int) Math.ceil((double) totalComplaints / pageSize);

			mav.addObject("complaints", complaints);
			mav.addObject("currentPage", page);
			mav.addObject("totalPages", totalPages);
			mav.addObject("activeTab", "complaints");
			mav.setViewName("admin/admin");
		} else if (requestURI.contains("/admin/member/")) {
			String memberId = requestURI.substring(requestURI.lastIndexOf("/") + 1);
			MemberVO member = memberService.getMemberById(memberId);
			mav.addObject("member", member);
			mav.setViewName("admin/member-detail");
		}

		return mav;
	}
}