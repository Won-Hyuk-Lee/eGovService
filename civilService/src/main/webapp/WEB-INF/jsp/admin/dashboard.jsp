<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="<c:url value='/css/common/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/dashboard.css'/>">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    
    <main class="main-content">
        <div class="container">
            <div class="admin-menu">
                <a href="<c:url value='/admin/members'/>" class="btn">회원 관리</a>
            </div>
            
            <h2>민원 통계 대시보드</h2>
            
            <div class="stats-grid">
                <div class="stats-card">
                    <h3>처리상태별 현황</h3>
                    <canvas id="statusChart"></canvas>
                </div>
                
                <div class="stats-card">
                    <h3>월별 민원 추이</h3>
                    <canvas id="monthlyChart"></canvas>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    
    <script>
    // 차트 객체를 저장할 변수
    let statusChart = null;
    let monthlyChart = null;

    // 데이터를 직접 가져오기
    const statusData = ${statusStatsJson};
    const monthlyData = ${monthlyStatsJson};

    // 기존 차트 제거
    function destroyCharts() {
        if (statusChart) statusChart.destroy();
        if (monthlyChart) monthlyChart.destroy();
    }

    // 차트 초기화
    function initializeCharts() {
        destroyCharts();

        const statusChartCtx = document.getElementById('statusChart').getContext('2d');
        const monthlyChartCtx = document.getElementById('monthlyChart').getContext('2d');

        // 처리상태별 통계
        statusChart = new Chart(statusChartCtx, {
            type: 'pie',
            data: {
                labels: statusData.map(item => item.statusName),
                datasets: [{
                    data: statusData.map(item => item.count),
                    backgroundColor: [
                        '#ffc107', // 접수대기
                        '#007bff', // 처리중
                        '#28a745', // 처리완료
                        '#dc3545'  // 반려
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // 월별 통계
        monthlyChart = new Chart(monthlyChartCtx, {
            type: 'bar',
            data: {
                labels: monthlyData.map(item => item.month),
                datasets: [{
                    label: '민원 건수',
                    data: monthlyData.map(item => item.count),
                    backgroundColor: '#007bff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }

    // 차트 초기화 실행
    document.addEventListener('DOMContentLoaded', initializeCharts);
    </script>
</body>
</html>