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
                            <button onclick="showStatusModal()" class="btn-status-change">상태 변경</button>
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

                <!-- 처리이력 영역 추가 -->
                <div class="history-list">
                    <h3>처리이력</h3>
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
                                    <td><fmt:formatDate value="${history.createdDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                    <td>${history.statusName}</td>
                                    <td>${history.handlerName}</td>
                                    <td>
                                        <div class="process-content">
                                            ${history.processComment}
                                            <c:if test="${not empty history.requestFiles}">
                                                <div class="request-files">
                                                    <strong>추가 요청 서류:</strong> ${history.requestFiles}
                                                    <c:if test="${not empty history.requestDeadline}">
                                                        <br>
                                                        <strong>제출기한:</strong> 
                                                        <fmt:formatDate value="${history.requestDeadline}" pattern="yyyy-MM-dd"/>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty history.resultContent}">
                                                <div class="result-content">
                                                    <strong>처리결과:</strong><br>
                                                    ${history.resultContent}
                                                </div>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

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

            <!-- 상태 변경 모달 -->
            <div id="statusModal" class="modal">
                <div class="modal-content">
                    <h3>민원 처리 상태 변경</h3>
                    <form id="statusForm">
                        <div class="form-group">
                            <label for="statusSelect">처리상태</label>
                            <select id="statusSelect" name="status" class="form-control">
                                <option value="PENDING">접수대기</option>
                                <option value="PROCESSING">처리중</option>
                                <option value="COMPLETED">처리완료</option>
                                <option value="REJECTED">반려</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="processComment">처리내용</label>
                            <textarea id="processComment" name="processComment" rows="4" class="form-control"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="requestFiles">추가 요청 서류</label>
                            <input type="text" id="requestFiles" name="requestFiles" class="form-control" 
                                placeholder="필요한 서류를 쉼표(,)로 구분하여 입력">
                        </div>
                        
                        <div class="form-group">
                            <label for="requestDeadline">서류 제출 기한</label>
                            <input type="date" id="requestDeadline" name="requestDeadline" class="form-control">
                        </div>
                        
                        <div class="form-group">
                            <label for="resultContent">처리 결과</label>
                            <textarea id="resultContent" name="resultContent" rows="4" class="form-control"></textarea>
                        </div>
                        
                        <div class="modal-buttons">
                            <button type="button" onclick="submitStatusChange()" class="btn btn-primary">저장</button>
                            <button type="button" onclick="closeStatusModal()" class="btn btn-secondary">취소</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
   
    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />

    <!-- JavaScript -->
    <script>
    function showStatusModal() {
        document.getElementById('statusModal').style.display = 'block';
        
        // 현재 상태 선택
        const currentStatus = '${complaint.status}';
        document.getElementById('statusSelect').value = currentStatus;
    }

    function closeStatusModal() {
        document.getElementById('statusModal').style.display = 'none';
    }

    function submitStatusChange() {
        const formData = new FormData(document.getElementById('statusForm'));
        
        fetch('<c:url value="/complaint/status/"/>${complaint.complaintId}', {
            method: 'POST',
            body: formData
        })
        .then(() => {
            alert('상태가 변경되었습니다.');
            location.reload();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('상태 변경 중 오류가 발생했습니다.');
        });

        closeStatusModal();
    }
    </script>

    <style>
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

    .modal-content {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background-color: white;
        padding: 20px;
        border-radius: 5px;
        width: 500px;
        max-height: 80vh;
        overflow-y: auto;
    }

    .history-list {
        margin-top: 30px;
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 5px;
    }

    .history-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }

    .history-table th,
    .history-table td {
        padding: 12px;
        border: 1px solid #dee2e6;
    }

    .history-table th {
        background-color: #e9ecef;
        text-align: center;
    }

    .process-content {
        white-space: pre-line;
    }

    .request-files,
    .result-content {
        margin-top: 10px;
        padding: 10px;
        background-color: #fff;
        border-radius: 4px;
    }
    </style>
</body>
</html>