package kr.go.civilservice.complaint.model;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ComplaintHistoryVO {
	private Long historyId;
    private Long complaintId;
    private String status;        // PENDING(접수대기), PROCESSING(처리중), COMPLETED(처리완료), REJECTED(반려)
    private String handlerId;     // 처리자 ID
    private String processComment; // 처리 코멘트
    private String requestFiles;  // 추가 요청 서류 목록 (콤마로 구분)
    private Date requestDeadline; // 서류 제출 기한
    private String resultContent; // 처리 결과 내용
    private Date createdDate;    // 처리 일시
    
    // 추가 정보
    private String handlerName;   // 처리자 이름
    private String statusName;    // 상태 한글명
}