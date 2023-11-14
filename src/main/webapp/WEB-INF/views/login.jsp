<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width"/>
    <link rel="stylesheet" href="resources/css/common/reset.css" >
    <link rel="stylesheet" href="resources/css/login.css" >
</head>
<body>
    <form action="/login" method="post">
        <span class="header">로그인</span>
        <div class="inputContainer">
            <label for="id">ID</label>
            <input type="text" name="id" id="id" placeholder="ID를 입력해주세요.."/>
        </div>
        <div class="inputContainer">
            <label for="password">비밀번호</label>
            <input type="password" name="password" id="password" placeholder="비밀번호를 입력해주세요.."/>
        </div>
        <span class="serverMessage">${requestScope.message}</span>
        <input type="submit" value="로그인"/>
    </form>
    <a class="signupSubmit" href="/signup"><span>회원가입</span></a>
</body>
</html>
