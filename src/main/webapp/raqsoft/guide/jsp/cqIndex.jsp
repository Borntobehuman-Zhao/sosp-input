<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String metadata = request.getParameter("metadata");
	if (metadata==null) metadata="";
	String rpx = request.getParameter("rpx");
	System.out.println(rpx);
	//com.raqsoft.center.entity.User user = (com.raqsoft.center.entity.User) session.getAttribute("userObj");
	//json
	//[{"name":"ar","desc":"ar","type":"11","value":"abc"},{"name":"cpmc","desc":"多选模糊查询","type":"11","value":"胡椒"}]
	String table = request.getParameter("table");
	String userId = request.getParameter("userId");
	if (table == null) table = "员工";
	if (userId == null) userId = "23";
	String params = "{\"table\":\""+table+"\",\"userId\":"+userId+"}";
	System.out.println(params);
%>

<title>通用查询</title>

<frameset rows="40%,60%">
  <frame name="frame1" src="cq.jsp?metadata=<%=java.net.URLEncoder.encode(metadata, "UTF-8")%>&params=<%=java.net.URLEncoder.encode(params, "UTF-8")%>" />
  <frame name="commonReportFrame" src="../../../reportJsp/cqReport.jsp?__rpx=<%=java.net.URLEncoder.encode(rpx, "UTF-8")%>&params=<%=java.net.URLEncoder.encode(params, "UTF-8")%>" />
</frameset>
