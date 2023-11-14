<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ attribute name="script" fragment="true" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width"/>
        <link rel="stylesheet" href="resources/css/common/reset.css" >
        <link rel="stylesheet" href="resources/css/layout.css" >
        <link rel="stylesheet" href="resources/css/fullcalendar.css" >
        <script src="resources/js/lib/jquery-3.7.1.js"></script>
        <script src="resources/js/lib/fullcalendar-6.1.9.js"></script>
    </head>
    <body>
        <t:sidebar isLogin="${sessionScope.isLogin}" isAdmin="${sessionScope.isAdmin}"/>
        <jsp:doBody/>
        <jsp:invoke fragment="script"/>
    </body>
</html>