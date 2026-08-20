import * as express from 'express';
import {
  createUser,
  deleteUser,
  getAllAllUsers,
  getAllUsers,
  getUser,
  updatePassword,
  updateUser,
  ChangerPasswordAdmin
} from '../controller/user.controller';
import { checkPermission, isAuthenticated } from '../../../middlewares/auth.middleware';

export const userRoutes = (app: express.Application) => {

  // 🔹 Récupérer tous les utilisateurs (avec pagination)
  app.get('/api/users', isAuthenticated, checkPermission('ListUser'), getAllUsers);

  // 🔹 Récupérer tous sans pagination
  app.get('/api/all/users', getAllAllUsers);

  // 🔹 Récupérer un utilisateur
  app.get('/api/users/:id', getUser);

  // 🔹 Créer un utilisateur
  app.post('/api/users', createUser);

  // 🔹 Modifier un utilisateur
  app.put('/api/users/:id', updateUser);

  // 🔹 Supprimer un utilisateur
  app.delete('/api/users/:id', deleteUser);

  // 🔹 Modifier son mot de passe
  app.put('/api/users/password/:id', updatePassword);

  // 🔹 Admin change mot de passe
  app.put('/api/users/password/admin/:id', ChangerPasswordAdmin);
};