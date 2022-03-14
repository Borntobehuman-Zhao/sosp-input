<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.raqsoft.report.view.*" %>
<%@ page import="com.raqsoft.report.util.*" %>
<%@ page import="com.raqsoft.input.tag.*" %>
<%@ page import="com.raqsoft.input.model.resources.*" %>
<%@ taglib uri="/WEB-INF/raqsoftInput.tld" prefix="raqsoft" %>
<%@ taglib uri="/WEB-INF/raqsoftReport.tld" prefix="report" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (request.getProtocol().compareTo("HTTP/1.1") == 0) response.setHeader("Cache-Control", "no-cache");
    else response.setHeader("Pragma", "no-cache");
    request.setCharacterEncoding("UTF-8");
    String appmap = request.getContextPath();
    String sht = request.getParameter("sht");
    String type = request.getParameter("type");
    String menu = request.getParameter("l");
    String menu1 = request.getParameter("show");

    sht = type + ".sht";

    /**
     * code 显示菜单
     * base 不显示菜单
     */
    pageContext.setAttribute("flag2", menu.equals("code"));
    pageContext.setAttribute("flag2base", menu1.equals("yes"));

    //保证报表名称的完整性
    int iTmp = 0;
    if (sht == null) sht = ""; //填报集群设置
    if ((iTmp = sht.lastIndexOf(".sht")) <= 0) {
        iTmp = sht.length();
        sht = sht + ".sht";
    }

    StringBuffer param = new StringBuffer();
    Enumeration paramNames = request.getParameterNames();
    if (paramNames != null) {
        while (paramNames.hasMoreElements()) {
            String paramName = (String) paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            if (paramValue != null) {
                //把参数拼成name=value;name2=value2;.....的形式
                param.append(paramName).append("=").append(paramValue).append(";");
            }
        }
    }
    //System.out.println("params : " + param.toString());
    String noDfx = request.getParameter("noDfx");
    String adp = request.getParameter("adp");
    if (noDfx == null) noDfx = "";
    if (adp == null) adp = "";
    if (!noDfx.equals("") && adp.equals("")) adp = noDfx;
    String dataFile = request.getParameter("dataFile");
    if (dataFile == null || dataFile.length() == 0) {
        dataFile = "";
    }
    String fileType = request.getParameter("fileType");
    if (fileType == null || fileType.length() == 0) {
        //if (dataFile.indexOf(".json"))
        fileType = "json";
    }


    //填报集群设置
    String sgid = null;
    sgid = request.getParameter("sgid");
    if (sgid == null || sgid.length() == 0) sgid = InputTag.getInputId();

    String resultPage = "queryInput.jsp?sht=" + URLEncoder.encode(sht, "UTF-8") + "&adp=" + adp + "&dataFile=" + URLEncoder.encode(dataFile, "UTF-8") + "&fileType=" + fileType + "&sgid=" + sgid;

    //以下代码是检测这个报表是否有相应的参数模板
    String paramFile = sht.substring(0, iTmp) + "_arg.rpx";
    boolean hasParam = ReportUtils.isReportFileExist(paramFile);
%>

<html>
<head>
    <meta name="viewport" content="initial-scale=1"/>
    <title><%=InputMessage.get(request).getMessage("input.web10")%>
    </title>
</head>
<link rel="stylesheet" type="text/css"
      href="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/themes/<%=ReportConfig.theme%>/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/themes/icon.css">
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/jquery.min.js"></script>
<script type="text/javascript" src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"
        src="<%=appmap%><%=ReportConfig.raqsoftDir%>/easyui/locale/easyui-lang-<%=ReportUtils2.getEasyuiLanguage(request)%>.js"></script>
<style>
    table {
        margin: 0 auto !important;
    }

    .panel-body .panel-body-noheader .panel-body-noborder {
        padding-top: 20px !important;
    }
</style>
<body topmargin=0 leftmargin=0 rightmargin=0 bottomMargin=0 style="background:#F1F4F7"
      onload="try{parent.hideLoading()}catch(e){}">
<div id=mengban style="background-color:white;position:absolute;z-index:999;width:100%;height:100%">
    <table width=100% height=100%>
        <tr>
            <td width=100% style="text-align:center;vertical-align:middle"><img
                    src="../raqsoft/images/loading.gif"><br><%=InputMessage.get(request).getMessage("input.web8")%>
                ......
            </td>
        </tr>
    </table>
</div>
<div id=reportArea class="easyui-layout" data-options="fit:true" style="display:none;width:100%;height:100%">
    <c:if test="${flag2}">
    <div data-options="region:'north',border:false" style="height:30px;overflow:hidden">
        <jsp:include page="tbDataInputToolBar.jsp" flush="false">
            <jsp:param name="sgid" value="<%=sgid %>"></jsp:param>
        </jsp:include>
    </div>
    </c:if>
    <c:if test="${flag2base}">
    <div data-options="region:'north',border:false" style="height:30px;overflow:hidden">
        <jsp:include page="tbDataInputBaseToolBar.jsp" flush="false">
            <jsp:param name="sgid" value="<%=sgid %>"></jsp:param>
        </jsp:include>
    </div>
    </c:if>
    <div data-options="region:'center',border:false">
        <div class="easyui-layout" data-options="fit:true">
            <% //如果参数模板存在，则显示参数模板
                if (hasParam) {
            %>
            <div data-options="region:'north',border:false">
                <center>
                    <table id=param_tbl>
                        <tr>
                            <td>
                                <report:param name="form1" paramFileName="<%=paramFile%>"
                                              needSubmit="no"
                                              params="<%=param.toString()%>"
                                              hiddenParams="<%=param.toString()%>"
                                              resultPage="<%=resultPage%>"
                                              resultContainer="reportContainer"
                                              needImportEasyui="no"
                                />
                            </td>
                            <td style="padding-left:15px"><a href="javascript:_submit( form1 )"
                                                             class="easyui-linkbutton"
                                                             style="vertical-align:middle;padding:0px 8px;"><%=InputMessage.get(request).getMessage("input.web9")%>
                            </a></td>
                        </tr>
                    </table>
                </center>
            </div>
            <% }%>
            <div id=reportContainer class="runqian_cont" data-options="region:'center',border:false"
                 style="text-align:center">
                <raqsoft:input id="<%=sgid %>"
                               src="<%=sht%>"
                               paramMode="i"
                               params="<%=param.toString()%>"
                               excel="io"
                               needImportEasyui="no"
                               width="100%"
                               height="100%"
                               tabLocation="bottom"
                               adp="<%=adp%>"
                               file="<%=dataFile%>"
                               fileType="<%=fileType%>"
                               outerDim="id"
                               exceptionPage="myError.jsp"
                />
            </div>
        </div>
    </div>
    <script language="javascript">
        document.getElementById("mengban").style.display = "none";
        document.getElementById("reportArea").style.display = "";
        var table = document.getElementById(sgid + "0");
        for (var i = 2; i < table.rows.length; i++) {
            if (i % 2 == 0) {
                table.rows[i].style.background = '#F1F4F7';
            }
        }

        function getQueryVariable(variable) {
            var query = window.location.search.substring(1);
            var vars = query.split("&");
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split("=");
                if (pair[0] == variable) {
                    return pair[1];
                }
            }
            return (false);
        }
    </script>
    <script src/>
</body>
</html>
