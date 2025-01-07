<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>민원 수정</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/complaint/create.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    
    <main class="main-content">
        <div class="container">
            <h2>민원 수정</h2>
            
            <form action="<c:url value='/complaint/edit/${complaint.complaintId}'/>" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="title">제목</label>
                    <input type="text" id="title" name="title" value="${complaint.title}" required>
                </div>
                
                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" rows="10" required>${complaint.content}</textarea>
                </div>
                
                <div class="form-group">
                    <label for="files">첨부파일</label>
                    <input type="file" id="files" name="files" multiple>
                    <small>* 파일은 최대 5개까지 첨부 가능합니다.</small>
                    
                    <c:if test="${not empty complaint.files}">
                        <div class="current-files">
                            <h4>현재 첨부된 파일</h4>
                            <ul>
                                <c:forEach items="${complaint.files}" var="file">
                                    <li>
                                        ${file.originalFilename}
                                        <button type="button" onclick="deleteFile(${file.fileId})" class="delete-file-btn">삭제</button>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label>공개 설정</label>
                    <div class="radio-group">
                        <input type="radio" id="public" name="publicYn" value="Y" ${complaint.publicYn eq 'Y' ? 'checked' : ''}>
                        <label for="public">전체공개</label>
                        <input type="radio" id="private" name="publicYn" value="N" ${complaint.publicYn eq 'N' ? 'checked' : ''}>
                        <label for="private">비공개</label>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="privateInfoYn">
                        <input type="checkbox" id="privateInfoYn" name="privateInfoYn" value="Y" ${complaint.privateInfoYn eq 'Y' ? 'checked' : ''}>
                        개인정보 포함 여부
                    </label>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="submit-btn">수정</button>
                    <a href="<c:url value='/complaint/view/${complaint.complaintId}'/>" class="cancel-btn">취소</a>
                </div>
            </form>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    
    <script>
    function deleteFile(fileId) {
        if (confirm('파일을 삭제하시겠습니까?')) {
            fetch('<c:url value="/complaint/file/delete/"/>' + fileId, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('파일이 삭제되었습니다.');
                    location.reload();
                } else {
                    alert('파일 삭제에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('파일 삭제 중 오류가 발생했습니다.');
            });
        }
    }
    </script>
</body>
</html>