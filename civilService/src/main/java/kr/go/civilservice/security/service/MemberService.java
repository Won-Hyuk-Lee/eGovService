package kr.go.civilservice.security.service;

import java.util.List;

import kr.go.civilservice.security.model.MemberVO;

public interface MemberService {
	void registerMember(MemberVO memberVO);

	boolean isIdDuplicate(String memberId);

	MemberVO login(String memberId, String password);

	String getMemberRole(String memberId);

	boolean isAccountLocked(String memberId);

	int increaseLoginFailCount(String memberId);

	void resetLoginFailCount(String memberId);

	void lockAccount(String memberId);

	void unlockAccount(String memberId);

	void changePassword(String memberId, String currentPassword, String newPassword);

	List<MemberVO> getAllMembers();
}
