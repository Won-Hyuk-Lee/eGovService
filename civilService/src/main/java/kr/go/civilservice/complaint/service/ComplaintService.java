package kr.go.civilservice.complaint.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.go.civilservice.complaint.model.ComplaintFileVO;
import kr.go.civilservice.complaint.model.ComplaintHistoryVO;
import kr.go.civilservice.complaint.model.ComplaintVO;

public interface ComplaintService {
	// 민원 CRUD
	List<ComplaintVO> getComplaintList(Map<String, Object> params);

	ComplaintVO getComplaintById(Long complaintId);

	void registerComplaint(ComplaintVO complaint, List<MultipartFile> files);

	void updateComplaint(ComplaintVO complaint, List<MultipartFile> files);

	void deleteComplaint(Long complaintId);

	// 파일 관련
	ComplaintFileVO getComplaintFile(Long fileId);

	void deleteComplaintFile(Long fileId);

	// 민원 처리
	void updateComplaintStatus(Long complaintId, String status, String handlerId, String comment);

	// 통계
	Map<String, Object> getComplaintStats();
	
	List<ComplaintHistoryVO> getComplaintHistories(Long complaintId);
}