package kr.go.civilservice.member.mapper;

import java.util.List;
import java.util.Map;

import kr.go.civilservice.member.model.MemberVO;

public interface MemberMapper {
	MemberVO getMemberById(String username);

	List<String> getMemberAuthorities(String username);

	int insertMember(MemberVO member);

	int insertAuthority(String memberId, String authority);

	int updateMember(MemberVO member);

	int updateLoginFailCount(String memberId, int count);

	int updateLastLoginDate(String memberId);

	int updatePassword(String memberId, String newPassword);

	int getLoginFailCount(String memberId);

	int resetLoginFailCount(String memberId);

	int lockAccount(String memberId);

	int unlockAccount(String memberId);

	List<MemberVO> getAllMembers();

	List<MemberVO> selectMemberList(Map<String, Object> params);

	int getTotalMemberCount();
}