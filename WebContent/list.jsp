<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.sql.*" %>      
<%
   String aa="jdbc:mysql://localhost:3307/amudo?useSSL=false";
   String bb="root";
   String cc="1234";
   Connection conn = DriverManager.getConnection(aa,bb,cc); 
   Statement stmt=conn.createStatement();

   int start;
   int Page;  
   if(request.getParameter("page")==null) {
     start=0; 
     Page=1;
   }
   else {
    Page=Integer.parseInt(request.getParameter("page")); 
    start=(Page-1)*10; 
   }
    String sql="select * from qna order by ref desc, seq asc limit "+start+",10";
    ResultSet rs=stmt.executeQuery(sql);
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
  <script>
    function move_list(val) {
    	location="list.jsp?page="+val;
    }
    function select_init() {  
       document.getElementById("pp").value=<%=Page%>;
    }
    select_init();
    </script>
 <style>
   a {
     text-decoration:none;
     color:black;
   } 
   a:hover {
     text-decoration:underline;
     color:green;
   }
 </style>
</head>
<body>
	<table align="center" width="600" border="1" cellspacing="0">
		<caption>
			<h2>게시판</h2>
		</caption>
		<tr height="30" align="center">
			<td>이름</td>
			<td>제목</td>
			<td>조회수</td>
			<td>작성일</td>
			<td>ref</td>
			<td>depth</td>
			<td>seq</td>
		</tr>
	<%
     while(rs.next()) {
    %>
		<tr height="20">
			<td align="center"><%=rs.getString("name")%></td>
			<td>
			<!-- depth의 크기만큼 빈칸을 추가한다면 빈칸 => &nbsp; -->
			<%
			for(int i=1; i<rs.getInt("depth"); i++) {
			%>
			  &nbsp;&nbsp;
			<%
			}
			%>
			<%
			if(rs.getInt("depth") != 1) {
			%>
			==▶ 
			<%	
			}
			%><a href="content.jsp?id=<%=rs.getString("id")%>&page=<%=Page%>"><%=rs.getString("title")%></a></td>
			<td align="center"><%=rs.getString("rnum")%></td>
			<td align="center"><%=rs.getString("writeday")%></td>
			<td align="center"><%=rs.getString("ref")%></td>
			<td align="center"><%=rs.getString("depth")%></td>
			<td align="center"><%=rs.getString("seq")%></td>
		</tr>
		<%
         } 
        %>
		<tr>
			<td colspan="7" align="right"><a href="write.jsp"> 글쓰기 </a></td>
		</tr>
		<tr>
			<td colspan="7" align="center" style="word-spacing: 10px">
				<%
     int pstart;
     int pend;

     sql="select count(id) as cnt from qna";
     rs=stmt.executeQuery(sql);
     rs.next();
     int total_record=rs.getInt("cnt"); 
     // 레코드수를 가지고 페이지 계산하기
     int page_cnt=total_record/10; 
     if(total_record%10 != 0)
    	 page_cnt=page_cnt+1;  

     pstart=(int)Page/10;

     if(Page%10 == 0) 
    	 pstart=pstart-1;
     pstart=Integer.parseInt(pstart+"1");
     pend=pstart+9; 
     
     if(pend > page_cnt) 
        pend=page_cnt;  
  %> <a href="list.jsp?page=1"> 처음 </a> <%
   if(pstart == 1)
   {
  %> ◀◀ <%
   }
   else
   {
  %> <a href="list.jsp?page=<%=pstart-1%>"> ◀◀ </a> <%
   }
  %> <%
    if(Page != 1) 
    {
  %> <a href="list.jsp?page=<%=(Page-1)%>"> ◀ </a> <% 
    }
    else
    {
  %> ◀ <%  	
    }
     String color="";
     for(int i=pstart;i<=pend;i++)
     {
    	 if(Page == i) 
    		 color="style='color:red'";
    	 else
    		 color="";
  %> <a href="list.jsp?page=<%=i%>" <%=color%>> <%=i%>
			</a> <%
     }
     
 
  %> <%
     if(Page != page_cnt)
     {
  %> <a href="list.jsp?page=<%=Page+1%>"> ▶ </a> <%
     }
     else 
     {
  %> ▶ <%
     }
  %> <%
      if(pend == page_cnt)
      {
    %> ▶▶ <%
      }
      else
      {
    %> <a href="list.jsp?page=<%=pend+1%>"> ▶▶ </a> <%
      }
    %> <a href="list.jsp?page=<%=page_cnt%>"> 끝 </a> 
    <select id=pp onchange=move_list(this.value)>
	<%
      for(int i=1;i<=page_cnt;i++){
    %>
	<option value=<%=i%>> <%=i%>page </option>
	<%
      }
    %>
    </select>
	</td>
	</tr>
	</table>
</body>
</html>
<%
  rs.close();
  stmt.close();
  conn.close();
%>












