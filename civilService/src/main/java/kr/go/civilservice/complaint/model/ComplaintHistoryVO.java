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
	private String status;
	private String handlerId;
	private String processComment;
	private Date createdDate;

	// 추가 정보
	private String handlerName; // 처리자 이름
	private String statusName; // 상태 한글명
}