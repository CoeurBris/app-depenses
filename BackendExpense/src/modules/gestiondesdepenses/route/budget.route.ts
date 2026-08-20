import { Router } from 'express';
import {
  createBudget,
  deleteBudget,
  getAllBudgets,
  getBudgetById,
  getBudgetsPaginated,
  updateBudget,
} from '../controller/budget.controller';

export const budgetRoutes = (router: Router) => {
  // Collection & Création
  router.post('/budgets', createBudget);
  router.get('/budgets/all', getAllBudgets);
  router.get('/budgets', getBudgetsPaginated);

  // Éléments individuels
  router.get('/budgets/:id', getBudgetById);
  router.put('/budgets/:id', updateBudget);
  router.delete('/budgets/:id', deleteBudget);
};