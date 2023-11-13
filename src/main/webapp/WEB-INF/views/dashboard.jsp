<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<%@ page import="java.util.List" %>
<%@ page import="com.example.leavesmanagement.entity.Leaves" %>
<%
    List<String> leaves = (List<String>) request.getAttribute("leaves");
    pageContext.setAttribute("leaves", leaves);
%>

<t:layout>
    <jsp:attribute name="script">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var calendarEl = document.getElementById('calendar');
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    fixedWeekCount: false,
                    resourceAreaWidth: "100%",
                    height:820,
                    buttonText: {
                        today: "오늘"
                    },
                    events:[
                        <c:forEach begin="0" end="${requestScope.calendarData.size()}" step="1" var="index">
                        {
                            title: "${requestScope.calendarData[index].getTitle()} 연차",
                            start: "${requestScope.calendarData[index].getStart_date()}",
                            end: "${requestScope.calendarData[index].getEnd_date()}",
                            backgroundColor: "${requestScope.calendarData[index].getBackgroundColor()}",
                            textColor:"white"
                        },
                        </c:forEach>

                    ]
                });
                calendar.render();
            });
        </script>
    </jsp:attribute>
    <jsp:body>
        <div id="calendar" style="width: 100%; margin-top: 40px;">
        </div>
    </jsp:body>
</t:layout>