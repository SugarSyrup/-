<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="isLogin" type="java.lang.Boolean" %>
<%@ attribute name="isAdmin" type="java.lang.Boolean" %>
<%@ attribute name="isDashboard" type="java.lang.Boolean" %>

<%@ tag import="java.util.List" %>
<%
    List<String> departments = (List<String>) request.getAttribute("departments");
%>

<div class="sidebar">
    <c:choose>
        <c:when test="${isDashboard}">
            <div class="filter">
                <span class="title">필터</span>
                <% for(String deparment : departments) { %>
                <div>
                    <input type="checkbox" id=<%=deparment%> name=<%=deparment%> class="filterInput" checked>
                    <label for=<%=deparment%> ><span><%= deparment %></span></label>
                </div>
                <% } %>
            </div>
        </c:when>
        <c:otherwise>
            <a href="/" class="back"><span>🔙 캘린더로 돌아가기</span></a>
        </c:otherwise>
    </c:choose>
    <div>
        <c:if test="${isAdmin}">
            <div class="userFeatureContainer">
                <a href="/users"><span>회원 관리</span></a>
                <a><span>공통 코드 관리</span></a>
                <a><span>전체 휴가 관리</span></a>
            </div>
        </c:if>
        <div class="userFeatureContainer">
            <a><span>내 정보</span></a>
            <a><span>휴가 내역</span></a>
            <a id="leavesRegistBtn"><span>휴가 등록</span></a>
            <a class="logout" href="/logout"><span>로그아웃</span></a>
            <c:if test="${!isLogin}">
                <div class="blurBox">
                    <a class="loginButton" href="/login">로그인 / 회원가입</a>
                </div>
            </c:if>
        </div>
    </div>
</div>
<script>
    const filterInputs = document.querySelectorAll(".filterInput");
    Window.prototype.filters = {};
    filterInputs.forEach(filterinput => {
        filters[filterinput.name] = filterinput.checked;
        filterinput.addEventListener('input', () => {
            filters[filterinput.name] = filterinput.checked;
            renderCalendar();
        })
    })

    document.getElementById("leavesRegistBtn").addEventListener('click', () => {
        document.querySelector(".modal_wrapper").open = true;
    });
</script>