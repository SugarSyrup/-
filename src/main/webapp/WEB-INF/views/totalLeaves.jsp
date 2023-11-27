<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<%@ page import="com.example.leavesmanagement.entity.SessionUser" %>
<%
    SessionUser user = (SessionUser) session.getAttribute("user");
    pageContext.setAttribute("user", user);
%>

<t:layout>
    <jsp:attribute name="styles">
        <link rel="stylesheet" href="resources/css/leaves.css" >
    </jsp:attribute>
    <jsp:attribute name="script">
        <script>
            const leavesPrintBtns = document.getElementsByClassName("leavePrint");
            const printWrapper = document.querySelector(".printWrapper");

            for(let  i = 0; i<leavesPrintBtns.length; i++) {
                leavesPrintBtns[i].addEventListener('click', () => {
                    let leave = {};
                    leavesPrintBtns[i].dataset.leave.slice(7,-1).split(",").forEach((item) => {
                        leave[item.split("=")[0].trim()] = item.split("=")[1];
                    });

                    printWrapper.querySelector(".signname").innerText = "${sessionScope.user.name}";
                    printWrapper.querySelector(".department").innerText = "${sessionScope.user.department}";
                    printWrapper.querySelector(".role").innerText = "${sessionScope.user.role}";
                    printWrapper.querySelector(".name").innerText = "${sessionScope.user.name}";
                    printWrapper.querySelector(".startTime").innerText = leave["start_date"].split("-")[0] + " " + leave["start_date"].split("-")[1] + " " + leave["start_date"].split("-")[2];
                    printWrapper.querySelector(".endTime").innerText =  leave["end_date"].split("-")[0] + " " + leave["end_date"].split("-")[1] + " " + leave["end_date"].split("-")[2];
                    printWrapper.querySelector(".type").innerText = leave["type"];
                    printWrapper.querySelector(".dates").innerText = leave["dates"];
                    printWrapper.querySelector(".desc").innerText = leave["desc"];

                    const today = new Date();

                    printWrapper.querySelector(".signdates").innerText = today.getFullYear() + " " + today.getMonth() + " " + today.getDate();
                    printWrapper.querySelector("img").src = leave["sign"];
                    window.print();
                })
            }

             const yearSelect = document.querySelector(".leavesYearSelect");
            yearSelect.addEventListener('input', () => {
                const data = {
                    value : yearSelect.value,
                }

                fetch("http://" + window.location.host + "/setLeavesYear", {
                    method:"post",
                    headers: {
                        "Content-Type":"application/json",
                    },
                    redirect:"follow",
                    body: JSON.stringify(data),
                }).then((response) => location.href = "/totalLeaves");
            })
        </script>
    </jsp:attribute>
    <jsp:body>
        <main class="no-print">
            <div class="headerContainer">
                <span class="title">휴가 내역</span>
                <span class="subTitle">총 사용 휴가 일수 : ${requestScope.useDays} 일</span>
            </div>
            <div class="table_wrapper">
                <table class="leavesTable">
                    <thead>
                    <tr>
                        <th>기간</th>
                        <th>휴가 종류</th>
                        <th>
                            <select class="leavesYearSelect">
                                <c:forEach begin="2020" end="2030" step="1" var="value">
                                    <c:choose>
                                        <c:when test="${requestScope.year == value}">
                                            <option name="${value}" value="${value}" selected>${value}년</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option name="${value}" value="${value}">${value}년</option>
                                        </c:otherwise>
                                    </c:choose>

                                </c:forEach>
                            </select>
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${requestScope.leaves.size() != 0}">
                        <c:forEach begin="0" step="1" end="${requestScope.leaves.size() - 1}" var="leavesIdx">
                            <tr class="active" data-start="${requestScope.leaves.get(leavesIdx).start_date}" data-end="${requestScope.leaves.get(leavesIdx).end_date}" data-days="${requestScope.leaves.get(leavesIdx).dates}">
                                <td>${requestScope.leaves.get(leavesIdx).start_date} ~ ${requestScope.leaves.get(leavesIdx).end_date} (${requestScope.leaves.get(leavesIdx).dates}일)</td>
                                <td>${requestScope.leaves.get(leavesIdx).type}</td>
                                <td>
                                    <span class="leavePrint" data-leave="${requestScope.leaves.get(leavesIdx)}">휴가 내역 출력</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </main>
        <div class="printWrapper">
            <div class="signnameWrapper printTextWrapper">
                <span class="signname printText">관리관리자</span>
            </div>
            <div class="departmentWrapper printTextWrapper">
                <span class="department printText">정보화 서비스팀</span>
            </div>
            <div class="roleWrapper printTextWrapper">
                <span class="role printText">1111</span>
            </div>
            <div class="nameWrapper printTextWrapper">
                <span class="name printText">관리관리자</span>
            </div>
            <span class="startTime">2023 11 01</span>
            <span class="endTime">2012 11 04</span>
            <span class="dates">2</span>
            <span class="type">연차</span>
            <div class="desc">
                <span>개인사유</span>
            </div>
            <span class="signdates">2012 10 27</span>
            <span class="undersignname">홍길동</span>
            <img src="upload/Cookie.png" class="imgfile">
        </div>
    </jsp:body>
</t:layout>