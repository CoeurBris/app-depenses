import * as express from 'express';
import {
    Register,
    Login,
    LoginMobile,
    ResetPasswordUser,
    SendResetPasswordCode,
    verifyAuth,
    Refresh,
    Logout,
} from '../controller/auth.controller';

export const authentication = (router: express.Router) => {
    router.post('/api/auth/register', Register);
    router.post('/api/auth/login', Login);
    router.post('/api/auth/login/mobile', LoginMobile);
    router.post('/api/auth/reset-password', ResetPasswordUser);
    router.post('/api/auth/send-reset-code', SendResetPasswordCode);
    router.post('/api/auth/verify', verifyAuth);
    router.post('/api/auth/refresh', Refresh);
    router.get('/api/auth/logout', Logout);
};