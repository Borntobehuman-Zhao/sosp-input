package com.icss.controller;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.render.JspRender;

@Path("/")
public class IndexController extends Controller {

    public void index() {
        renderText("填报系统");
    }

    public void input(String type) {
        if ("raq".equals(type)) {
            render(new JspRender("reportJsp/showInput.jsp"));
        } else {
            render(new JspRender("reportJsp/sbData.jsp"));
        }
    }

}
