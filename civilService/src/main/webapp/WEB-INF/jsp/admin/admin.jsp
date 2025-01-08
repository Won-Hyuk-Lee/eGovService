<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
<link rel="stylesheet" href="<c:url value='/css/admin/admin.css'/>">
</head>
<body>
	<!-- 공통 헤더 포함 -->
	<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

	<main class="main-content">
		<div class="container">
			<!-- 관리자 메뉴 탭 -->
			<div class="admin-tabs">
				<a href="<c:url value='/admin/members'/>"
					class="tab ${activeTab == 'members' ? 'active' : ''}">회원 관리</a> <a
					href="<c:url value='/admin/complaints'/>"
					class="tab ${activeTab == 'complaints' ? 'active' : ''}">민원 관리</a>
			</div>

			<div class="content-area">
				<c:choose>
					<%-- 회원 관리 탭 내용 --%>
					<c:when test="${activeTab == 'members'}">
						<table class="data-table">
							<thead>
								<tr>
									<th>ID</th>
									<th>이름</th>
									<th>이메일</th>
									<th>상태</th>
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
										<td><span
											class="status ${member.enabled == '1' ? 'active' : 'inactive'}">
												${member.enabled == '1' ? '정상' : '비활성'} </span></td>
										<td><fmt:formatDate value="${member.lastLoginDate}"
												pattern="yyyy-MM-dd HH:mm:ss" /></td>
										<td class="action-buttons">
											<button onclick="viewComplaints('${member.memberId}')"
												class="btn-view">민원보기</button>
											<button
												onclick="showMemberManageModal('${member.memberId}', '${member.name}', '${member.enabled}')"
												class="btn-manage">회원관리</button>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</c:when>

					<%-- 민원 관리 탭 내용 --%>
					<c:when test="${activeTab == 'complaints'}">
						<table class="data-table">
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
									<tr
										onclick="location.href='<c:url value="/complaint/view/${complaint.complaintId}"/>'">
										<td>${complaint.complaintId}</td>
										<td>${complaint.title}</td>
										<td>${complaint.memberName}</td>
										<td><span
											class="status ${complaint.status.toLowerCase()}">
												${complaint.statusName} </span></td>
										<td><fmt:formatDate value="${complaint.createdDate}"
												pattern="yyyy-MM-dd HH:mm:ss" /></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</c:when>
				</c:choose>

				<!-- 페이징 처리 -->
				<div class="pagination">
					<c:if test="${currentPage > 1}">
						<a href="?page=${currentPage - 1}" class="page-link">이전</a>
					</c:if>

					<c:forEach begin="1" end="${totalPages}" var="pageNum">
						<a href="?page=${pageNum}"
							class="page-link ${pageNum == currentPage ? 'active' : ''}">
							${pageNum} </a>
					</c:forEach>

					<c:if test="${currentPage < totalPages}">
						<a href="?page=${currentPage + 1}" class="page-link">다음</a>
					</c:if>
				</div>
			</div>
		</div>
	</main>

	<!-- 회원관리 모달 -->
	<div id="memberManageModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>
			<h2>회원 관리</h2>
			<div class="modal-body">
				<h3 id="modalMemberName"></h3>
				<div class="button-group">
					<button onclick="toggleAccountStatus()" id="toggleStatusBtn"
						class="btn">계정 상태 변경</button>
					<button onclick="resetPassword()" class="btn">비밀번호 초기화</button>
					<button onclick="deleteMember()" class="btn btn-danger">회원
						탈퇴처리</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 공통 푸터 포함 -->
	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />

	<!-- JavaScript 코드 -->
	<script>
    // 현재 선택된 회원 정보를 저장할 변수
    let currentMemberId = '';
    let currentMemberStatus = '';

    // 해당 회원의 민원 목록 조회
    function viewComplaints(memberId) {
        location.href = '<c:url value="/admin/complaints"/>?memberId=' + memberId;
    }

    // 회원 관리 모달 표시
    function showMemberManageModal(memberId, memberName, status) {
        currentMemberId = memberId;
        currentMemberStatus = status;
        const modal = document.getElementById('memberManageModal');
        document.getElementById('modalMemberName').textContent = memberName + ' 님';
        
        // 상태에 따라 버튼 텍스트 변경
        const toggleBtn = document.getElementById('toggleStatusBtn');
        toggleBtn.textContent = status === '1' ? '계정 잠금' : '계정 잠금 해제';
        
        modal.style.display = 'block';
    }

    // 모달 닫기 버튼 이벤트
    document.getElementsByClassName('close')[0].onclick = function() {
        document.getElementById('memberManageModal').style.display = 'none';
    }

    // 모달 외부 클릭시 닫기
    window.onclick = function(event) {
        const modal = document.getElementById('memberManageModal');
        if (event.target == modal) {
            modal.style.display = 'none';
        }
    }

    // 계정 상태 변경 (잠금/해제)
    function toggleAccountStatus() {
        const action = currentMemberStatus === '1' ? 'lock' : 'unlock';
        const confirmMessage = action === 'lock' ? 
            '이 회원의 계정을 잠그시겠습니까?' : 
            '이 회원의 계정 잠금을 해제하시겠습니까?';
        
        if (confirm(confirmMessage)) {
            fetch('<c:url value="/admin/member/status"/>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `memberId=${currentMemberId}&action=${action}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(action === 'lock' ? '계정이 잠금처리 되었습니다.' : '계정 잠금이 해제되었습니다.');
                    location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('처리 중 오류가 발생했습니다.');
            });
        }
    }

    // 비밀번호 초기화
    function resetPassword() {
        if (confirm('이 회원의 비밀번호를 초기화하시겠습니까?')) {
            fetch('<c:url value="/admin/member/reset-password"/>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `memberId=${currentMemberId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(`비밀번호가 초기화되었습니다.\n임시 비밀번호: ${data.temporaryPassword}`);
                    document.getElementById('memberManageModal').style.display = 'none';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('처리 중 오류가 발생했습니다.');
            });
        }
    }

    // 회원 탈퇴처리
    function deleteMember() {
        if (confirm('이 회원을 탈퇴처리하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
            fetch('<c:url value="/admin/member/delete"/>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `memberId=${currentMemberId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('회원이 탈퇴처리 되었습니다.');
                    location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('처리 중 오류가 발생했습니다.');
            });
        }
    }
    </script>
</body>
</html>