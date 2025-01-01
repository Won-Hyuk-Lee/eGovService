package kr.go.civilservice.security.service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.go.civilservice.security.mapper.MemberMapper;
import kr.go.civilservice.security.model.CustomUserDetail;
import kr.go.civilservice.security.model.MemberVO;

@Service
public class CustomUserDetailService implements UserDetailsService {

	@Autowired
	private MemberMapper memberMapper;

	/**
	 * 사용자명으로 사용자 details 로드
	 * 
	 * @param username 로그인 시도하는 사용자명
	 * @return 사용자 인증 정보를 담은 UserDetails 객체
	 * @throws UsernameNotFoundException 사용자를 찾을 수 없는 경우
	 */
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		// 사용자명 유효성 검사
		if (username == null || username.trim().isEmpty()) {
			throw new UsernameNotFoundException("사용자명은 비어있을 수 없습니다.");
		}

		// 사용자 정보 조회
		MemberVO member = memberMapper.getMemberById(username);
		if (member == null) {
			throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
		}

		// 사용자 권한 목록 조회
		List<String> authList = memberMapper.getMemberAuthorities(username);

		// 권한 목록이 없는 경우 기본 권한 설정
		if (authList == null || authList.isEmpty()) {
			authList = Arrays.asList("ROLE_USER");
		}

		// 권한 문자열을 GrantedAuthority 객체로 변환
		List<GrantedAuthority> authorities = authList.stream().map(SimpleGrantedAuthority::new)
				.collect(Collectors.toList());

		// 필수 필드 null 체크
		if (member.getMemberId() == null || member.getPassword() == null) {
			throw new UsernameNotFoundException("잘못된 사용자 정보입니다.");
		}

		// 사용자 인증 정보 생성 및 반환
		return new CustomUserDetail(member.getMemberId(), // 사용자 ID
				member.getPassword(), // 비밀번호
				"1".equals(member.getEnabled()), // 계정 활성화 상태
				true, // 계정 만료 여부
				true, // 자격 증명 만료 여부
				true, // 계정 잠김 여부
				authorities, // 사용자 권한 목록
				member.getName(), // 사용자 이름
				member.getEmail(), // 이메일
				member.getPhone() // 전화번호
		);
	}
}