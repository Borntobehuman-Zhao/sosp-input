package com.icss.config;

import com.jfinal.handler.Handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BaseHandler extends Handler {
    @Override
    public void handle(String target, HttpServletRequest request, HttpServletResponse response, boolean[] isHandled) {
        String url = request.getRequestURL().toString();



        System.out.println("target");
        System.out.println(target);

        System.out.println("url");
        System.out.println(url);

        System.out.println("getContextPath");
        System.out.println(request.getContextPath());


        next.handle(target, request, response, isHandled);
    }
}
