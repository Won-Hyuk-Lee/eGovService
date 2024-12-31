package kr.go.civilservice.security.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.go.civilservice.security.mapper.MemberMapper;
import kr.go.civilservice.security.model.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {
    
    @Autowired
    private MemberMapper memberMapper;
    
    @Override
    @Transactional
    public void registerMember(MemberVO memberVO) {
        // 회원 기본정보 저장
        memberMapper.insertMember(memberVO);
        
        // 기본 권한 부여 (ROLE_USER)
        memberMapper.insertAuthority(memberVO.getMemberId(), "ROLE_USER");
    }
    
    @Override
    public boolean isIdDuplicate(String memberId) {
        return memberMapper.getMemberById(memberId) != null;
    }
}