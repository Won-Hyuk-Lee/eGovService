package kr.go.civilservice.complaint.controller;

import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.go.civilservice.complaint.model.ComplaintFileVO;
import kr.go.civilservice.complaint.model.ComplaintHistoryVO;
import kr.go.civilservice.complaint.model.ComplaintVO;
import kr.go.civilservice.complaint.service.ComplaintService;
import kr.go.civilservice.security.model.CustomUserDetail;

@Controller
@RequestMapping("/complaint")
public class ComplaintController {

	@Autowired
	private ComplaintService complaintService;

	@Value("${file.upload.path}")
	private String uploadPath;

	@GetMapping("/list")
	public String list(@RequestParam(required = false) String searchType,
			@RequestParam(required = false) String searchKeyword, @RequestParam(required = false) String status,
			Model model) {

		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("status", status);

		List<ComplaintVO> complaints = complaintService.getComplaintList(params);
		model.addAttribute("complaints", complaints);

		return "complaint/list";
	}

	@GetMapping("/create")
	public String createForm() {
		return "complaint/create";
	}

	@PostMapping("/create")
	public String create(@ModelAttribute ComplaintVO complaint, @RequestParam("files") List<MultipartFile> files,
			@AuthenticationPrincipal CustomUserDetail userDetail) {

		complaint.setMemberId(userDetail.getUsername());
		complaintService.registerComplaint(complaint, files);

		return "redirect:/complaint/list";
	}

	@GetMapping("/{complaintId}")
	public String detail(@PathVariable Long complaintId, Model model) {
		ComplaintVO complaint = complaintService.getComplaintById(complaintId);
		List<ComplaintHistoryVO> histories = complaintService.getComplaintHistories(complaintId);

		model.addAttribute("complaint", complaint);
		model.addAttribute("histories", histories);

		return "complaint/detail";
	}

	@PostMapping("/{complaintId}/status")
	@ResponseBody
	public Map<String, Object> updateStatus(@PathVariable Long complaintId, @RequestParam String status,
			@RequestParam String comment, @AuthenticationPrincipal CustomUserDetail userDetail) {

		complaintService.updateComplaintStatus(complaintId, status, userDetail.getUsername(), comment);

		Map<String, Object> response = new HashMap<>();
		response.put("success", true);
		return response;
	}

	@GetMapping("/file/{fileId}")
	public ResponseEntity<Resource> downloadFile(@PathVariable Long fileId) throws Exception {
		ComplaintFileVO fileInfo = complaintService.getComplaintFile(fileId);
		if (fileInfo == null) {
			return ResponseEntity.notFound().build();
		}

		Path filePath = Paths.get(uploadPath).resolve(fileInfo.getStoredFilename());
		Resource resource = new UrlResource(filePath.toUri());

		if (!resource.exists()) {
			return ResponseEntity.notFound().build();
		}

		String encodedFileName = URLEncoder.encode(fileInfo.getOriginalFilename(), "UTF-8").replaceAll("\\+", "%20");

		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
				.header(HttpHeaders.CONTENT_LENGTH, String.valueOf(resource.contentLength()))
				.header(HttpHeaders.CONTENT_TYPE, "application/octet-stream").body(resource);
	}

	@DeleteMapping("/{complaintId}")
	@ResponseBody
	public ResponseEntity<Map<String, Boolean>> delete(@PathVariable Long complaintId) {
		try {
			complaintService.deleteComplaint(complaintId);
			Map<String, Boolean> response = new HashMap<>(); // 수정된 부분
			response.put("success", true); // 수정된 부분
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			Map<String, Boolean> response = new HashMap<>(); // 수정된 부분
			response.put("success", false); // 수정된 부분
			return ResponseEntity.badRequest().body(response);
		}
	}
}