<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="com.raqsoft.input.model.resources.*"%>
<%
    String path = request.getContextPath();

    String basePath = request.getScheme()
            + "://" + request.getServerName()
            + ":"
            + request.getServerPort()
            + path
            + "/";

	String sgid = request.getParameter("sgid");
	if (sgid == null) sgid = "sg1";
%>
<link href="<%=basePath%>reportJsp/toolbar.css" rel="stylesheet">
<div class="btnBar">
  <ul class="left">
    <li class="toggleBg borderRight">
      <ul class="fileOper">
		<li><a class="ICOhover" href="#" onClick="_inputDownloadExcel('<%=sgid %>');return false;"><span title="<%=InputMessage.get(request).getMessage("input.web1")%>" class="excel"></span></a></li>
       </ul>
    </li>
  </ul>
</div>
<script>
	$(document).ready(function(){
		showRowInputButtons();
	});

</script>
