import { Request, Response } from 'express';
import { ValidationError } from 'class-validator';
import { myDataSource } from '../../../configs/data-source';
import { generateServerErrorCode, success } from '../../../configs/response';
import { checkRelationsOneToMany } from '../../../configs/checkRelationsOneToManyBeforDelete';
import { paginationAndRechercheInit } from '../../../configs/paginationAndRechercheInit';
import { Notification } from '../entity/notification.entity';

// ====================== CREATE ======================
export const createNotification = async (req: Request, res: Response) => {
  try {
    const notificationRepo = myDataSource.getRepository(Notification);
    const notification = notificationRepo.create(req.body as Partial<Notification>);
    const savedNotification = (await notificationRepo.save(notification)) as Notification;

    const message = `La notification "${savedNotification.title || 'nouvelle'}" a bien été créée.`;
    return success(res, 201, savedNotification, message);
  } catch (error: any) {
    if (error instanceof ValidationError) {
      return generateServerErrorCode(
        res,
        400,
        error,
        'Les données de la notification sont invalides.'
      );
    }

    return generateServerErrorCode(
      res,
      500,
      error,
      "La notification n'a pas pu être ajoutée. Réessayez dans quelques instants."
    );
  }
};

// ====================== GET ALL ======================
export const getAllNotifications = async (req: Request, res: Response) => {
  try {
    const notifications = await myDataSource.getRepository(Notification).find({
      relations: ['relatedExpense'],
      order: { createdAt: 'DESC' },
    });

    const message = 'La liste des notifications a bien été récupérée.';
    return success(res, 200, notifications, message);
  } catch (error: any) {
    return generateServerErrorCode(
      res,
      500,
      error,
      "La liste des notifications n'a pas pu être récupérée. Réessayez dans quelques instants."
    );
  }
};

// ====================== PAGINATED ======================
export const getNotificationsPaginated = async (req: Request, res: Response) => {
  try {
    const { limit, searchTerm, startIndex } = paginationAndRechercheInit(
      req,
      Notification
    );

    let query = myDataSource
      .getRepository(Notification)
      .createQueryBuilder('n')
      .leftJoinAndSelect('n.relatedExpense', 'expense');

    if (searchTerm) {
      query = query.where(
        '( n.title ILIKE :keyword OR n.body ILIKE :keyword )',
        { keyword: `%${searchTerm}%` }
      );
    }

    const [data, totalElements] = await query
      .orderBy('n.createdAt', 'DESC')
      .skip(startIndex)
      .take(limit)
      .getManyAndCount();

    const totalPages = Math.ceil(totalElements / limit);
    const message = 'La liste des notifications a bien été récupérée.';

    return success(
      res,
      200,
      { data, totalPages, totalElements, limit },
      message
    );
  } catch (error: any) {
    return generateServerErrorCode(
      res,
      500,
      error,
      "Erreur lors de la récupération des notifications."
    );
  }
};

// ====================== GET BY ID ======================
export const getNotificationById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const notification = await myDataSource.getRepository(Notification).findOne({
      where: { id: id as any },
      relations: ['relatedExpense'],
    });

    if (!notification) {
      return generateServerErrorCode(
        res,
        404,
        "L'ID n'existe pas",
        "La notification demandée n'existe pas."
      );
    }

    const message = 'La notification a bien été trouvée.';
    return success(res, 200, notification, message);
  } catch (error: any) {
    return generateServerErrorCode(
      res,
      500,
      error,
      "La notification n'a pas pu être récupérée. Réessayez dans quelques instants."
    );
  }
};

// ====================== UPDATE ======================
export const updateNotification = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const notificationRepo = myDataSource.getRepository(Notification);

    const notification = await notificationRepo.findOne({
      where: { id: id as any },
    });

    if (!notification) {
      return generateServerErrorCode(
        res,
        404,
        "L'ID n'existe pas",
        "Cette notification n'existe pas."
      );
    }

    notificationRepo.merge(notification, req.body);
    const updated = await notificationRepo.save(notification);

    const message = 'La notification a bien été modifiée.';
    return success(res, 200, updated, message);
  } catch (error: any) {
    if (error instanceof ValidationError) {
      return generateServerErrorCode(
        res,
        400,
        error,
        'Les données fournies sont invalides.'
      );
    }

    return generateServerErrorCode(
      res,
      500,
      error,
      "La notification n'a pas pu être modifiée. Réessayez dans quelques instants."
    );
  }
};

// ====================== DELETE ======================
export const deleteNotification = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const notificationRepo = myDataSource.getRepository(Notification);

    const notification = await notificationRepo.findOne({
      where: { id: id as any },
    });

    if (!notification) {
      return generateServerErrorCode(
        res,
        404,
        "L'ID n'existe pas",
        "La notification demandée n'existe pas."
      );
    }

    const hasRelations = await checkRelationsOneToMany('Notification', id);
    if (hasRelations) {
      return generateServerErrorCode(
        res,
        400,
        'Relations existantes',
        'Cette notification est liée à d\'autres enregistrements et ne peut pas être supprimée.'
      );
    }

    await notificationRepo.remove(notification);

    const message = 'La notification a bien été supprimée.';
    return success(res, 200, notification, message);
  } catch (error: any) {
    return generateServerErrorCode(
      res,
      500,
      error,
      "La notification n'a pas pu être supprimée. Réessayez dans quelques instants."
    );
  }
};