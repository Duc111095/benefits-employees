package com.benefits.module.notification.service;

import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.repository.UserRepository;
import com.benefits.module.notification.entity.Notification;
import com.benefits.module.notification.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    public List<Notification> getNotificationsForUser(Long userId) {
        return notificationRepository.findByRecipientIdOrderByCreatedAtDesc(userId);
    }

    public List<Notification> getUnreadNotificationsForUser(Long userId) {
        return notificationRepository.findByRecipientIdAndReadOrderByCreatedAtDesc(userId, false);
    }

    public long getUnreadCount(Long userId) {
        return notificationRepository.countByRecipientIdAndRead(userId, false);
    }

    @Transactional
    public void sendNotification(User recipient, String title, String message, String type, String category) {
        Notification notification = new Notification();
        notification.setRecipient(recipient);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification.setCategory(category);
        notificationRepository.save(notification);
    }

    @Transactional
    public void broadcastToAll(String title, String message, String type, String category) {
        List<User> users = userRepository.findAll();
        for (User user : users) {
            sendNotification(user, title, message, type, category);
        }
    }

    @Transactional
    public void markAsRead(Long notificationId) {
        notificationRepository.findById(notificationId).ifPresent(n -> {
            n.setRead(true);
            notificationRepository.save(n);
        });
    }

    @Transactional
    public void deleteNotification(Long notificationId) {
        notificationRepository.deleteById(notificationId);
    }
}
