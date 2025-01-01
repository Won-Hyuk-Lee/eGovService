package kr.go.civilservice.security.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.go.civilservice.security.model.MemberVO;

public interface MemberMapper {
	MemberVO getMemberById(String memberId);

	List<String> getMemberAuthorities(String memberId);

	int insertMember(MemberVO member);

	int insertAuthority(@Param("memberId") String memberId, @Param("authority") String authority);

	int updateMember(MemberVO member);

	int updateLoginFailCount(String memberId, int count);

	int updateLastLoginDate(String memberId);
}