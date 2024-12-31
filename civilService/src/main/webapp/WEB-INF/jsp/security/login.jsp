<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="<c:url value='/css/security/login.css'/>">
</head>
<body>
    <div class="login-container">
        <h2>로그인</h2>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <c:if test="${not empty expired}">
            <div class="error-message">${expired}</div>
        </c:if>
        
        <form action="<c:url value='/login-proc'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <div class="form-group">
                <label for="username">아이디</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <button type="submit" class="login-btn">로그인</button>
        </form>
        
        <div class="links">
            <a href="<c:url value='/signup'/>">회원가입</a>
        </div>
    </div>
</body>
</html>