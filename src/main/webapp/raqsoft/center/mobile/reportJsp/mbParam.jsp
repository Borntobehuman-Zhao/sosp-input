<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/raqsoftReport.tld" prefix="report" %>
<%@ page import="java.net.*" %>
<%@ page import="com.raqsoft.report.view.*"%>
<%
	request.setCharacterEncoding( "UTF-8" );
	String arg = request.getParameter( "arg" );
	String match = request.getParameter( "match" );
	String rpx = request.getParameter( "rpx" );
	if( match == null ) match = "1";
	String title = request.getParameter( "title1" );
	if( title == null ) title = "输入报表查询参数";
	String appmap = request.getContextPath();
	String resultPage = appmap + "/mobileJsp/mbReport.jsp?rpx=" + URLEncoder.encode( rpx, "UTF-8" ) + "&isQuery=1&match=" + match;
	String title2 = request.getParameter( "title2" );
	if( title2 != null ) {
		resultPage += "&title=" + URLEncoder.encode( title2, "UTF-8" );
	}
%>

<html>
<head>
    <meta charset="utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
	<title><%=title%></title>
</head>
<body style="padding:0.5em 1em;" >
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/jquery.min.js"></script>
<report:param name="param1" paramFileName="<%=arg%>"
	needSubmit="no"
	mobileMode="yes"
	resultPage="<%=resultPage%>"
/>
<a style="margin:1em 0; background:#006CD9; border-radius:4px;color:#FFF;font-size:1em;font-family:微软雅黑; border: #005DBA 1px solid; display:block; text-align:center; line-height:3em;width:100%;"  href="javascript:_submit( document.getElementById('param1') )" group="">
查询</a>

</body>
</html>
