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
   <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
   
   <main class="main-content">
       <div class="container">
           <h2>민원 목록</h2>
           
           <!-- 검색 폼은 그대로 유지 -->
           
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
                   <c:forEach items="${complaints}" var="complaint">
                       <tr onclick="viewComplaint(${complaint.complaintId})" style="cursor: pointer;">
                           <td>${complaint.complaintId}</td>
                           <td>
                               ${complaint.title}
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
           
           <c:if test="${not empty sessionScope.member}">
               <div class="button-area">
                   <a href="<c:url value='/complaint/create'/>" class="create-btn">민원 등록</a>
               </div>
           </c:if>
       </div>
   </main>
   
   <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />

   <script>
   function viewComplaint(complaintId) {
       if(complaintId) {
           const contextPath = '${pageContext.request.contextPath}';
           window.location.href = contextPath + '/complaint/view/' + complaintId;
       }
   }
   </script>
</body>
</html>