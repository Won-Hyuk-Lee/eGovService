<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="main-header">
    <div class="header-container">
        <div class="logo">
            <a href="<c:url value='/'/>">전자민원시스템</a>
        </div>
        <nav class="main-nav">
            <ul>
                <li><a href="<c:url value='/complaint/list'/>">민원목록</a></li>
                <sec:authorize access="hasRole('ROLE_USER')">
                    <li><a href="<c:url value='/complaint/create'/>">민원신청</a></li>
                </sec:authorize>
                <sec:authorize access="hasRole('ROLE_ADMIN')">
                    <li><a href="<c:url value='/admin/dashboard'/>">관리자</a></li>
                </sec:authorize>
            </ul>
        </nav>
        <div class="user-menu">
            <sec:authorize access="isAuthenticated()">
                <span class="user-name"><sec:authentication property="principal.name"/>님</span>
                <a href="<c:url value='/logout'/>" class="logout-btn">로그아웃</a>
            </sec:authorize>
            <sec:authorize access="isAnonymous()">
                <a href="<c:url value='/login'/>" class="login-btn">로그인</a>
                <a href="<c:url value='/signup'/>" class="signup-btn">회원가입</a>
            </sec:authorize>
        </div>
    </div>
</header>