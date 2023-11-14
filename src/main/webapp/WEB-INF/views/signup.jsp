<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width"/>
    <link rel="stylesheet" href="resources/css/common/reset.css" >
    <link rel="stylesheet" href="resources/css/signup.css" >
</head>
<body>
<form action="/signup" method="post" enctype="multipart/form-data">
    <span class="header">회원가입</span>
    <div class="inputContainer">
        <label for="id">ID *</label>
        <input type="text" name="id" id="id" placeholder="ID를 입력해주세요.."  required  />
    </div>
    <div class="inputContainer">
        <label for="password">비밀번호 *</label>
        <input type="password" name="password" id="password" placeholder="비밀번호를 입력해주세요.."  required />
    </div>
    <div class="inputContainer">
        <label for="passwordcheck">비밀번호 확인 *</label>
        <input type="password" name="passwordcheck" id="passwordcheck" placeholder="비밀번호를 다시 입력해주세요.."  required />
    </div>
    <div class="inputContainer">
        <label for="name">이름 *</label>
        <input type="text" name="name" id="name" placeholder="이름을 입력해주세요.." required />
    </div>
    <div class="rowContent">
        <div class="inputContainer">
            <label for="department">소속 *</label>
            <select name="department" id="department"  required >
                <%
                    List<String> departments = (List<String>) request.getAttribute("departments");
                    for(String department : departments) {
                %>
                    <option><%= department%></option>
                <%
                    }
                %>
            </select>
        </div>
        <div class="inputContainer">
            <label for="role">직위 *</label>
            <input type="text" name="role" id="role" placeholder="직위를 입력해주세요.."  required />
        </div>
    </div>
    <div class="inputfileContainer">
        <label for="sign">사인</label>
        <input type="file" name="sign" id="sign"/>
    </div>
    <span class="serverMessage">${requestScope.message}</span>
    <input type="submit" value="회원가입"/>
</form>
</body>
</html>
