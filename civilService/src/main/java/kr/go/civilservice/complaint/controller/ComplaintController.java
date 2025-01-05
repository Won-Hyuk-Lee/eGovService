package kr.go.civilservice.complaint.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.go.civilservice.complaint.model.ComplaintVO;
import kr.go.civilservice.complaint.service.ComplaintService;

public class ComplaintController extends AbstractController {

	private ComplaintService complaintService;
	private String uploadPath;

	public void setComplaintService(ComplaintService complaintService) {
		this.complaintService = complaintService;
	}

	public void setUploadPath(String uploadPath) {
		this.uploadPath = uploadPath;
	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String requestURI = request.getRequestURI();
		ModelAndView mav = new ModelAndView();

		if (requestURI.endsWith("/list")) {
			handleList(request, mav);
		} else if (requestURI.endsWith("/create")) {
			if ("POST".equals(request.getMethod())) {
				handleCreate(request, mav);
			} else {
				mav.setViewName("complaint/create");
			}
		} else if (requestURI.matches(".*/\\d+$")) {
			handleDetail(request, mav);
		}

		return mav;
	}

	private void handleList(HttpServletRequest request, ModelAndView mav) {
		String searchType = request.getParameter("searchType");
		String searchKeyword = request.getParameter("searchKeyword");
		String status = request.getParameter("status");

		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("status", status);

		List<ComplaintVO> complaints = complaintService.getComplaintList(params);
		mav.addObject("complaints", complaints);
		mav.setViewName("complaint/list");
	}

	private void handleCreate(HttpServletRequest request, ModelAndView mav) throws Exception {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;

		ComplaintVO complaint = new ComplaintVO();
		complaint.setTitle(request.getParameter("title"));
		complaint.setContent(request.getParameter("content"));
		complaint.setPrivateInfoYn(request.getParameter("privateInfoYn"));

		List<MultipartFile> files = multipartRequest.getFiles("files");

		complaintService.registerComplaint(complaint, files);
		mav.setViewName("redirect:/complaint/list");
	}

	private void handleDetail(HttpServletRequest request, ModelAndView mav) {
		String uri = request.getRequestURI();
		Long complaintId = Long.parseLong(uri.substring(uri.lastIndexOf("/") + 1));

		ComplaintVO complaint = complaintService.getComplaintById(complaintId);
		mav.addObject("complaint", complaint);
		mav.setViewName("complaint/detail");
	}
}