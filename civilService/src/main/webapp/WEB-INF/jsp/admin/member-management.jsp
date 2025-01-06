<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 관리</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/member-management.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    
    <main class="main-content">
        <div class="container">
            <h2>회원 관리</h2>
            
            <div class="search-form">
                <input type="text" id="searchKeyword" placeholder="회원 ID 또는 이름으로 검색">
                <button onclick="searchMembers()">검색</button>
            </div>
            
            <table class="member-table">
                <thead>
                    <tr>
                        <th>회원 ID</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>상태</th>
                        <th>로그인 실패</th>
                        <th>마지막 로그인</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${members}" var="member">
                        <tr>
                            <td>${member.memberId}</td>
                            <td>${member.name}</td>
                            <td>${member.email}</td>
                            <td>
                                <span class="status-badge ${member.enabled == '1' ? 'active' : 'locked'}">
                                    ${member.enabled == '1' ? '정상' : '잠금'}
                                </span>
                            </td>
                            <td>${member.loginFailCount}</td>
                            <td>
                                <fmt:formatDate value="${member.lastLoginDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                            <td>
                                <c:if test="${member.enabled == '0'}">
                                    <button onclick="unlockAccount('${member.memberId}')" class="unlock-btn">
                                        잠금해제
                                    </button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    
    <script>
    function unlockAccount(memberId) {
        if (confirm('해당 계정의 잠금을 해제하시겠습니까?')) {
            fetch('/admin/member/unlock', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'memberId=' + memberId
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    alert('계정 잠금이 해제되었습니다.');
                    location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('계정 잠금 해제 중 오류가 발생했습니다.');
            });
        }
    }
    
    function searchMembers() {
        const keyword = document.getElementById('searchKeyword').value;
        location.href = '/admin/members?keyword=' + encodeURIComponent(keyword);
    }
    </script>
</body>
</html>