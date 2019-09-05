<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>    
<%
    // content.jsp는 하나의 레코드의 내용을 전부 보여준다
    // DB연결
    String aa = "jdbc:mysql://localhost:3307/amudo?useSSL=false";
	String bb = "root";
	String cc = "1234";
	Connection conn = DriverManager.getConnection(aa, bb, cc);
	Statement stmt = conn.createStatement();
	
	// 읽어오고자 하는 레코드의 id, page값을 받기
	String id = request.getParameter("id");
	String Page = request.getParameter("page");
	
	// 쿼리작성 => 하나의 레코드만 읽어오는 쿼리
	String sql = "select * from qna where id="+id;
	  
	// select한 결과값을 사용하려고 하면 ResultSet에 가져와야 된다.
	ResultSet rs = stmt.executeQuery(sql);
	
	// 하나의 레코드만 읽어온다..
	rs.next();
%>	
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
<!-- 비밀번호 입력폼을 숨겼다가 위의 삭제를 클릭하면 보이기 -->
<script>
    function view_form(n) {
    	var dd = document.getElementsByClassName("del.form");
    	dd[n].style.display="inline";
    }
    function up_form(aa,bb,cc) {
    	document.getElementById("up_form").style.visibility="visible";
    	document.up_form.name.value=aa;
    	bb = bb.replace(/<br>/gi,"\r\n");
    	document.up_form.content.value=bb;
    	document.up_form.id.value=cc;
    }
	function check(pp) {
		if(pp.name.value == "") {
			alert("이름을 적어주세요");
			pp.name.focus();
			return false;
		}
		else if(pp.content.value == "") {
			alert("내용을 적어주세요");
			pp.content.focus();
			return false;
		}
		else if(pp.pwd.value == "") {
			alert("비밀번호를 적어주세요");
			pp.pwd.focus();
			return false;
		}
		else 
			return true;
	}
	function del() { // 비밀번호 입력폼을 보이게 하기
		document.getElementById("delete").style.display = "block";
	}
	function hide() {
		document.getElementById("delete").style.display = "none";
	}
</script>
<style>
a {
	text-decoration: none;
	color: black;
}
#del_form {
    display:inline;
    display:none;
}
#up_form {
    position:absolute;
}
</style>
</head>
<body>
	<!-- 이름, 제목, 내용, 조회수, 작성일, 나이, 성별 -->
	<table width="600" border="1" cellspacing="0">
		<tr>
			<td>제목</td>
			<td colspan="3"><%=rs.getString("title")%></td>
		</tr>
		<tr>
			<td>이름</td>
			<td><%=rs.getString("name")%></td>
			<td>조회수</td>
			<td><%=rs.getString("rnum")%></td>
		</tr>
		<tr height="200">
			<td>내용</td>
			<td colspan="3"><%=rs.getString("content").replace("\r\n","<br>")%></td>
		</tr>
		<%
			String age = "";
			switch (rs.getInt("age")) { // 10대 ~50대 => 0,1,2,3,4
			case 0: age = "10대"; break;
			case 1: age = "20대"; break;
			case 2: age = "30대"; break;
			case 3:	age = "40대"; break;
			case 4:	age = "50대"; break;
			}

			String sung;
			if (rs.getInt("sung") == 0) // 0이면 남자, 1이면 여자
				sung = "남자";
			else
				sung = "여자";
		%>
		<tr>
			<td>나이</td>
			<td><%=age%></td>
			<td>성별</td>
			<td><%=sung%></td>
		</tr>
		<tr>
			<td>작성일</td>
			<td colspan="3"><%=rs.getString("writeday")%></td>
		</tr>
		<tr>
			<td colspan="4" align="center">
			<a href="update.jsp?id=<%=id%>">수정</a> 
			<a href="javascript:del()">삭제</a> 
			<a href="list.jsp?page=<%=Page%>">목록</a>
			<a href="rewrite.jsp?ref=<%=rs.getInt("ref")%>&depth=<%=rs.getInt("depth")%>&seq=<%=rs.getInt("seq")%>">댓글달기</a></td>
		</tr>
	</table>

	<!-- 댓글출력 -->
	<%
	// 쿼리 작성(댓글)
	sql = "select * from dat where b_id="+id+" order by id desc";
	rs = stmt.executeQuery(sql);
	%>
	<table width="600"><!-- <tr>하나에 댓글하나 -->
	<%
	int ckk = 0;
	while(rs.next()) { // 레코드가 있을때 반복문 실행
	%>
	<tr>
	<td style="border:1px solid black">
	댓글목록 
	<%
	String a,b,c;
	a = rs.getString("name");
	b = rs.getString("content").replace("\r\n","<br>");
	c = rs.getString("id");
	%>
	<div style="float:right">
	<a href="javascript:up_form('<%=a%>','<%=b%>',<%=c%>)">수정</a>
	<!-- 삭제를 클릭하면 댓글을 삭제 (값) => dat테이블 => id,pwd --> 
	<a href="javascript:view_form(<%=ckk%>)">삭제</a>
	</div >
	<div>
	<form id="del_form" class="del_form" method="post" action="dat_delete.jsp" style="display:inline">
	<input type="hidden" name="id" value=<%=rs.getString("id")%>>
	<input type="password" name="pwd" placeholder="비밀번호" size="6">
	<input type="submit" value="삭제"> 
	</form>
	</div>
	<hr>
	<%=rs.getString("name")%> 작성일 <%=rs.getString("writeday")%><p>
	<%=b%>
	</td>
	</tr>
	<%
	ckk++;
	}
	%>
	</table>
	<table width="600">
	<!-- 댓글 수정폼 시작 -->
	<form name="up_form" id="up_form" method="post" action="dat_update_ok.jsp">
	<input type="hidden" name="id">
	이름<input type="text" name="name" size="6"><p>
	내용<textarea col="40" rows="3" name="content"></textarea><p>
	비밀번호<input type="password" name="pwd" placeholder="비밀번호" size="6">
	<input type="submit" value="수정"> 
	</form>
	<!-- 댓글 수정폼 끝 -->
	<!-- 댓글 입력폼 -->
	<tr>
	<td><form method="post" action="dat_ok.jsp" onsubmit="return check()">
	    <input type="hidden" name="b_id" value=<%=id%>>
	    <input type="hidden" name="page" value=<%=Page%>>
		이름<input type="text" name="name" size="7" maxlength="10"><p>
		내용<textarea rows="3" cols="40" name="content" maxlength="100"></textarea><p>
		비밀번호<input type="password" name="pwd" maxlength="10"><p>
		<input type="submit" value="댓글작성">
	</form></td>
	</tr>
	</table>

	<div id="delete" style="display: none">
		<form method="post" action="delete_ok.jsp">
		    <!-- id, page 값 전달 -->
			<input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="page" value="<%=Page%>"> 
			비밀번호 <input type="password" name="pwd"> 
			<input type="submit" value="삭제하기">
			<input type="button" onclick="hide()" value="취소"> 
		</form>
	</div>

</body>
</html>