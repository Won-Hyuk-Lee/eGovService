package kr.go.civilservice.complaint.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.go.civilservice.complaint.model.ComplaintFileVO;
import kr.go.civilservice.complaint.model.ComplaintHistoryVO;
import kr.go.civilservice.complaint.model.ComplaintVO;

public interface ComplaintService {
    // 기본 CRUD 관련 메소드
    List<ComplaintVO> getComplaintList(Map<String, Object> params);
    ComplaintVO getComplaintById(Long complaintId);
    void registerComplaint(ComplaintVO complaint, List<MultipartFile> files);
    void updateComplaint(ComplaintVO complaint, List<MultipartFile> files);
    void deleteComplaint(Long complaintId);

    // 첨부파일 관련 메소드
    ComplaintFileVO getComplaintFile(Long fileId);
    void deleteComplaintFile(Long fileId);

    // 민원 처리 관련 메소드
    void updateComplaintStatus(Long complaintId, String status, String handlerId, 
                             String comment, String requestFiles,
                             Date requestDeadline, String resultContent);

    // 통계 관련 메소드
    Map<String, Object> getComplaintStats();

    // 처리이력 관련 메소드
    List<ComplaintHistoryVO> getComplaintHistories(Long complaintId);

    // 페이징 처리 관련 메소드
    List<ComplaintVO> getComplaintList(int page, int pageSize);
    int getTotalComplaintCount();

    // 회원별 민원 필터링 메소드
    int getTotalComplaintCount(String memberId);
}