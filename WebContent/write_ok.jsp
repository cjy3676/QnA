<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.sql.*" %>      
<%@page import="java.util.Date" %>  <!-- 날짜를 구하기 -->
<%@page import="java.text.SimpleDateFormat"%> <!-- YYYY-MM-DD 형식을 위해 -->
<%
   String aa="jdbc:mysql://localhost:3307/amudo?useSSL=false";
   String bb="root";
   String cc="1234";
   Connection conn = DriverManager.getConnection(aa,bb,cc);
   Statement stmt=conn.createStatement();

   request.setCharacterEncoding("utf-8");

   String title=request.getParameter("title");
   String content=request.getParameter("content");
   String name=request.getParameter("name");
   String age=request.getParameter("age");
   String sung=request.getParameter("sung");
   String pwd=request.getParameter("pwd");

   Date today=new Date(); 
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
   String writeday= sdf.format(today); 

   String sql="select max(ref) as num from qna";
   ResultSet rs=stmt.executeQuery(sql);
   rs.next();
   String ref=""+(rs.getInt("num")+1);

   sql="insert into qna(title,content,name,age,sung,pwd,rnum,writeday,ref,depth,seq) ";
   sql=sql+" values(?,?,?,?,?,?,?,?,?,?,?)";

   PreparedStatement pstmt=conn.prepareStatement(sql);
   pstmt.setString(1,title);
   pstmt.setString(2,content);
   pstmt.setString(3,name);
   pstmt.setString(4,age);
   pstmt.setString(5,sung);
   pstmt.setString(6,pwd);
   pstmt.setString(7,"0");
   pstmt.setString(8,writeday);
   pstmt.setString(9,ref);  // ref
   pstmt.setString(10,"1");  // depth
   pstmt.setString(11,"1");  // seq
   
   pstmt.executeUpdate();
   
   stmt.close();
   pstmt.close();
   conn.close();
%>    
<script>
  location="list.jsp";
</script>
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 