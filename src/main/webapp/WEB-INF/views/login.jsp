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
    <form>
        <span class="header">로그인</span>
        <div class="inputContainer">
            <label for="email">Email</label>
            <input type="text" id="email"/>
        </div>
        <div class="inputContainer">
            <label for="password">비밀번호</label>
            <input type="password" id="password"/>
        </div>
        <input type="submit" value="로그인"/>
    </form>
    <a><span>회원가입</span></a>
</body>
</html>
