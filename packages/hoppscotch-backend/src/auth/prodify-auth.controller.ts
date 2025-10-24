import { Controller, Get, Post, Query, Req, Res } from '@nestjs/common';
import { Request, Response } from 'express';
import * as jwt from 'jsonwebtoken';
import { ProdifyAuthStrategy } from './prodify-auth.strategy';

@Controller({ path: 'auth', version: '1' })
export class ProdifyAuthController {
  constructor(private readonly prodifyAuthStrategy: ProdifyAuthStrategy) {}
  
  /**
   * Endpoint de autenticação via Prodify
   * Aceita token SSO do Prodify e cria sessão no TestPath
   */
  @Get('prodify')
  async prodifyAuth(
    @Query('sso_token') ssoToken: string,
    @Query('token') token: string,
    @Req() req: Request,
    @Res() res: Response
  ) {
    try {
      // Pegar token da query ou header
      const authToken = ssoToken || token || req.headers['authorization']?.replace('Bearer ', '');
      
      if (!authToken) {
        return res.redirect(
          `${process.env.VITE_APP_URL || 'http://localhost:3000'}?error=no_token`
        );
      }

      // Validar token e obter usuário
      const user = await this.prodifyAuthStrategy.validateToken(authToken);
      
      if (!user) {
        return res.redirect(
          `${process.env.VITE_APP_URL || 'http://localhost:3000'}?error=auth_failed`
        );
      }

      // Criar JWT para sessão no TestPath
      const payload = {
        userId: user.uid,
        email: user.email,
        displayName: user.displayName,
      };

      const sessionToken = jwt.sign(
        payload,
        process.env.JWT_SECRET || 'testpath-dev-jwt-secret',
        { expiresIn: '7d' } // Token válido por 7 dias
      );

      // Criar cookie de sessão
      const maxAge = 7 * 24 * 60 * 60 * 1000; // 7 dias em ms
      
      res.cookie('testpath_session', sessionToken, {
        httpOnly: true,
        secure: process.env.PRODUCTION === 'true',
        sameSite: 'lax',
        maxAge,
        path: '/',
      });

      // Redirecionar para a aplicação
      const redirectUrl = process.env.VITE_APP_URL || 'http://localhost:3000';
      
      console.log(`✅ Usuário autenticado via Prodify: ${user.email}`);
      console.log(`🔄 Redirecionando para: ${redirectUrl}`);
      
      return res.redirect(redirectUrl);
      
    } catch (error) {
      console.error('❌ Erro na autenticação Prodify:', error);
      
      return res.redirect(
        `${process.env.VITE_APP_URL || 'http://localhost:3000'}?error=auth_error`
      );
    }
  }

  /**
   * Endpoint para validar sessão existente
   */
  @Get('prodify/validate')
  async validateSession(@Req() req: Request, @Res() res: Response) {
    try {
      const sessionToken = req.cookies['testpath_session'];
      
      if (!sessionToken) {
        return res.status(401).json({ error: 'Sessão não encontrada' });
      }

      const decoded = jwt.verify(
        sessionToken,
        process.env.JWT_SECRET || 'testpath-dev-jwt-secret'
      ) as any;

      return res.json({
        valid: true,
        user: {
          uid: decoded.userId,
          email: decoded.email,
          displayName: decoded.displayName,
        }
      });
      
    } catch (error) {
      return res.status(401).json({ error: 'Sessão inválida ou expirada' });
    }
  }

  /**
   * Endpoint para logout
   */
  @Get('prodify/logout')
  async logout(@Req() req: Request, @Res() res: Response) {
    res.clearCookie('testpath_session');
    
    const redirectUrl = process.env.PRODIFY_URL || 'http://localhost:8001';
    
    console.log(`👋 Logout - Redirecionando para Prodify: ${redirectUrl}`);
    
    return res.redirect(redirectUrl);
  }
}

