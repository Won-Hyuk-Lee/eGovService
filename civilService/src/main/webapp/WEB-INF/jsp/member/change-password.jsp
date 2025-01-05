<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/member/change-password.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    
    <main class="main-content">
        <div class="password-change-container">
            <h2>비밀번호 변경</h2>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <form action="<c:url value='/member/password'/>" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="currentPassword">현재 비밀번호</label>
                    <input type="password" id="currentPassword" name="currentPassword" required>
                </div>
                
                <div class="form-group">
                    <label for="newPassword">새 비밀번호</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                    <p class="password-guide">영문, 숫자, 특수문자를 포함한 8~16자</p>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">새 비밀번호 확인</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                
                <button type="submit" class="submit-btn">변경하기</button>
            </form>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    
    <script>
    function validateForm() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        // 비밀번호 정규식 (영문, 숫자, 특수문자 포함 8~16자)
        const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,16}$/;
        
        if (!passwordRegex.test(newPassword)) {
            alert('비밀번호는 영문, 숫자, 특수문자를 포함한 8~16자여야 합니다.');
            return false;
        }
        
        if (newPassword !== confirmPassword) {
            alert('새 비밀번호가 일치하지 않습니다.');
            return false;
        }
        
        return true;
    }
    </script>
</body>
</html>