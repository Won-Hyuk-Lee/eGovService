package kr.go.civilservice.security.model;

import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import lombok.Getter;

@Getter
public class CustomUserDetail extends User {
    private static final long serialVersionUID = 1L;
    
    private String name;
    private String email;
    private String phone;

    public CustomUserDetail(String username, String password, 
            boolean enabled, boolean accountNonExpired,
            boolean credentialsNonExpired, boolean accountNonLocked,
            Collection<? extends GrantedAuthority> authorities,
            String name, String email, String phone) {
        
        super(username, password, enabled, accountNonExpired,
                credentialsNonExpired, accountNonLocked, authorities);
        
        this.name = name;
        this.email = email;
        this.phone = phone;
    }
}