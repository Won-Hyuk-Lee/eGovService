<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" href="<c:url value='/css/security/signup.css'/>">
</head>
<body>
	<div class="signup-container">
		<h2>회원가입</h2>

		<form action="<c:url value='/signup'/>" method="post"
			onsubmit="return validateForm()">
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />

			<div class="form-group">
				<label for="memberId">아이디</label>
				<div class="input-group">
					<input type="text" id="memberId" name="memberId" required>
					<button type="button" onclick="checkId()" class="check-btn">중복확인</button>
				</div>
			</div>

			<div class="form-group">
				<label for="password">비밀번호</label> <input type="password"
					id="password" name="password" required>
			</div>

			<div class="form-group">
				<label for="passwordConfirm">비밀번호 확인</label> <input type="password"
					id="passwordConfirm" required>
			</div>

			<div class="form-group">
				<label for="name">이름</label> <input type="text" id="name"
					name="name" required>
			</div>

			<div class="form-group">
				<label for="email">이메일</label> <input type="email" id="email"
					name="email" required>
			</div>

			<div class="form-group">
				<label for="phone">전화번호</label> <input type="tel" id="phone"
					name="phone" required>
			</div>

			<div class="form-group">
				<label for="address">주소</label> <input type="text" id="address"
					name="address">
			</div>

			<button type="submit" class="signup-btn">가입하기</button>
		</form>

		<div class="links">
			<a href="<c:url value='/login'/>">로그인으로 돌아가기</a>
		</div>
	</div>

	<script>
    function validateForm() {
        var password = document.getElementById('password').value;
        var passwordConfirm = document.getElementById('passwordConfirm').value;
        
        if (password !== passwordConfirm) {
            alert('비밀번호가 일치하지 않습니다.');
            return false;
        }
        return true;
    }
    </script>

	<script>
// 비밀번호 정규식 (8~16자, 영문/숫자/특수문자 조합)
const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,16}$/;

// 아이디 중복 체크
let isIdChecked = false;

function checkId() {
    const memberId = document.getElementById('memberId').value;
    if (!memberId) {
        alert('아이디를 입력해주세요.');
        return;
    }
    
    fetch('/checkId?memberId=' + memberId)
        .then(response => response.json())
        .then(data => {
            if (data.duplicate) {
                alert('이미 사용중인 아이디입니다.');
                isIdChecked = false;
            } else {
                alert('사용 가능한 아이디입니다.');
                isIdChecked = true;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('중복 체크 중 오류가 발생했습니다.');
        });
}

// 비밀번호 유효성 검사
function validatePassword(password) {
    return passwordRegex.test(password);
}

// 전화번호 형식 검사
function validatePhone(phone) {
    const phoneRegex = /^01[016789]-\d{3,4}-\d{4}$/;
    return phoneRegex.test(phone);
}

// 이메일 형식 검사
function validateEmail(email) {
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    return emailRegex.test(email);
}

// 폼 전송 전 최종 검증
function validateForm() {
    const password = document.getElementById('password').value;
    const passwordConfirm = document.getElementById('passwordConfirm').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    
    if (!isIdChecked) {
        alert('아이디 중복 체크를 해주세요.');
        return false;
    }
    
    if (!validatePassword(password)) {
        alert('비밀번호는 8~16자의 영문, 숫자, 특수문자를 포함해야 합니다.');
        return false;
    }
    
    if (password !== passwordConfirm) {
        alert('비밀번호가 일치하지 않습니다.');
        return false;
    }
    
    if (!validateEmail(email)) {
        alert('올바른 이메일 형식이 아닙니다.');
        return false;
    }
    
    if (!validatePhone(phone)) {
        alert('올바른 전화번호 형식이 아닙니다. (예: 010-1234-5678)');
        return false;
    }
    
    return true;
}

// 아이디 입력 필드 변경시 중복체크 상태 초기화
document.getElementById('memberId').addEventListener('input', function() {
    isIdChecked = false;
});
</script>

</body>
</html>