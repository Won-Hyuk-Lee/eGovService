<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>민원 상세보기</title>
   <!-- 공통 레이아웃과 상세페이지 전용 스타일시트 로드 -->
   <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
   <link rel="stylesheet" href="<c:url value='/css/complaint/detail.css'/>">
</head>
<body>
   <!-- 공통 헤더 포함 -->
   <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
   
   <main class="main-content">
       <div class="container">
           <div class="complaint-detail">
               <h2>민원 상세보기</h2>
               
               <!-- 민원 상태 표시 및 관리자용 상태 변경 영역 -->
               <div class="status-area">
                   <span class="status status-${complaint.status.toLowerCase()}">${complaint.statusName}</span>
                   <!-- 관리자만 볼 수 있는 상태 변경 UI -->
                   <c:if test="${sessionScope.memberRole eq 'ADMIN'}">
                       <div class="status-change">
                           <select id="statusSelect">
                               <option value="PENDING" ${complaint.status == 'PENDING' ? 'selected' : ''}>접수대기</option>
                               <option value="PROCESSING" ${complaint.status == 'PROCESSING' ? 'selected' : ''}>처리중</option>
                               <option value="COMPLETED" ${complaint.status == 'COMPLETED' ? 'selected' : ''}>처리완료</option>
                               <option value="REJECTED" ${complaint.status == 'REJECTED' ? 'selected' : ''}>반려</option>
                           </select>
                           <button onclick="updateStatus()" class="btn-status-change">상태 변경</button>
                       </div>
                   </c:if>
               </div>

               <!-- 민원 기본 정보 영역 -->
               <div class="complaint-info">
                   <div class="info-row">
                       <span class="label">제목</span>
                       <span class="content">${complaint.title}</span>
                   </div>
                   <div class="info-row">
                       <span class="label">작성자</span>
                       <span class="content">${complaint.memberName}</span>
                   </div>
                   <div class="info-row">
                       <span class="label">등록일</span>
                       <span class="content">
                           <fmt:formatDate value="${complaint.createdDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                       </span>
                   </div>
                   <div class="info-row">
                       <span class="label">공개여부</span>
                       <span class="content">
                           ${complaint.publicYn == 'Y' ? '전체공개' : '비공개'}
                       </span>
                   </div>
               </div>

               <!-- 민원 내용 영역 -->
               <div class="complaint-content">
                   ${complaint.content}
               </div>

               <!-- 첨부파일 목록 영역 -->
               <c:if test="${not empty complaint.files}">
                   <div class="file-list">
                       <h3>첨부파일</h3>
                       <ul>
                           <c:forEach items="${complaint.files}" var="file">
                               <li>
                                   <a href="<c:url value='/complaint/file/${file.fileId}'/>" class="file-link">
                                       ${file.originalFilename}
                                       <span class="file-size">
                                           (<fmt:formatNumber value="${file.fileSize / 1024}" pattern="#,##0.0"/> KB)
                                       </span>
                                   </a>
                               </li>
                           </c:forEach>
                       </ul>
                   </div>
               </c:if>

               <!-- 버튼 그룹: 목록/수정/삭제 -->
               <div class="button-group">
                   <a href="<c:url value='/complaint/list'/>" class="btn btn-list">목록</a>
                   
                   <!-- 작성자와 관리자만 수정/삭제 가능 -->
                   <c:if test="${sessionScope.memberRole eq 'ADMIN' or sessionScope.member.memberId eq complaint.memberId}">
                       <a href="<c:url value='/complaint/edit/${complaint.complaintId}'/>" class="btn btn-edit">수정</a>
                       <button type="button" onclick="deleteComplaint()" class="btn btn-delete">삭제</button>
                   </c:if>
               </div>
           </div>
       </div>
   </main>

   <!-- 로그인 필요시 표시되는 모달 -->
   <div id="loginModal" class="modal" style="display: none;">
       <div class="modal-content">
           <h3>로그인이 필요합니다</h3>
           <p>해당 민원을 보기 위해서는 로그인이 필요합니다.</p>
           <div class="modal-buttons">
               <button onclick="location.href='<c:url value='/member/login'/>'" class="btn-login">지금 로그인하기</button>
               <button onclick="closeModal()" class="btn-close">닫기</button>
           </div>
       </div>
   </div>
   
   <!-- 공통 푸터 포함 -->
   <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />

   <!-- JavaScript 코드 -->
   <script>
   // 로그인 모달 관련 기능
   var loginRequired = ${loginRequired != null && loginRequired};
   if (loginRequired) {
       document.getElementById('loginModal').style.display = 'block';
   }

   function closeModal() {
       document.getElementById('loginModal').style.display = 'none';
   }

   // 민원 삭제 기능
   function deleteComplaint() {
       if (confirm('정말 삭제하시겠습니까?')) {
           location.href = '<c:url value="/complaint/delete/${complaint.complaintId}"/>';
       }
   }

   // 민원 상태 변경 기능 (관리자용)
   function updateStatus() {
       const status = document.getElementById('statusSelect').value;
       const comment = prompt('처리 내용을 입력해주세요.');
       
       if (comment === null) return; // 취소 버튼 클릭시 처리 중단

       const complaintId = ${complaint.complaintId};
       const url = '<c:url value="/complaint/status/"/>' + complaintId;
       
       // AJAX를 통한 상태 변경 요청
       fetch(url, {
           method: 'POST',
           headers: {
               'Content-Type': 'application/x-www-form-urlencoded',
           },
           body: 'status=' + status + '&comment=' + encodeURIComponent(comment)
       })
       .then(response => response.json())
       .then(data => {
           if (data.success) {
               alert('상태가 변경되었습니다.');
               location.reload();
           } else {
               alert('상태 변경에 실패했습니다.');
           }
       })
       .catch(error => {
           console.error('Error:', error);
           alert('상태 변경 중 오류가 발생했습니다.');
       });
   }
   </script>

   <!-- 인라인 스타일 (모달 관련) -->
   <style>
   /* 모달 기본 스타일 */
   .modal {
       display: none;
       position: fixed;
       top: 0;
       left: 0;
       width: 100%;
       height: 100%;
       background-color: rgba(0,0,0,0.5);
       z-index: 1000;
   }

   /* 모달 컨텐츠 스타일 */
   .modal-content {
       position: absolute;
       top: 50%;
       left: 50%;
       transform: translate(-50%, -50%);
       background-color: white;
       padding: 20px;
       border-radius: 5px;
       text-align: center;
   }

   /* 모달 버튼 영역 스타일 */
   .modal-buttons {
       margin-top: 20px;
   }

   .modal-buttons button {
       margin: 0 10px;
       padding: 8px 16px;
       border: none;
       border-radius: 4px;
       cursor: pointer;
   }

   /* 버튼 스타일 */
   .btn-login {
       background-color: #007bff;
       color: white;
   }

   .btn-close {
       background-color: #6c757d;
       color: white;
   }
   
   .btn-edit {
       background-color: #28a745;
       color: white;
   }

   /* 상태변경 버튼 스타일 */
   .btn-status-change {
       padding: 8px 16px;
       background-color: #007bff;
       color: white;
       border: none;
       border-radius: 4px;
       cursor: pointer;
       margin-left: 10px;
   }

   .btn-status-change:hover {
       background-color: #0056b3;
   }
   </style>
</body>
</html>