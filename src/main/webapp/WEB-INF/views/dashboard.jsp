<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<%@ page import="java.util.List" %>
<%@ page import="com.example.leavesmanagement.entity.SessionUser" %>
<%
    List<String> leaves = (List<String>) request.getAttribute("leaves");
    pageContext.setAttribute("leaves", leaves);

    SessionUser user = (SessionUser) session.getAttribute("user");
    pageContext.setAttribute("user", user);
%>

<t:layout>
    <jsp:attribute name="script">
        <script>
            let events = [
                <c:forEach begin="0" end="${requestScope.calendarData.size()}" step="1" var="index">
                {
                    title: "${requestScope.calendarData[index].getTitle()} 연차",
                    start: "${requestScope.calendarData[index].getStart_date()}",
                    end: "${requestScope.calendarData[index].getEnd_date()}",
                    backgroundColor: "${requestScope.calendarData[index].getBackgroundColor()}",
                    textColor:"white",
                    department:"${requestScope.calendarData[index].getDepartment()}"
                },
                </c:forEach>
            ];

            function renderCalendar() {
                var calendarEl = document.getElementById('calendar');
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    fixedWeekCount: false,
                    resourceAreaWidth: "100%",
                    height:820,
                    buttonText: {
                        today: "오늘"
                    },
                    //headerToolbar: {center: 'dayGridMonth,timeGridWeek,timeGridDay,list' },
                    events: events.filter(event => {
                        if(filters[event.department]) {
                            return true;
                        }
                        return false;
                    })
                });
                calendar.render();
            }
            document.addEventListener('DOMContentLoaded', renderCalendar);
        </script>
    </jsp:attribute>
    <jsp:body>
        <div id="calendar" style="width: 100%; margin-top: 40px;">
        </div>
        <dialog class="modal_wrapper">
            <div class="modal leavesRegistContainer">
                <svg id="modalClose" xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 384 512"><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"/></svg>
                <form action="/registLeaves" method="post">
                    <span class="header">휴가 등록</span>
                    <div class="rowContent">
                        <div class="inputContainer">
                            <label for="department">소속</label>
                            <select name="department" id="department" required disabled readonly>
                                <c:forEach begin="0" end="${requestScope.departments.size() - 1}" step="1" var="idx">
                                    <c:choose>
                                        <c:when test="${requestScope.departments[idx] == sessionScope.user.getDepartment()}">
                                            <option selected >${requestScope.departments[idx]}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option>${requestScope.departments[idx]}</option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="inputContainer">
                            <label for="role">직위</label>
                            <input type="text" name="role" id="role" placeholder="직위를 입력해주세요.."  required value="${sessionScope.user.getRole()}" disabled readonly/>
                        </div>
                    </div>
                    <div class="inputContainer">
                        <label for="name">이름</label>
                        <input type="text" name="name" id="name" placeholder="이름을 입력해주세요.."  required value="${sessionScope.user.getName()}"  disabled readonly/>
                    </div>
                    <div class="inputContainer">
                        <label for="start_date">휴가 출발 일자</label>
                        <input type="date" name="start_date" id="start_date" required />
                    </div>
                    <div class="inputContainer">
                        <label for="end_date">휴가 복귀 일자</label>
                        <input type="date" name="end_date" id="end_date" required />
                    </div>
                    <div class="inputContainer typeContainer">
                        <label>휴가 구분</label>
                        <div class="rowContent">
                            <select name="type" id="type" required>
                                <c:forEach begin="0" end="${requestScope.types.size() - 1}" step="1" var="idx">
                                        <option>${requestScope.types[idx]}</option>
                                </c:forEach>
                                <option>기타</option>
                            </select>
                            <input type="text" name="type_text" id="type_text" placeholder="기타 사유 입력" disabled />
                        </div>
                    </div>
                    <div class="inputContainer">
                        <label for="desc">사유</label>
                        <textarea id="desc" name="desc"placeholder="사유를 입력해 주세요..."></textarea>
                    </div>
                    <span class="serverMessage">${requestScope.message}</span>
                    <input type="submit" value="휴가 신청"/>
                </form>
            </div>
        </dialog>
        <script>
            const closeBtn = document.getElementById("modalClose");
            const modal = document.querySelector(".modal_wrapper");

            closeBtn.addEventListener('click', () => {
                modal.attributes.removeNamedItem("open");
            })

            const typeSelect = document.getElementById("type");
            const elseInput = document.getElementById("type_text");
            typeSelect.addEventListener('input', () => {
                if (typeSelect.value === "기타") {
                    elseInput.removeAttribute("disabled");
                    elseInput.setAttribute("required", "");
                } else {
                    elseInput.value = "";
                    elseInput.setAttribute("disabled", "");
                    elseInput.removeAttribute("required");
                }
            })
        </script>
    </jsp:body>
</t:layout>