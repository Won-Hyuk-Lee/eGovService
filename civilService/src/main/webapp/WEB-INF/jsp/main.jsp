<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전자민원시스템</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp"/>
    
    <main class="main-content">
        <div class="main-banner">
            <h1>전자민원시스템</h1>
            <p>빠르고 편리한 민원처리 서비스를 제공합니다.</p>
        </div>
        
        <div class="main-features">
            <div class="feature">
                <h3>민원신청</h3>
                <p>24시간 언제든지 민원을 신청하실 수 있습니다.</p>
            </div>
            <div class="feature">
                <h3>처리현황</h3>
                <p>실시간으로 민원처리 현황을 확인하실 수 있습니다.</p>
            </div>
            <div class="feature">
                <h3>알림서비스</h3>
                <p>민원처리 상태가 변경되면 즉시 알려드립니다.</p>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp"/>
</body>
</html>