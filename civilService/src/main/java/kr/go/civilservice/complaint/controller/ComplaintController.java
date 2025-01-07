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
        } else if (requestURI.contains("/edit/")) {
            if ("POST".equals(request.getMethod())) {
                handleEdit(request, mav);
            } else {
                handleEditForm(request, mav);
            }
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
        
        // privateInfoYn이 null이면 'N'으로 설정
        String privateInfoYn = request.getParameter("privateInfoYn");
        complaint.setPrivateInfoYn(privateInfoYn != null ? privateInfoYn : "N");
        
        // publicYn이 null이면 'Y'로 설정
        String publicYn = request.getParameter("publicYn");
        complaint.setPublicYn(publicYn != null ? publicYn : "Y");
        
        complaint.setMemberId(member.getMemberId());

        List<MultipartFile> files = multipartRequest.getFiles("files");

        complaintService.registerComplaint(complaint, files);
        mav.setViewName("redirect:/complaint/list");
    }

    private void handleDetail(HttpServletRequest request, ModelAndView mav) {
        try {
            String complaintIdStr = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
            if (complaintIdStr == null || complaintIdStr.trim().isEmpty() || !complaintIdStr.matches("\\d+")) {
                mav.setViewName("redirect:/complaint/list");
                return;
            }

            Long complaintId = Long.parseLong(complaintIdStr);
            ComplaintVO complaint = complaintService.getComplaintById(complaintId);
            
            if (complaint == null) {
                mav.setViewName("redirect:/complaint/list");
                return;
            }

            HttpSession session = request.getSession();
            MemberVO member = (MemberVO) session.getAttribute("member");

            // 비공개 글에 대한 접근 제어
            if ("N".equals(complaint.getPublicYn())) {
                if (member == null) {
                    // 비로그인 사용자
                    mav.setViewName("redirect:/member/login");
                    return;
                } else if (!complaint.getMemberId().equals(member.getMemberId()) && 
                          !"ADMIN".equals(session.getAttribute("memberRole"))) {
                    // 작성자나 관리자가 아닌 경우
                    mav.setViewName("redirect:/access-denied");
                    return;
                }
            } else if (member == null) {
                // 전체공개 글이지만 비로그인 사용자
                mav.addObject("loginRequired", true);
            }

            mav.addObject("complaint", complaint);
            mav.setViewName("complaint/detail");
            
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

    private void handleEditForm(HttpServletRequest request, ModelAndView mav) {
        try {
            String complaintIdStr = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
            Long complaintId = Long.parseLong(complaintIdStr);
            
            HttpSession session = request.getSession();
            MemberVO member = (MemberVO) session.getAttribute("member");
            String memberRole = (String) session.getAttribute("memberRole");

            ComplaintVO complaint = complaintService.getComplaintById(complaintId);
            
            if (complaint == null) {
                mav.setViewName("redirect:/complaint/list");
                return;
            }

            // 작성자나 관리자만 수정 가능
            if (!complaint.getMemberId().equals(member.getMemberId()) && !"ADMIN".equals(memberRole)) {
                mav.setViewName("redirect:/access-denied");
                return;
            }

            mav.addObject("complaint", complaint);
            mav.setViewName("complaint/edit");
            
        } catch (Exception e) {
            mav.setViewName("redirect:/complaint/list");
        }
    }

    private void handleEdit(HttpServletRequest request, ModelAndView mav) throws Exception {
        try {
            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
            HttpSession session = request.getSession();
            MemberVO member = (MemberVO) session.getAttribute("member");
            String memberRole = (String) session.getAttribute("memberRole");

            String complaintIdStr = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
            Long complaintId = Long.parseLong(complaintIdStr);
            
            ComplaintVO originalComplaint = complaintService.getComplaintById(complaintId);
            
            if (originalComplaint == null) {
                mav.setViewName("redirect:/complaint/list");
                return;
            }

            // 작성자나 관리자만 수정 가능
            if (!originalComplaint.getMemberId().equals(member.getMemberId()) && !"ADMIN".equals(memberRole)) {
                mav.setViewName("redirect:/access-denied");
                return;
            }

            ComplaintVO complaint = new ComplaintVO();
            complaint.setComplaintId(complaintId);
            complaint.setTitle(request.getParameter("title"));
            complaint.setContent(request.getParameter("content"));
            complaint.setPublicYn(request.getParameter("publicYn"));
            complaint.setPrivateInfoYn(request.getParameter("privateInfoYn"));
            complaint.setMemberId(originalComplaint.getMemberId());

            List<MultipartFile> files = multipartRequest.getFiles("files");

            complaintService.updateComplaint(complaint, files);
            mav.setViewName("redirect:/complaint/view/" + complaintId);
            
        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("error", "민원 수정 중 오류가 발생했습니다.");
            mav.setViewName("error/500");
        }
    }
}