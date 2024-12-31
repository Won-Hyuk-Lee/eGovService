package kr.go.civilservice.admin.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.go.civilservice.complaint.service.ComplaintService;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private ComplaintService complaintService;

	@GetMapping("/dashboard")
	public String dashboard(Model model) {
		Map<String, Object> stats = complaintService.getComplaintStats();
		model.addAttribute("stats", stats);
		return "admin/dashboard";
	}
}