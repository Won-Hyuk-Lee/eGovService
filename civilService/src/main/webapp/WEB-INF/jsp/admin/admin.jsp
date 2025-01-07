<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/admin.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    
    <main class="main-content">
        <div class="container">
            <div class="admin-tabs">
                <a href="<c:url value='/admin/members'/>" 
                   class="tab ${activeTab == 'members' ? 'active' : ''}">회원 관리</a>
                <a href="<c:url value='/admin/complaints'/>" 
                   class="tab ${activeTab == 'complaints' ? 'active' : ''}">민원 관리</a>
            </div>

            <div class="content-area">
                <c:choose>
                    <c:when test="${activeTab == 'members'}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>이름</th>
                                    <th>이메일</th>
                                    <th>상태</th>
                                    <th>마지막 로그인</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${members}" var="member">
                                    <tr onclick="location.href='<c:url value="/admin/member/${member.memberId}"/>'">
                                        <td>${member.memberId}</td>
                                        <td>${member.name}</td>
                                        <td>${member.email}</td>
                                        <td>
                                            <span class="status ${member.enabled == '1' ? 'active' : 'inactive'}">
                                                ${member.enabled == '1' ? '정상' : '비활성'}
                                            </span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${member.lastLoginDate}" 
                                                          pattern="yyyy-MM-dd HH:mm:ss"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:when test="${activeTab == 'complaints'}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>상태</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${complaints}" var="complaint">
                                    <tr onclick="location.href='<c:url value="/complaint/view/${complaint.complaintId}"/>'">
                                        <td>${complaint.complaintId}</td>
                                        <td>${complaint.title}</td>
                                        <td>${complaint.memberName}</td>
                                        <td>
                                            <span class="status ${complaint.status.toLowerCase()}">
                                                ${complaint.statusName}
                                            </span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${complaint.createdDate}" 
                                                          pattern="yyyy-MM-dd HH:mm:ss"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                </c:choose>

                <!-- 페이징 -->
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}" class="page-link">이전</a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <a href="?page=${pageNum}" 
                           class="page-link ${pageNum == currentPage ? 'active' : ''}">
                            ${pageNum}
                        </a>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}" class="page-link">다음</a>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
</body>
</html>