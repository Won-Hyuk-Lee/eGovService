package kr.go.civilservice.complaint.mapper;

import java.util.List;
import java.util.Map;

import kr.go.civilservice.complaint.model.ComplaintFileVO;
import kr.go.civilservice.complaint.model.ComplaintHistoryVO;
import kr.go.civilservice.complaint.model.ComplaintVO;

public interface ComplaintMapper {
    // 민원 기본 CRUD
    List<ComplaintVO> selectComplaintList(Map<String, Object> params);
    ComplaintVO selectComplaintById(Long complaintId);
    int insertComplaint(ComplaintVO complaint);
    int updateComplaint(ComplaintVO complaint);
    int deleteComplaint(Long complaintId);

    // 첨부파일 관련
    int insertComplaintFile(ComplaintFileVO file);
    List<ComplaintFileVO> selectComplaintFiles(Long complaintId);
    ComplaintFileVO selectComplaintFileById(Long fileId);
    int deleteComplaintFile(Long fileId);

    // 민원 처리 관련
    int updateComplaintStatus(Map<String, Object> params);

    // 통계 관련
    List<Map<String, Object>> selectComplaintStatsByStatus();
    List<Map<String, Object>> selectComplaintStatsByMonth();

    // 처리이력 관련
    void insertComplaintHistory(Map<String, Object> params);
    List<ComplaintHistoryVO> selectComplaintHistories(Long complaintId);

    // 페이징 처리된 목록 조회 (회원별 필터링 포함)
    List<ComplaintVO> selectComplaintListWithPaging(Map<String, Object> params);
    
    // 전체 민원 수 조회 (회원별 필터링 포함)
    int getTotalComplaintCount(String memberId);
}