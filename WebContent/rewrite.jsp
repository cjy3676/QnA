<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<% 
    // ref, depth, seq라는 값이 넘어온다
    String ref = request.getParameter("ref");
    // depth는 직접 밑에 출력
    String seq = request.getParameter("seq");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body> <!-- 질문 글 쓰기 -->
    <h3>답글 달기</h3>
	<form method="post" action="rewrite_ok.jsp">
	    <input type="hidden" name="ref" value=<%=ref%>>
	    <input type="hidden" name="depth" value=<%=request.getParameter("depth")%>>
	    <input type="hidden" name="seq" value=<%=seq%>>
		제목<input type="text" name="title" size="50"><p>
		내용<textarea rows="6" cols="50" name="content"></textarea><p>
		작성자<input type="text" name="name" size="8"><p>
		연령<select name="age">
			<option value="0">10대</option>
			<option value="1">20대</option>
			<option value="2">30대</option>
			<option value="3">40대</option>
			<option value="4">50대</option>
		   </select><p>
		성별 
		<input type="radio" name="sung" value="0">남자 
		<input type="radio" name="sung" value="1">여자<p>
		비밀번호<input type="password" name="pwd"><p>
		<input type="submit" value="글작성">
	</form>
</body>
</html>