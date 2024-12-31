<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

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
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<div class="status-change">
							<select id="statusSelect">
								<option value="PENDING"
									${complaint.status == 'PENDING' ? 'selected' : ''}>접수대기</option>
								<option value="PROCESSING"
									${complaint.status == 'PROCESSING' ? 'selected' : ''}>처리중</option>
								<option value="COMPLETED"
									${complaint.status == 'COMPLETED' ? 'selected' : ''}>처리완료</option>
								<option value="REJECTED"
									${complaint.status == 'REJECTED' ? 'selected' : ''}>반려</option>
							</select>
							<button onclick="updateStatus()">상태 변경</button>
						</div>
					</sec:authorize>
				</div>

				<div class="complaint-info">
					<div class="info-row">
						<span class="label">제목</span> <span class="content">${complaint.title}</span>
					</div>
					<div class="info-row">
						<span class="label">작성자</span> <span class="content">${complaint.memberName}</span>
					</div>
					<div class="info-row">
						<span class="label">등록일</span> <span class="content"> <fmt:formatDate
								value="${complaint.createdDate}" pattern="yyyy-MM-dd HH:mm:ss" />
						</span>
					</div>
				</div>

				<div class="complaint-content">${complaint.content}</div>

				<c:if test="${not empty complaint.files}">
					<div class="file-list">
						<h3>첨부파일</h3>
						<ul>
							<c:forEach items="${complaint.files}" var="file">
								<li><a
									href="<c:url value='/complaint/file/${file.fileId}'/>"
									target="_blank" class="file-link"> ${file.originalFilename}
										<span class="file-size"> (<fmt:formatNumber
												value="${file.fileSize / 1024}" pattern="#,##0.0" /> KB)
									</span>
								</a></li>
							</c:forEach>
						</ul>
					</div>
				</c:if>

				<div class="history-list">
					<h3>처리 이력</h3>
					<table class="history-table">
						<thead>
							<tr>
								<th>처리일시</th>
								<th>처리상태</th>
								<th>처리자</th>
								<th>처리내용</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${histories}" var="history">
								<tr>
									<td><fmt:formatDate value="${history.createdDate}"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>
									<td><span class="status-${history.status.toLowerCase()}">${history.statusName}</span></td>
									<td>${history.handlerName}</td>
									<td>${history.processComment}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<div class="button-group">
					<a href="<c:url value='/complaint/list'/>" class="btn btn-list">목록</a>
					<sec:authorize
						access="hasRole('ROLE_ADMIN') or principal.username == complaint.memberId">
						<button type="button" onclick="deleteComplaint()"
							class="btn btn-delete">삭제</button>
					</sec:authorize>
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

        fetch('<c:url value="/complaint/${complaint.complaintId}/status"/>', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                '${_csrf.headerName}': '${_csrf.token}'
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

    function deleteComplaint() {
        if (confirm('정말 삭제하시겠습니까?')) {
            fetch('<c:url value="/complaint/${complaint.complaintId}"/>', {
                method: 'DELETE',
                headers: {
                    '${_csrf.headerName}': '${_csrf.token}'
                }
            })
            .then(response => {
                if (response.ok) {
                    alert('삭제되었습니다.');
                    location.href = '<c:url value="/complaint/list"/>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('삭제에 실패했습니다.');
            });
        }
    }
    </script>
</body>
</html>