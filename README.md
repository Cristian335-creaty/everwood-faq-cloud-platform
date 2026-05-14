# Everwood FAQ Cloud 🌲

Plataforma cloud para cargar, almacenar y gestionar conversaciones históricas de Everwood. Permite registrar archivos CSV, JSON y TXT, guardarlos en Firebase Storage y consultar un historial con metadatos en Firestore.

## 🗂 Estructura del proyecto

```
Proyecto_Cloud/
├── public/
│   ├── index.html          # Pantalla principal / landing
│   ├── upload.html         # Carga de archivos
│   ├── history.html        # Historial de cargas
│   ├── css/
│   │   └── styles.css      # Sistema de diseño global
│   └── js/
│       └── firebase-config.js   # Credenciales Firebase (¡no publicar!)
├── firebase.json           # Configuración Firebase Hosting
├── .firebaserc             # Alias del proyecto Firebase
└── .gitignore
```

## ⚙️ Configuración inicial

### 1. Crea tu proyecto Firebase
1. Ve a [https://console.firebase.google.com](https://console.firebase.google.com)
2. Clic en **"Añadir proyecto"**
3. Nombre: `everwood-faq-cloud` (o el que prefieras)
4. Habilita **Firestore Database** (modo prueba)
5. Habilita **Storage** (modo prueba)
6. En **Project Settings → Your Apps → Web**, copia el objeto `firebaseConfig`

### 2. Pega tus credenciales

Abre `public/js/firebase-config.js` y reemplaza los valores:

```js
export const FIREBASE_CONFIG = {
  apiKey:            "AIzaSy...",
  authDomain:        "mi-proyecto.firebaseapp.com",
  projectId:         "mi-proyecto",
  storageBucket:     "mi-proyecto.appspot.com",
  messagingSenderId: "123456789",
  appId:             "1:123456789:web:abc..."
};
```

### 3. Reglas de seguridad (modo prueba)

En la consola de Firebase, establece las reglas de Firestore y Storage en **modo prueba** para las pruebas iniciales:

**Firestore:**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**Storage:**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

## 🚀 Despliegue en Firebase Hosting

```bash
# Instalar Firebase CLI (solo una vez)
npm install -g firebase-tools

# Iniciar sesión
firebase login

# Desplegar
firebase deploy
```

Obtendrás una URL pública del tipo: `https://TU_PROYECTO.web.app`

## ✅ Funcionalidades implementadas

| Requisito | Estado |
|---|---|
| Carga de archivos CSV, JSON, TXT | ✅ |
| Validación: sin archivo, formato incorrecto, error | ✅ |
| Guardado en Firebase Storage | ✅ |
| Registro de metadatos en Firestore | ✅ |
| Historial de cargas con tabla | ✅ |
| Interfaz interactiva con alertas y progreso | ✅ |

## 📋 Metadatos registrados por carga

- `fileName` — Nombre del archivo
- `uploadDate` — Fecha y hora de carga (servidor)
- `fileType` — MIME type
- `fileExt` — Extensión (CSV / JSON / TXT)
- `fileSize` — Tamaño en bytes
- `fileSizeFmt` — Tamaño formateado (KB / MB)
- `responsible` — Nombre del responsable o grupo
- `observations` — Observaciones opcionales
- `status` — Estado: `uploaded` / `processing` / `processed` / `error`
- `downloadURL` — URL pública del archivo en Storage
- `storagePath` — Ruta interna en Storage
