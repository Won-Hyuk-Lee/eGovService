package kr.go.civilservice.security.model;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberVO {
	private String memberId;
	private String password;
	private String name;
	private String email;
	private String phone;
	private String address;
	private String enabled;
	private Date createdDate;
	private Date modifiedDate;
	private Date lastLoginDate;
	private Date passwordChangeDate;
	private int loginFailCount;
}