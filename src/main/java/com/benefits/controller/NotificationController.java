package com.benefits.controller;

import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.repository.UserRepository;
import com.benefits.module.notification.entity.Notification;
import com.benefits.module.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final UserRepository userRepository;

    private User getCurrentUser(UserDetails userDetails) {
        return userRepository.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @GetMapping
    public String listNotifications(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        User user = getCurrentUser(userDetails);
        List<Notification> notifications = notificationService.getNotificationsForUser(user.getId());
        model.addAttribute("notifications", notifications);
        return "notification/list";
    }

    @PostMapping("/{id}/read")
    @ResponseBody
    public String markAsRead(@PathVariable Long id) {
        notificationService.markAsRead(id);
        return "OK";
    }

    @PostMapping("/{id}/delete")
    public String deleteNotification(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        notificationService.deleteNotification(id);
        redirectAttributes.addFlashAttribute("success", "Notification deleted.");
        return "redirect:/notifications";
    }

    @GetMapping("/broadcast")
    public String showBroadcastForm() {
        return "notification/broadcast";
    }

    @PostMapping("/broadcast")
    public String sendBroadcast(@RequestParam String title,
            @RequestParam String message,
            @RequestParam String type,
            @RequestParam String category,
            RedirectAttributes redirectAttributes) {
        notificationService.broadcastToAll(title, message, type, category);
        redirectAttributes.addFlashAttribute("success", "Broadcast notification sent to all employees.");
        return "redirect:/notifications";
    }
}
