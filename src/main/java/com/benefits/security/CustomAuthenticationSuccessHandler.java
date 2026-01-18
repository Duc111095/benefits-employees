package com.benefits.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Set;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        System.out.println("Roles: " + roles);
        if (roles.contains("ROLE_ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/manager/reports/dashboard");
        } else if (roles.contains("ROLE_HR_MANAGER")) {
            response.sendRedirect(request.getContextPath() + "/manager/reports/dashboard");
        } else if (roles.contains("ROLE_MANAGER")) {
            response.sendRedirect(request.getContextPath() + "/manager/claims");
        } else if (roles.contains("ROLE_EMPLOYEE")) {
            response.sendRedirect(request.getContextPath() + "/self-service/benefits");
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/reports/dashboard");
        }
    }
}
