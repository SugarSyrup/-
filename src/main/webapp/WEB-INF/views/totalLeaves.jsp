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
        <link rel="stylesheet" href="resources/css/table.css" >
        <link rel="stylesheet" href="resources/css/users.css" >
    </jsp:attribute>
    <jsp:attribute name="script">

    </jsp:attribute>
    <jsp:body>
        <t:modal>
        </t:modal>
    </jsp:body>
</t:layout>