<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.leavesmanagement.entity.SessionUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width"/>
    <link rel="stylesheet" href="resources/css/common/reset.css" >
    <link rel="stylesheet" href="resources/css/useredit.css" >
</head>
<body>
<form action="/user-edit" method="post" enctype="multipart/form-data">
    <span class="header">내 정보</span>
    <input type="text" name="userno" value="${sessionScope.user.user_no}" style="display:none;" />
    <div class="inputContainer">
        <div style="width:100%; display:flex; justify-content: space-between">
            <label for="id">ID *</label>
            <label>* 수정 불가</label>
        </div>
        <input type="text" name="id" id="id" placeholder="ID를 입력해주세요.." required  readonly value="${sessionScope.user.id}" />
    </div>
    <div class="inputContainer">
        <label for="password">비밀번호</label>
        <input type="password" name="password" id="password" placeholder="비밀번호를 입력해주세요.." />
    </div>
    <div class="inputContainer">
        <label for="passwordcheck">비밀번호 확인</label>
        <input type="password" name="passwordcheck" id="passwordcheck" placeholder="비밀번호를 다시 입력해주세요.." />
    </div>
    <div class="inputContainer">
        <label for="name">이름 *</label>
        <input type="text" name="name" id="name" placeholder="이름을 입력해주세요.." required value="${sessionScope.user.name}" />
    </div>
    <div class="rowContent">
        <div class="inputContainer">
            <label for="department">소속 *</label>
            <select name="department" id="department"  required >
                <c:forEach var="idx" step="1" begin="0" end="${requestScope.departments.size() - 1}">
                    <c:choose>
                        <c:when test="${sessionScope.user.department.equals(requestScope.departments.get(idx))}">
                            <option selected>${requestScope.departments.get(idx)}</option>
                        </c:when>
                        <c:otherwise>
                            <option>${requestScope.departments.get(idx)}</option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </div>
        <div class="inputContainer">
            <label for="role">직위 *</label>
            <input type="text" name="role" id="role" placeholder="직위를 입력해주세요.."  required value="${sessionScope.user.role}"/>
        </div>
    </div>
    <div class="inputfileContainer">
        <label for="sign" >사인</label>
        <input type="file" name="sign" id="sign" />
    </div>
        <span class="serverMessage">${requestScope.message}</span>
    <input type="submit" value="수정하기" style="margin-top:-30px;"/>
</form>
<a href="/"><button style="margin-top:20px;">홈 으로</button></a>
</body>
</html>
