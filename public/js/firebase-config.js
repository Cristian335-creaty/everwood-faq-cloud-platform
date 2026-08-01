// Solo exporta el objeto de configuracion.
// Las importaciones de Firebase se hacen en cada pagina via CDN.
//
// Nota de seguridad: el campo apiKey de una app web de Firebase es un
// identificador publico del proyecto, no un secreto de servidor, por lo
// que es normal que quede visible en el codigo fuente/bundle del cliente.
// La proteccion real de este proyecto se logra restringiendo esta clave
// por dominio/HTTP referrer en Google Cloud Console (APIs y servicios >
// Credenciales) y mediante las reglas de seguridad definidas en
// firestore.rules (en la raiz del repositorio).

export const FIREBASE_CONFIG = {
    apiKey: "AIzaSyDEBPyiLuaLrfKNtlM3hh-m8A9iUaNzmR0",
    authDomain: "everwood-faq-cloud-1cde3.firebaseapp.com",
    projectId: "everwood-faq-cloud-1cde3",
    storageBucket: "everwood-faq-cloud-1cde3.firebasestorage.app",
    messagingSenderId: "611470402950",
    appId: "1:611470402950:web:affa19c24ea29ddc60f807",
    measurementId: "G-KQPSQL0HVC"
};
