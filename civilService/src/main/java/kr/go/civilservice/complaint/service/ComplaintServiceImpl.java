package kr.go.civilservice.complaint.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.PostConstruct;

import org.springframework.web.multipart.MultipartFile;

import kr.go.civilservice.complaint.mapper.ComplaintMapper;
import kr.go.civilservice.complaint.model.ComplaintFileVO;
import kr.go.civilservice.complaint.model.ComplaintHistoryVO;
import kr.go.civilservice.complaint.model.ComplaintVO;

public class ComplaintServiceImpl implements ComplaintService {

	private ComplaintMapper complaintMapper;
	private String uploadPath;

	public void setComplaintMapper(ComplaintMapper complaintMapper) {
		this.complaintMapper = complaintMapper;
	}

	public void setUploadPath(String uploadPath) {
		this.uploadPath = uploadPath;
	}

	@PostConstruct
	public void init() {
		try {
			Files.createDirectories(Paths.get(uploadPath));
		} catch (IOException e) {
			throw new RuntimeException("Could not create upload directory!", e);
		}
	}

	@Override
	public List<ComplaintVO> getComplaintList(Map<String, Object> params) {
		return complaintMapper.selectComplaintList(params);
	}

	@Override
	public ComplaintVO getComplaintById(Long complaintId) {
		ComplaintVO complaint = complaintMapper.selectComplaintById(complaintId);
		if (complaint != null) {
			complaint.setFiles(complaintMapper.selectComplaintFiles(complaintId));
		}
		return complaint;
	}

	@Override
	public void registerComplaint(ComplaintVO complaint, List<MultipartFile> files) {
		complaintMapper.insertComplaint(complaint);

		if (files != null && !files.isEmpty()) {
			processUploadFiles(complaint.getComplaintId(), files);
		}
	}

	@Override
	public void updateComplaint(ComplaintVO complaint, List<MultipartFile> files) {
		complaintMapper.updateComplaint(complaint);

		if (files != null && !files.isEmpty()) {
			processUploadFiles(complaint.getComplaintId(), files);
		}
	}

	@Override
	public void deleteComplaint(Long complaintId) {
		List<ComplaintFileVO> files = complaintMapper.selectComplaintFiles(complaintId);
		for (ComplaintFileVO file : files) {
			deleteComplaintFile(file.getFileId());
		}
		complaintMapper.deleteComplaint(complaintId);
	}

	@Override
	public ComplaintFileVO getComplaintFile(Long fileId) {
		return complaintMapper.selectComplaintFileById(fileId);
	}

	@Override
	public void deleteComplaintFile(Long fileId) {
		ComplaintFileVO file = complaintMapper.selectComplaintFileById(fileId);
		if (file != null) {
			File physicalFile = new File(uploadPath + File.separator + file.getStoredFilename());
			if (physicalFile.exists()) {
				physicalFile.delete();
			}
			complaintMapper.deleteComplaintFile(fileId);
		}
	}

	private void processUploadFiles(Long complaintId, List<MultipartFile> files) {
		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				try {
					String originalFilename = file.getOriginalFilename();
					String storedFilename = UUID.randomUUID().toString()
							+ originalFilename.substring(originalFilename.lastIndexOf("."));

					File dest = new File(uploadPath + File.separator + storedFilename);
					file.transferTo(dest);

					ComplaintFileVO fileVO = new ComplaintFileVO();
					fileVO.setComplaintId(complaintId);
					fileVO.setOriginalFilename(originalFilename);
					fileVO.setStoredFilename(storedFilename);
					fileVO.setFileSize(file.getSize());
					fileVO.setFileType(file.getContentType());

					complaintMapper.insertComplaintFile(fileVO);

				} catch (Exception e) {
					throw new RuntimeException("파일 업로드 실패", e);
				}
			}
		}
	}

	@Override
	public void updateComplaintStatus(Long complaintId, String status, String handlerId, String comment) {
		ComplaintVO complaint = complaintMapper.selectComplaintById(complaintId);
		if (complaint == null) {
			throw new RuntimeException("존재하지 않는 민원입니다.");
		}

		Map<String, Object> params = new HashMap<>();
		params.put("complaintId", complaintId);
		params.put("status", status);
		complaintMapper.updateComplaintStatus(params);

		params.put("handlerId", handlerId);
		params.put("processComment", comment);
		complaintMapper.insertComplaintHistory(params);
	}

	@Override
	public Map<String, Object> getComplaintStats() {
		Map<String, Object> stats = new HashMap<>();
		stats.put("statusStats", complaintMapper.selectComplaintStatsByStatus());
		stats.put("monthlyStats", complaintMapper.selectComplaintStatsByMonth());
		return stats;
	}

	@Override
	public List<ComplaintHistoryVO> getComplaintHistories(Long complaintId) {
		return complaintMapper.selectComplaintHistories(complaintId);
	}
}