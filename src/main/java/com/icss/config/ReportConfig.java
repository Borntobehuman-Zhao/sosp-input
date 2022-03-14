package com.icss.config;

import com.jfinal.config.*;
import com.jfinal.ext.handler.UrlSkipHandler;
import com.jfinal.template.Engine;

public class ReportConfig extends JFinalConfig {


    @Override
    public void configConstant(Constants constants) {

    }

    @Override
    public void configRoute(Routes me) {
// 使用 jfinal 4.9.03 新增的路由扫描功能
        me.scan("com.icss.");
    }

    @Override
    public void configEngine(Engine engine) {

    }

    @Override
    public void configPlugin(Plugins plugins) {

    }

    @Override
    public void configInterceptor(Interceptors interceptors) {

    }

    @Override
    public void configHandler(Handlers handlers) {
        // 过滤Servlet
        handlers.add(new UrlSkipHandler("^/InputServlet*",true));
    }
}
