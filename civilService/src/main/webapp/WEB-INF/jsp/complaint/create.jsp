<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>민원 등록</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/complaint/create.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    
    <main class="main-content">
        <div class="container">
            <h2>민원 등록</h2>
            
            <form action="<c:url value='/complaint/create'/>" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="title">제목</label>
                    <input type="text" id="title" name="title" required>
                </div>
                
                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" rows="10" required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="files">첨부파일</label>
                    <input type="file" id="files" name="files" multiple>
                    <small>* 파일은 최대 5개까지 첨부 가능합니다.</small>
                </div>

                <div class="form-group">
                    <label>공개 설정</label>
                    <div class="radio-group">
                        <input type="radio" id="public" name="publicYn" value="Y" checked>
                        <label for="public">전체공개</label>
                        <input type="radio" id="private" name="publicYn" value="N">
                        <label for="private">비공개</label>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="privateInfoYn">
                        <input type="checkbox" id="privateInfoYn" name="privateInfoYn" value="Y">
                        개인정보 포함 여부
                    </label>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="submit-btn">등록</button>
                    <a href="<c:url value='/complaint/list'/>" class="cancel-btn">취소</a>
                </div>
            </form>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
</body>
</html>