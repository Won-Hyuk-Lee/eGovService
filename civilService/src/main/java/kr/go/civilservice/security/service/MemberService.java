package kr.go.civilservice.security.service;

import kr.go.civilservice.security.model.MemberVO;

public interface MemberService {
    void registerMember(MemberVO memberVO);
    boolean isIdDuplicate(String memberId);
}