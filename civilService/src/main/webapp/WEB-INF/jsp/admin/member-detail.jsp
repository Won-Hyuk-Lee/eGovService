<!-- /WEB-INF/jsp/admin/member-detail.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 상세 정보</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/member-detail.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    
    <main class="main-content">
        <div class="container">
            <h2>회원 상세 정보</h2>
            
            <div class="member-detail">
                <div class="status-area">
                    <span class="status ${member.enabled == '1' ? 'active' : 'inactive'}">
                        ${member.enabled == '1' ? '정상' : '잠금'}
                    </span>
                    <button onclick="toggleAccountStatus()" class="status-toggle-btn">
                        ${member.enabled == '1' ? '계정잠금' : '잠금해제'}
                    </button>
                </div>

                <div class="detail-row">
                    <span class="label">아이디</span>
                    <span class="value">${member.memberId}</span>
                </div>

                <div class="detail-row">
                    <span class="label">이름</span>
                    <span class="value">${member.name}</span>
                </div>

                <div class="detail-row">
                    <span class="label">이메일</span>
                    <span class="value">${member.email}</span>
                </div>

                <div class="detail-row">
                    <span class="label">전화번호</span>
                    <span class="value">${member.phone}</span>
                </div>

                <div class="detail-row">
                    <span class="label">주소</span>
                    <span class="value">${member.address}</span>
                </div>

                <div class="detail-row">
                    <span class="label">가입일</span>
                    <span class="value">
                        <fmt:formatDate value="${member.createdDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </span>
                </div>

                <div class="detail-row">
                    <span class="label">마지막 로그인</span>
                    <span class="value">
                        <fmt:formatDate value="${member.lastLoginDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </span>
                </div>

                <div class="detail-row">
                    <span class="label">로그인 실패 횟수</span>
                    <span class="value">${member.loginFailCount}</span>
                </div>

                <div class="button-group">
                    <button onclick="deleteMember()" class="delete-btn">회원 삭제</button>
                    <button onclick="resetPassword()" class="reset-btn">비밀번호 초기화</button>
                    <a href="<c:url value='/admin/members'/>" class="back-btn">목록으로</a>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />

    <script>
    function toggleAccountStatus() {
        const isEnabled = '${member.enabled}' === '1';
        const action = isEnabled ? 'lock' : 'unlock';
        const confirmMsg = isEnabled ? 
            '이 계정을 잠급니다. 계속하시겠습니까?' : 
            '이 계정의 잠금을 해제합니다. 계속하시겠습니까?';

        if (confirm(confirmMsg)) {
            fetch('<c:url value="/admin/member/"/>${member.memberId}/' + action, {
                method: 'POST'
            })
            .then(response => {
                if (response.ok) {
                    alert(isEnabled ? '계정이 잠금처리 되었습니다.' : '계정 잠금이 해제되었습니다.');
                    location.reload();
                } else {
                    throw new Error('처리 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }

    function deleteMember() {
        if (confirm('이 회원을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
            fetch('<c:url value="/admin/member/"/>${member.memberId}', {
                method: 'DELETE'
            })
            .then(response => {
                if (response.ok) {
                    alert('회원이 삭제되었습니다.');
                    window.location.href = '<c:url value="/admin/members"/>';
                } else {
                    throw new Error('삭제 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }

    function resetPassword() {
        if (confirm('이 회원의 비밀번호를 초기화하시겠습니까?')) {
            fetch('<c:url value="/admin/member/"/>${member.memberId}/reset-password', {
                method: 'POST'
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('비밀번호 초기화 중 오류가 발생했습니다.');
            })
            .then(data => {
                alert('비밀번호가 초기화되었습니다.\n임시 비밀번호: ' + data.temporaryPassword);
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }
    </script>
</body>
</html>