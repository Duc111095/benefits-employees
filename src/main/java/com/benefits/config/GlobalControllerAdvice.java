package com.benefits.config;

import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.repository.UserRepository;
import com.benefits.module.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {

    private final NotificationService notificationService;
    private final UserRepository userRepository;

    @ModelAttribute("unreadNotificationCount")
    public long getUnreadNotificationCount(@AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails != null) {
            return userRepository.findByUsername(userDetails.getUsername())
                    .map(User::getId)
                    .map(notificationService::getUnreadCount)
                    .orElse(0L);
        }
        return 0;
    }
}
