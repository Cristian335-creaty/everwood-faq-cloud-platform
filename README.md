# Everwood FAQ Cloud 🌲

Plataforma cloud para cargar, almacenar y gestionar conversaciones históricas de Everwood.
Permite registrar archivos CSV, JSON y TXT, guardarlos en Firestore y generar sugerencias de FAQs.

## 🌐 URL del despliegue
> https://everwood-faq-cloud-1cde3.web.app

## 📁 Repositorio
> https://github.com/TU_USUARIO/Proyecto_Cloud

---

## 🗂 Estructura del proyecto

```
Proyecto_Cloud/
├── public/
│   ├── index.html          # Landing / pantalla principal
│   ├── upload.html         # Carga de archivos con validación
│   ├── history.html        # Historial de cargas con metadatos
│   ├── detail.html         # Detalle individual de cada carga
│   ├── faqs.html           # Generador y validador de FAQs
│   ├── css/
│   │   └── styles.css      # Sistema de diseño global (dark mode)
│   └── js/
│       └── firebase-config.js   # Credenciales Firebase
├── firebase.json           # Configuración Firebase Hosting
├── .firebaserc             # ID del proyecto Firebase
└── .gitignore
```

---

## ✅ Funcionalidades implementadas

| Requisito | Estado | Descripción |
|---|---|---|
| Carga CSV / JSON / TXT | ✅ | Drag-and-drop + selector de archivo |
| Validación de advertencias | ✅ | Sin archivo · Formato incorrecto · Error · Éxito |
| Guardado en la nube | ✅ | Firestore (plan Spark gratuito) |
| Registro de metadatos | ✅ | 10 campos por documento |
| Historial de cargas | ✅ | Tabla con filtros, descarga y preview |
| Detalle de una carga | ✅ | Página individual con todos los metadatos |
| Interfaz interactiva | ✅ | Alertas, barra de progreso, badges de estado |
| Despliegue en la nube | ✅ | Firebase Hosting — URL pública |
| Generación de FAQs | ✅ | Algoritmo de palabras clave por categorías |
| Validación humana FAQs | ✅ | Aprobar / Editar / Rechazar + guardar en Firestore |

---

## 📋 Metadatos registrados por carga

| Campo | Descripción |
|---|---|
| `fileName` | Nombre del archivo |
| `uploadDate` | Fecha y hora de carga (servidor Firestore) |
| `fileType` | MIME type del archivo |
| `fileExt` | Extensión: CSV / JSON / TXT |
| `fileSize` | Tamaño en bytes |
| `fileSizeFmt` | Tamaño legible (KB / MB) |
| `responsible` | Responsable o grupo que realizó la carga |
| `observations` | Observaciones opcionales |
| `status` | Estado: uploaded / processing / processed / error |
| `fileContent` | Contenido completo del archivo (para descarga) |
| `preview` | Vista previa de los primeros 500 caracteres |
| `storageType` | Tipo de almacenamiento: `firestore` |

---

## 🤖 Algoritmo de generación de FAQs

No requiere IA externa. El sistema analiza el texto de las conversaciones buscando
palabras clave agrupadas en **6 categorías**:

| Categoría | Palabras clave detectadas |
|---|---|
| 💰 Precios y tarifas | precio, costo, tarifa, descuento, gratis... |
| 🔧 Soporte técnico | problema, error, no funciona, bug, ayuda... |
| 🕐 Horarios | horario, hora, disponible, abierto, cierre... |
| 🔄 Cancelaciones | cancelar, reembolso, devolución, baja... |
| ⚙️ Configuración | configurar, instalar, contraseña, cuenta... |
| 🧑‍💼 Atención al cliente | asesor, humano, chat, teléfono, correo... |

Por cada categoría detectada genera **1-3 preguntas frecuentes** según relevancia.
El usuario puede **aprobar, editar o rechazar** cada sugerencia. Las aprobadas
se guardan en la colección `faqs` de Firestore.

---

## ☁️ Arquitectura cloud

```
Navegador (HTML + JS + Firebase SDK CDN)
        │
        ▼
Firebase Hosting (URL pública)
        │
        ├── Firestore (colección: uploads)
        │       └── Documentos: metadatos + contenido de archivos
        │
        └── Firestore (colección: faqs)
                └── Documentos: FAQs aprobadas/editadas
```

---

## 🚀 Despliegue local

```powershell
# Instalar servidor local (solo una vez)
npm install -g live-server

# Correr la app
live-server public --port=3000
```
Abrir: http://127.0.0.1:3000

## 🚀 Despliegue en Firebase Hosting

```powershell
npm install -g firebase-tools
firebase login
firebase deploy --only hosting
```

---

## 🔒 Seguridad y reglas de Firestore

Este proyecto usaba inicialmente las reglas de Firestore en modo prueba (`allow read, write: if true`), lo que dejaba la base de datos completamente abierta a lectura y escritura publica. Esa configuracion ya fue corregida a nivel de codigo: el archivo `firestore.rules` en la raiz del repositorio define reglas mas seguras, que permiten lectura publica (necesaria para mostrar historial y FAQs) pero bloquean la modificacion o borrado de documentos ya existentes por parte de terceros.

Para que la correccion tenga efecto en el proyecto real hace falta desplegar las reglas con el CLI de Firebase, ya autenticado con la cuenta del propietario del proyecto:

```powershell
firebase deploy --only firestore:rules
```

Nota sobre la API key de Firebase en `public/js/firebase-config.js`: en las apps web de Firebase esa clave es un identificador publico del proyecto (no es un secreto de servidor), por lo que su presencia en el codigo fuente es esperada por diseno. La proteccion real se logra restringiendo esa clave por dominio/HTTP referrer en Google Cloud Console (APIs y servicios > Credenciales) y con las reglas de seguridad de Firestore/Storage, que es justamente lo que este archivo `firestore.rules` corrige.
