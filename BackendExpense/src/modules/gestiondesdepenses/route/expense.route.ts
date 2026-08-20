import { Router } from 'express';
import {
  createExpense,
  deleteExpense,
  getAllExpenses,
  getExpenseById,
  getExpensesPaginated,
  updateExpense,
} from '../controller/expense.controller';

export const expenseRoutes = (router: Router) => {
  // Collection & Création
  router.post('/expenses', createExpense);
  router.get('/expenses/all', getAllExpenses);
  router.get('/expenses', getExpensesPaginated);

  // Éléments individuels
  router.get('/expenses/:id', getExpenseById);
  router.put('/expenses/:id', updateExpense);
  router.delete('/expenses/:id', deleteExpense);
};