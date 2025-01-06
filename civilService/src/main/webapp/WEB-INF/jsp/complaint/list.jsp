<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>민원 목록</title>
   <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
   <link rel="stylesheet" href="<c:url value='/css/complaint/list.css'/>">
</head>
<body>
   <!-- 공통 헤더 포함 -->
   <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
   
   <main class="main-content">
       <div class="container">
           <h2>민원 목록</h2>
           
           <!-- 검색 조건 필터링 -->
           <div class="search-form">
               <form action="<c:url value='/complaint/list'/>" method="get">
                   <!-- 검색 유형 선택 -->
                   <select name="searchType">
                       <option value="title" ${param.searchType == 'title' ? 'selected' : ''}>제목</option>
                       <option value="content" ${param.searchType == 'content' ? 'selected' : ''}>내용</option>
                       <option value="writer" ${param.searchType == 'writer' ? 'selected' : ''}>작성자</option>
                   </select>
                   
                   <!-- 검색어 입력 -->
                   <input type="text" name="searchKeyword" value="${param.searchKeyword}" 
                          placeholder="검색어를 입력하세요">
                   
                   <!-- 민원 처리상태 필터 -->
                   <select name="status">
                       <option value="">전체</option>
                       <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>접수대기</option>
                       <option value="PROCESSING" ${param.status == 'PROCESSING' ? 'selected' : ''}>처리중</option>
                       <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>처리완료</option>
                       <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>반려</option>
                   </select>
                   
                   <button type="submit">검색</button>
               </form>
           </div>
           
           <!-- 민원 목록 테이블 -->
           <table class="complaint-table">
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
                   <!-- 민원 목록 반복 표시 -->
                   <c:forEach items="${complaints}" var="complaint">
                       <tr onclick="location.href='${pageContext.request.contextPath}/complaint/view/${complaint.complaintId}'">
                           <td>${complaint.complaintId}</td>
                           <td>
                               ${complaint.title}
                               <!-- 첨부파일 존재 시 아이콘 표시 -->
                               <c:if test="${not empty complaint.files}">
                                   <span class="file-icon">📎</span>
                               </c:if>
                           </td>
                           <td>${complaint.memberName}</td>
                           <td>
                               <span class="status-${complaint.status.toLowerCase()}">
                                   ${complaint.statusName}
                               </span>
                           </td>
                           <td>
                               <fmt:formatDate value="${complaint.createdDate}" pattern="yyyy-MM-dd"/>
                           </td>
                       </tr>
                   </c:forEach>
               </tbody>
           </table>
           
           <!-- 로그인한 사용자만 민원등록 버튼 표시 -->
           <c:if test="${not empty sessionScope.member}">
               <div class="button-area">
                   <a href="<c:url value='/complaint/create'/>" class="create-btn">민원 등록</a>
               </div>
           </c:if>
       </div>
   </main>
   
   <!-- 공통 푸터 포함 -->
   <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
</body>
</html>