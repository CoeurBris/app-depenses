import multer = require('multer');
import fs = require('fs');
import path = require('path');
var moment = require('moment-timezone');


const timezone_name = "Asia/Kolkata";
function serverDateTime(format) {
  var jun = moment(new Date());
  jun.tz(timezone_name).format();
  return jun.format(format);
}

const fileNameGenerate =  (extension) => {
  var chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  var result = '';
  for (let i = 10; i > 0; i--) result += chars[Math.floor(Math.random() * chars.length)];
  return serverDateTime('YYYYMMDDHHmmssms') + result + '.' + extension;
}
//var files = [];

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const nmbre = file.originalname.split(".");
    file.originalname = fileNameGenerate(nmbre[nmbre.length - 1]);
    cb(null, file.originalname);
   // files.push(file);
  }
});

const storagePers = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/Personnels/');
  },
  filename: function (req, file, cb) {
    console.log("fichier",file);
    const nmbre = file.originalname.split(".");

    file.originalname = fileNameGenerate(nmbre[nmbre.length - 1]);
    cb(null, file.originalname);
   // files.push(file);
  }
});

export const storageSocie = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/Societe/');
  },
  filename: function (req, file, cb) {
    const nmbre = file.originalname.split(".");
    file.originalname = fileNameGenerate(nmbre[nmbre.length - 1]);
    cb(null, file.originalname);
   // files.push(file);
  }
});

export const storageDocu = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/Documents/');
  },
  filename: function (req, file, cb) {
    const nmbre = file.originalname.split(".");
    file.originalname = fileNameGenerate(nmbre[nmbre.length - 1]);
    cb(null, file.originalname);
   // files.push(file);
  }
});


export const storageJustificatif = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/Justificatifs/');
  },
  filename: function (req, file, cb) {
    const nmbre = file.originalname.split(".");
    file.originalname = fileNameGenerate(nmbre[nmbre.length - 1]);
    cb(null, file.originalname);
  }
});

export const storageDemande = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/Demandes/');
  },
  filename: function (req, file, cb) {
    const nmbre = file.originalname.split(".");
    file.originalname = fileNameGenerate(nmbre[nmbre.length - 1]);
    cb(null, file.originalname);
  }
});


export const storageFinance = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/Finances/');
  },
  filename: function (req, file, cb) {
    const nmbre = file.originalname.split(".");
    file.originalname = fileNameGenerate(nmbre[nmbre.length - 1]);
    cb(null, file.originalname);
  }
});

export const storageDocument = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/Documents/');
  },
  filename: function (req, file, cb) {
    const nmbre = file.originalname.split(".");
    file.originalname = fileNameGenerate(nmbre[nmbre.length - 1]);
    cb(null, file.originalname);
   // files.push(file);
  }
});

// export const storage = multer({ storage: multer.memoryStorage() });

const fileFilter = (req, file, cb) => {
  // reject a file
  if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png' || file.mimetype === 'application/msword' || file.mimetype === 'application/pdf' || file.mimetype === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

export const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 5 //5Mo
  },
  fileFilter: fileFilter
});

export const listen = multer({
    storage: storage,
    limits: {
      fileSize: 1024 * 1024 * 115 //5Mo
    },
    fileFilter: fileFilter
});
export const societeListen = multer({
  storage: storageSocie,
  limits: {
    fileSize: 1024 * 1024 * 115 //5Mo
  },
  fileFilter: fileFilter
});
export const persoListen = multer({
  storage: storagePers,
  limits: {
    fileSize: 1024 * 1024 * 115 //5Mo
  },
  fileFilter: fileFilter
});
export const docListen = multer({
  storage: storageDocu,
  limits: {
    fileSize: 1024 * 1024 * 115 //5Mo
  },
  fileFilter: fileFilter
});

export const justificatifListen = multer({
  storage: storageJustificatif,
  limits: {
    fileSize: 1024 * 1024 * 115 //5Mo
  },
  fileFilter: fileFilter
});

export const demandeListen = multer({
  storage: storageDemande,
  limits: {
    fileSize: 1024 * 1024 * 115 //5Mo
  },
  fileFilter: fileFilter
});

export const financeListen = multer({
  storage: storageFinance,
  limits: {
    fileSize: 1024 * 1024 * 115 //5Mo
  },
  fileFilter: fileFilter
});
