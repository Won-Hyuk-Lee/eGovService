package kr.go.civilservice.complaint.model;

import java.util.Date;
import java.util.List;

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
public class ComplaintVO {
	private Long complaintId;
	private String title;
	private String content;
	private String memberId;
	private String status; // PENDING, PROCESSING, COMPLETED, REJECTED
	private Date createdDate;
	private Date modifiedDate;
	private Date completedDate;
	private String privateInfoYn;

	// 추가 필드
	private String memberName; // 작성자 이름
	private String statusName; // 상태 한글명
	private List<ComplaintFileVO> files; // 첨부파일 목록
}