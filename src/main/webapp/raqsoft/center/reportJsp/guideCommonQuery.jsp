<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>gcq</title>
<%
	String cq_json = request.getParameter("cq_json");
	String cq_dfx = request.getParameter("cq_dfx");
	String cq_rpx = request.getParameter("cq_rpx");
	System.out.println(cq_json);
	com.raqsoft.center.entity.User user = (com.raqsoft.center.entity.User) session.getAttribute("userObj");
	//json
	//[{"name":"ar","desc":"ar","type":"11","value":"abc"},{"name":"cpmc","desc":"多选模糊查询","type":"11","value":"胡椒"}]
	String userParams = user.getReportParams();
%>
</head>
<body>
	<jsp:include page="../../guide/jsp/commonQuery.jsp"></jsp:include>
	<iframe name="rpxframe" id="rpxframe"></iframe>
</body>
</html>