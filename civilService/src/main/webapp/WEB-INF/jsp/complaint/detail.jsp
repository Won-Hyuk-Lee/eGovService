<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>민원 상세보기</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/complaint/detail.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    
    <main class="main-content">
        <div class="container">
            <div class="complaint-detail">
                <h2>민원 상세보기</h2>
                
                <div class="status-area">
                    <span class="status status-${complaint.status.toLowerCase()}">${complaint.statusName}</span>
                    <c:if test="${sessionScope.memberRole eq 'ADMIN'}">
                        <div class="status-change">
                            <select id="statusSelect">
                                <option value="PENDING" ${complaint.status == 'PENDING' ? 'selected' : ''}>접수대기</option>
                                <option value="PROCESSING" ${complaint.status == 'PROCESSING' ? 'selected' : ''}>처리중</option>
                                <option value="COMPLETED" ${complaint.status == 'COMPLETED' ? 'selected' : ''}>처리완료</option>
                                <option value="REJECTED" ${complaint.status == 'REJECTED' ? 'selected' : ''}>반려</option>
                            </select>
                            <button onclick="updateStatus()">상태 변경</button>
                        </div>
                    </c:if>
                </div>

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
                </div>

                <div class="complaint-content">${complaint.content}</div>

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

                <div class="button-group">
                    <a href="<c:url value='/complaint/list'/>" class="btn btn-list">목록</a>
                    <c:if test="${sessionScope.memberRole eq 'ADMIN' or sessionScope.member.memberId eq complaint.memberId}">
                        <button type="button" onclick="deleteComplaint()" class="btn btn-delete">삭제</button>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />

    <script>
    function updateStatus() {
        const status = document.getElementById('statusSelect').value;
        const comment = prompt('처리 내용을 입력해주세요.');
        
        if (comment === null) return;

        fetch('<c:url value="/complaint/status/${complaint.complaintId}"/>', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({
                'status': status,
                'comment': comment
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('상태가 변경되었습니다.');
                location.reload();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('상태 변경에 실패했습니다.');
        });
    }

    function deleteComplaint() {function deleteComplaint() {
        if (confirm('정말 삭제하시겠습니까?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '<c:url value="/complaint/delete/${complaint.complaintId}"/>';
            document.body.appendChild(form);
            form.submit();
        }
    }
    </script>
</body>
</html>