package kr.go.civilservice.admin.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.go.civilservice.complaint.service.ComplaintService;

public class AdminController extends AbstractController {

	private ComplaintService complaintService;

	public void setComplaintService(ComplaintService complaintService) {
		this.complaintService = complaintService;
	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ModelAndView mav = new ModelAndView("admin/dashboard");
		Map<String, Object> stats = complaintService.getComplaintStats();
		mav.addObject("stats", stats);

		return mav;
	}
}