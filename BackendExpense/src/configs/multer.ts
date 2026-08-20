import { Request } from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';

const MIME_TYPES: { [key: string]: string } = {
  'image/jpg': 'jpg',
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'application/pdf': 'pdf',
  'application/msword': 'doc',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'docx',
};

const storage = multer.diskStorage({
  destination: (req, file, callback) => {
    const uploadBasePath = path.join(__dirname, '../../uploads');
    const subFolder = req.body.dossier || 'Autres';
    const finalPath = path.join(uploadBasePath, subFolder);
    if (!fs.existsSync(finalPath)) {
      fs.mkdirSync(finalPath, { recursive: true });
    }
    callback(null, finalPath);
  },
  filename: (req, file, callback) => {
    const extension = MIME_TYPES[file.mimetype] || 'bin';
    const timestamp = Date.now();
    const filename = `${timestamp}${Math.random().toString(36).substring(7)}.${extension}`;
    callback(null, filename);
  }
});

//  Storage dédié finances — dossier fixe créé à l'initialisation
const FINANCE_UPLOAD_PATH = path.join(__dirname, '../../uploads/Finances');

// Créer le dossier immédiatement au démarrage du serveur
if (!fs.existsSync(FINANCE_UPLOAD_PATH)) {
  fs.mkdirSync(FINANCE_UPLOAD_PATH, { recursive: true });
  console.log(' Dossier uploads/Finances créé:', FINANCE_UPLOAD_PATH);
}

const financeStorage = multer.diskStorage({
  destination: (req, file, callback) => {
    // Le dossier est déjà créé, pas besoin de vérifier à chaque requête
    callback(null, FINANCE_UPLOAD_PATH);
  },
  filename: (req, file, callback) => {
    const extension = MIME_TYPES[file.mimetype] || 'bin';
    const timestamp = Date.now();
    const filename = `${timestamp}_${Math.random().toString(36).substring(7)}.${extension}`;
    callback(null, filename);
  }
});

export const upload = multer({ storage }).single('fichier');
export const uploads = multer({ storage });
export const financeListen = multer({ storage: financeStorage });