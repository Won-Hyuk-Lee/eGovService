<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="main-header">
    <div class="header-container">
        <div class="logo">
            <a href="<c:url value='/'/>">전자민원시스템</a>
        </div>
        <nav class="main-nav">
            <ul>
                <li><a href="<c:url value='/complaint/list'/>">민원목록</a></li>
                <c:if test="${not empty sessionScope.member}">
                    <li><a href="<c:url value='/complaint/create'/>">민원신청</a></li>
                </c:if>
                <c:if test="${sessionScope.memberRole eq 'ADMIN'}">
                    <li><a href="<c:url value='/admin/dashboard'/>">관리자</a></li>
                </c:if>
            </ul>
        </nav>
        <div class="user-menu">
            <c:choose>
                <c:when test="${not empty sessionScope.member}">
                    <span class="user-name">${sessionScope.member.name}님</span>
                    <a href="<c:url value='/member/logout'/>" class="logout-btn">로그아웃</a>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value='/member/login'/>" class="login-btn">로그인</a>
                    <a href="<c:url value='/member/signup'/>" class="signup-btn">회원가입</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>