package kr.go.civilservice.security.service;

import java.util.ArrayList;
import java.util.List;

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
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberVO member = memberMapper.getMemberById(username);
        if (member == null) {
            throw new UsernameNotFoundException("User not found: " + username);
        }
        
        List<GrantedAuthority> authorities = new ArrayList<>();
        List<String> authList = memberMapper.getMemberAuthorities(username);
        for (String auth : authList) {
            authorities.add(new SimpleGrantedAuthority(auth));
        }
        
        return new CustomUserDetail(
            member.getMemberId(),
            member.getPassword(),
            "1".equals(member.getEnabled()),
            true, // accountNonExpired
            true, // credentialsNonExpired
            true, // accountNonLocked
            authorities,
            member.getName(),
            member.getEmail(),
            member.getPhone()
        );
    }
}