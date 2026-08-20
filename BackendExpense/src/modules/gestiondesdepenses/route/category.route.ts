import { Router } from 'express';
import {
  createCategory,
  deleteCategory,
  getAllCategories,
  getCategoriesPaginated,
  getCategoryById,
  updateCategory,
} from '../controller/category.controller';

export const categoryRoutes = (router: Router) => {
  // Collection & Création
  router.post('/categories', createCategory);
  router.get('/categories/all', getAllCategories);
  router.get('/categories', getCategoriesPaginated);

  // Éléments individuels
  router.get('/categories/:id', getCategoryById);
  router.put('/categories/:id', updateCategory);
  router.delete('/categories/:id', deleteCategory);
};