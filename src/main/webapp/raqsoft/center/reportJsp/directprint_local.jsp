<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.net.*"%>
<%@ page import="com.raqsoft.report.view.*"%>
<html>
<body>
<%
	//此JSP参数格式为：report={无参数报表名}{报表1(参数1=value1;参数2=value2;...)}{报表2(参数1=value1;参数2=value2;...)}...&prompt=yes&needSelectPrinter=yes
	request.setCharacterEncoding( "UTF-8" );
  	String report = request.getParameter( "report" );
  	//"请输入报表文件名及参数串report={无参数报表名}{报表1(参数1=value1;参数2=value2;...)}{报表2(参数1=value1;参数2=value2;...)}..."
  	if( report == null || report.trim().length() == 0 ) throw new Exception( ServerMsg.getMessage(request,"jsp.dpArgError") );
	String prompt = request.getParameter( "prompt" );
	String needSelectPrinter = request.getParameter( "needSelectPrinter" );
	String pages = request.getParameter( "pages" );
	String copies = request.getParameter( "copies" );
  	String appmap = request.getContextPath();
	String appRoot = ReportServlet.getUrlPrefix( request );
	if( !appRoot.startsWith( "http" ) ){
		String approot1 = request.getRequestURL().toString();
		approot1 = approot1.substring( 0, approot1.indexOf( request.getRequestURI() ) );
		appRoot = approot1 + appmap;
	}
	StringBuffer url = new StringBuffer( "printrpx://" );
	url.append( "a=" + URLEncoder.encode( appRoot, "UTF-8" ) );
	url.append( "&b=" + URLEncoder.encode( "/reportServlet;jsessionid=" + session.getId() + "?action=1", "UTF-8" ) );
	url.append( "&c=" + URLEncoder.encode( report, "UTF-8" ) );
	if( needSelectPrinter != null ) {
		url.append( "&k=" + needSelectPrinter );
	}
	url.append( "&u=1" );
	url.append( "&v=" + prompt );
	url.append( "&x=UTF-8" );  //paramCharset
	if( pages != null ) url.append( "&z=" + pages );
	if( copies != null ) url.append( "&aa=" + copies );
	url.append( "&ti=" + System.currentTimeMillis() );
%>
<iframe id="printIFrame" src="<%=url.toString()%>" style="position:absolute;left:-100px;top:-100px;" width=50, height=50></iframe>
</body>
</html>
