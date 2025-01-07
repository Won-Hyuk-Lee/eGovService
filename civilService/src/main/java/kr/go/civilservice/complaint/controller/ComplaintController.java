package kr.go.civilservice.complaint.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.go.civilservice.complaint.model.ComplaintVO;
import kr.go.civilservice.complaint.service.ComplaintService;
import kr.go.civilservice.member.model.MemberVO;

public class ComplaintController extends AbstractController {

	private ComplaintService complaintService;

	public void setComplaintService(ComplaintService complaintService) {
		this.complaintService = complaintService;
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
		} else if (requestURI.contains("/view/")) {
			handleDetail(request, mav);
		} else if (requestURI.contains("/delete/")) {
			handleDelete(request, mav);
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

		HttpSession session = request.getSession();
		MemberVO member = (MemberVO) session.getAttribute("member");

		ComplaintVO complaint = new ComplaintVO();
		complaint.setTitle(request.getParameter("title"));
		complaint.setContent(request.getParameter("content"));
		complaint.setPrivateInfoYn(request.getParameter("privateInfoYn"));
		complaint.setMemberId(member.getMemberId());

		List<MultipartFile> files = multipartRequest.getFiles("files");

		complaintService.registerComplaint(complaint, files);
		mav.setViewName("redirect:/complaint/list");
	}

	private void handleDetail(HttpServletRequest request, ModelAndView mav) {
        String uri = request.getRequestURI();

        try {
            // "/complaint/view/123" 형태의 URI에서 마지막 숫자만 추출
            String complaintIdStr = uri.substring(uri.lastIndexOf("/") + 1);
            
            // 빈 문자열이거나 숫자가 아닌 경우 목록으로 리다이렉트
            if (complaintIdStr == null || complaintIdStr.trim().isEmpty() || !complaintIdStr.matches("\\d+")) {
                mav.setViewName("redirect:/complaint/list");
                return;
            }

            Long complaintId = Long.parseLong(complaintIdStr);
            ComplaintVO complaint = complaintService.getComplaintById(complaintId);
            
            if (complaint != null) {
                mav.addObject("complaint", complaint);
                mav.setViewName("complaint/detail");
            } else {
                System.out.println("Complaint not found");
                mav.setViewName("redirect:/complaint/list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            mav.setViewName("redirect:/complaint/list");
        }
    }

	private void handleDelete(HttpServletRequest request, ModelAndView mav) {
		String uri = request.getRequestURI();
		Long complaintId = Long.parseLong(uri.substring(uri.lastIndexOf("/") + 1));

		try {
			HttpSession session = request.getSession();
			MemberVO member = (MemberVO) session.getAttribute("member");
			String memberRole = (String) session.getAttribute("memberRole");

			ComplaintVO complaint = complaintService.getComplaintById(complaintId);

			if (complaint != null
					&& (complaint.getMemberId().equals(member.getMemberId()) || "ADMIN".equals(memberRole))) {
				complaintService.deleteComplaint(complaintId);
				mav.setViewName("redirect:/complaint/list");
			} else {
				mav.setViewName("redirect:/access-denied");
			}
		} catch (Exception e) {
			mav.addObject("error", "민원 삭제 중 오류가 발생했습니다.");
			mav.setViewName("error/500");
		}
	}
}