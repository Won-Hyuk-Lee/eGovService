<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>접근 거부</title>
    <link rel="stylesheet" href="<c:url value='/css/member/access-denied.css'/>">
</head>
<body>
    <div class="access-denied-container">
        <h2>접근 권한이 없습니다.</h2>
        <p>해당 페이지에 접근할 수 있는 권한이 없습니다.</p>
        <div class="links">
            <a href="<c:url value='/'/>">메인으로</a>
            <a href="javascript:history.back()">이전 페이지로</a>
        </div>
    </div>
</body>
</html>