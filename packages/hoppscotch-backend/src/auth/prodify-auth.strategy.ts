import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import * as jwt from 'jsonwebtoken';

interface ProdifyJWTPayload {
  userId: string;
  email: string;
  name?: string;
  iat?: number;
  exp?: number;
}

interface ProdifyUserData {
  email: string;
  name?: string;
  source: 'prodify';
  timestamp: number;
}

@Injectable()
export class ProdifyAuthStrategy {
  constructor(private readonly prismaService: PrismaService) {}

  async validateToken(token: string): Promise<any> {
    try {
      if (!token) {
        throw new UnauthorizedException('Token não fornecido');
      }

      // Tentar decodificar como JWT do Prodify
      let userData: ProdifyUserData | null = null;
      
      try {
        // Tentar JWT assinado
        const jwtSecret = process.env.PRODIFY_JWT_SECRET || process.env.NEXTAUTH_SECRET || 'your-secret-key';
        const decoded = jwt.verify(token, jwtSecret) as ProdifyJWTPayload;
        
        userData = {
          email: decoded.email,
          name: decoded.name,
          source: 'prodify',
          timestamp: Date.now()
        };
      } catch (jwtError) {
        // Se falhar, tentar como token base64 (SSO simples)
        try {
          const decoded = JSON.parse(Buffer.from(token, 'base64').toString('utf-8'));
          
          if (decoded.email && decoded.source === 'prodify') {
            userData = decoded as ProdifyUserData;
            
            // Verificar se o token não está expirado (máximo 5 minutos)
            const tokenAge = Date.now() - decoded.timestamp;
            if (tokenAge > 5 * 60 * 1000) {
              throw new UnauthorizedException('Token expirado');
            }
          }
        } catch (base64Error) {
          throw new UnauthorizedException('Token inválido');
        }
      }

      if (!userData || !userData.email) {
        throw new UnauthorizedException('Dados do usuário inválidos');
      }

      // Buscar ou criar usuário no banco TestPath
      let user = await this.prismaService.user.findUnique({
        where: { email: userData.email }
      });

      if (!user) {
        // Criar novo usuário vindo do Prodify
        user = await this.prismaService.user.create({
          data: {
            email: userData.email,
            displayName: userData.name || userData.email.split('@')[0],
            photoURL: null,
            isAdmin: false,
            currentRESTSession: null,
            currentGQLSession: null,
          }
        });
        
        console.log(`✅ Novo usuário criado via Prodify: ${userData.email}`);
      } else {
        console.log(`✅ Usuário existente autenticado via Prodify: ${userData.email}`);
      }

      return user;
    } catch (error) {
      console.error('❌ Erro na autenticação Prodify:', error);
      throw new UnauthorizedException(error.message || 'Falha na autenticação');
    }
  }
}

