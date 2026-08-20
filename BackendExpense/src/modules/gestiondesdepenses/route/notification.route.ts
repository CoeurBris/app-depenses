import { Router } from 'express';
import {
  createNotification,
  deleteNotification,
  getAllNotifications,
  getNotificationById,
  getNotificationsPaginated,
  updateNotification,
} from '../controller/notification.controller';

export const notificationRoutes = (router: Router) => {
  // Collection & Création
  router.post('/notifications', createNotification);
  router.get('/notifications/all', getAllNotifications);
  router.get('/notifications', getNotificationsPaginated);

  // Éléments individuels
  router.get('/notifications/:id', getNotificationById);
  router.put('/notifications/:id', updateNotification);
  router.delete('/notifications/:id', deleteNotification);
};