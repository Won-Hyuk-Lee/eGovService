package kr.go.civilservice.member.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import kr.go.civilservice.member.mapper.MemberMapper;
import kr.go.civilservice.member.model.MemberVO;

public class MemberServiceImpl implements MemberService {

	private static final int MAX_LOGIN_FAILS = 5;

	private MemberMapper memberMapper;
	private BCryptPasswordEncoder passwordEncoder;

	public void setMemberMapper(MemberMapper memberMapper) {
		this.memberMapper = memberMapper;
	}

	public void setPasswordEncoder(BCryptPasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	@Override
	public void registerMember(MemberVO memberVO) {
		memberVO.setPassword(passwordEncoder.encode(memberVO.getPassword()));
		memberMapper.insertMember(memberVO);
		memberMapper.insertAuthority(memberVO.getMemberId(), "USER");
	}

	@Override
	public boolean isIdDuplicate(String memberId) {
		return memberMapper.getMemberById(memberId) != null;
	}

	@Override
	public MemberVO login(String memberId, String password) {
		MemberVO member = memberMapper.getMemberById(memberId);

		if (member != null && passwordEncoder.matches(password, member.getPassword())) {
			if ("0".equals(member.getEnabled())) {
				return null; // 계정 잠금 상태
			}
			memberMapper.updateLastLoginDate(memberId);
			return member;
		}
		return null;
	}

	@Override
	public String getMemberRole(String memberId) {
		List<String> authorities = memberMapper.getMemberAuthorities(memberId);
		return authorities != null && !authorities.isEmpty() ? authorities.get(0) : "USER";
	}

	@Override
	public boolean isAccountLocked(String memberId) {
		MemberVO member = memberMapper.getMemberById(memberId);
		return member != null && "0".equals(member.getEnabled());
	}

	@Override
	public int increaseLoginFailCount(String memberId) {
		int failCount = memberMapper.getLoginFailCount(memberId);
		failCount++;

		memberMapper.updateLoginFailCount(memberId, failCount);

		if (failCount >= MAX_LOGIN_FAILS) {
			lockAccount(memberId);
		}

		return failCount;
	}

	@Override
	public void resetLoginFailCount(String memberId) {
		memberMapper.resetLoginFailCount(memberId);
	}

	@Override
	public void lockAccount(String memberId) {
		memberMapper.lockAccount(memberId);
	}

	@Override
	public void unlockAccount(String memberId) {
		memberMapper.unlockAccount(memberId);
	}

	@Override
	public void changePassword(String memberId, String currentPassword, String newPassword) {
		MemberVO member = memberMapper.getMemberById(memberId);

		if (member == null) {
			throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
		}

		if (!passwordEncoder.matches(currentPassword, member.getPassword())) {
			throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
		}

		String encodedNewPassword = passwordEncoder.encode(newPassword);
		memberMapper.updatePassword(memberId, encodedNewPassword);
	}

	@Override
	public List<MemberVO> getAllMembers() {
		return memberMapper.getAllMembers();
	}

	@Override
	public List<MemberVO> getMemberList(int page, int pageSize) {
		Map<String, Object> params = new HashMap<>();
		params.put("start", (page - 1) * pageSize);
		params.put("size", pageSize);
		return memberMapper.selectMemberList(params);
	}

	@Override
	public int getTotalMemberCount() {
		return memberMapper.getTotalMemberCount();
	}

	@Override
	public MemberVO getMemberById(String memberId) {
		return memberMapper.getMemberById(memberId);
	}

}