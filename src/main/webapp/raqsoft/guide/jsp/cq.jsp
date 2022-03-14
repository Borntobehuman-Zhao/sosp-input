<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.raqsoft.guide.web.dl.*" %>
<%@ page import="com.raqsoft.guide.resource.*" %>
<%@ taglib uri="/WEB-INF/raqsoftCommonQuery.tld" prefix="raqsoft" %>
<%
request.setCharacterEncoding("UTF-8");
String cp = request.getContextPath();
String metadata = request.getParameter( "metadata" );
if (metadata == null) metadata = "";
String cqx = "{'fields':[{'name':'NATIVE','alias':'户籍城市','title':'户籍城市','comparison':'=','values':['2','5','6','8'],'show':1,'aggr':'','dataType':1},{'name':'GENDER','alias':'性别','title':'性别','comparison':'=','values':[1],'show':1,'aggr':'','dataType':1},{'name':'DEGREE','alias':'学历','title':'学历','comparison':'=','values':['2','4'],'show':1,'aggr':'','dataType':1}],'currGroup':'_all'}";
cqx = "";
String params = request.getParameter( "params" );
if (params == null) params = "";
//  params is : {"table":"订单","userId":"38"}
%>

<%
%>
<raqsoft:commonQuery
	metadata="<%=metadata%>"
	params="<%=params%>"
	cqx="<%=cqx%>"
/>

<script>
	
	$(document).ready(function(){

	});
	
</script>

