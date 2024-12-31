package kr.go.civilservice.complaint.model;

import java.util.Date;
import lombok.Data;

@Data
public class ComplaintFileVO {
    private Long fileId;
    private Long complaintId;
    private String originalFilename;
    private String storedFilename;
    private Long fileSize;
    private String fileType;
    private Date createdDate;
}