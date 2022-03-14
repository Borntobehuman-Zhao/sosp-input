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
	boolean isAggr = "1".equals(request.getParameter("isAggr"));
%>
<link href="<%=basePath%>reportJsp/toolbar.css" rel="stylesheet">
<div class="btnBar">
  <ul class="left">
    <%if (isAggr){ %>
    <li class="toggleBg borderRight">
      <ul class="fileOper">
		<li><a class="ICOhover" href="#" onClick="_inputDownloadExcel('<%=sgid %>');return false;"><span title="<%=InputMessage.get(request).getMessage("input.web1")%>" class="excel"></span></a></li>
       </ul>
    </li>
    <%} else { %>
    <li class="borderRight submitLi left" onClick="_inputSubmit1('<%=sgid %>');return false;" href="#"> <a title="<%=InputMessage.get(request).getMessage("input.web6")%>" href="#" class="submit"></a></li>
    <li class="toggleBg borderRight left">
      <ul class="fileOper">
		<li><a class="ICOhover" href="#" onClick="_inputDownloadExcel('<%=sgid %>');return false;"><span title="<%=InputMessage.get(request).getMessage("input.web1")%>" class="excel"></span></a></li>
		<li><a class="ICOhover" href="#" onClick="_inputLoadExcelData('<%=sgid %>');return false;"><span title="<%=InputMessage.get(request).getMessage("input.web2")%>" class="excel-import"></span></a></li>
		<li id="inputAppendExcel" style="display:none;"><a class="ICOhover left" href="#" onClick="_inputAppendExcelData('<%=sgid %>');return false;"><span title="<%=InputMessage.get(request).getMessage("input.web16")%>" class="excel-append"></span></a></li>
       </ul>
    </li>
    <%} %>
  </ul>
</div>
<script>
	$(document).ready(function(){
		showRowInputButtons();
	});


    function _inputSubmit1(sgid, noCheck) {
        if(prompt){
            if(confirm(input__confirmSubmit)){}
            else{return;}
        }
        if(!checkEnableSubmit()){
            alert(input__processing);
            return;
        }
        var datas = null;//'{"sheet1":{"A1":"dept.部门","B1":"经理","C1":"www","A2":["研发部","销售部","综合部","哈哈"],"B2":["2","3","1","4"],"C2":["","","",""]}}';
        try {
            datas = _getInputDatas(sgid);
        }catch(e){
            console_warn(e);
            return;
        }
        //if (datas == '') return;
        var cs = "UTF-8";
        try {
            //cs = jspCharset;
        } catch(e) {}
        $.ajax({
            type: 'POST',
            async : false,
            url: contextPath + "/InputServlet?d="+new Date().getTime(),
            data: {action:1,sgid:sgid,data:datas,checkType:(getCheckOnSubmit(sgid)?"1":"0"),multiSqlUpdateOpt:update},
            //contentType:"application/x-www-form-urlencoded; charset="+cs,
            success: function(d){
                if (d.indexOf('error:')==0 || d.indexOf('update error:') == 0) {
                    try {
                        inputApi.saveError(d.substring(6));
                    } catch(e) {
                        alert(d.substring(6));
                    }
                    return;
                }
                try {
                    inputApi.saveSuccess();
                } catch(e) {
                    alert(resources.input.webjs1);//保存成功
                    window.opener = null;
                    window.open('', '_top', '');
                    window.parent.close();
                }
            }
        });
    }
</script>
