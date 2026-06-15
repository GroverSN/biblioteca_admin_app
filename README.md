# 📚 Sistema de Biblioteca - Módulo Administrativo (Gestión de Usuarios e Inventario)

Este proyecto contempla el desarrollo de las aplicaciones **Intermedia (Gestión y Control de Usuarios)** y **Avanzada (Inventario de Libros)** desarrolladas en **Flutter (Multiplataforma: Web/Mobile)** para el personal administrativo de la biblioteca. El sistema está diseñado bajo una arquitectura limpia, funciona 100% offline y gestiona los datos de manera síncrona en memoria volátil.

---


## 🚀 Estado Actual del Proyecto (Avance Implementado)

Se ha completado e implementado de manera robusta toda la lógica funcional de las vistas principales, el control de temas y las interfaces del CRUD:

1. **Dashboard Principal:** Menú centralizado con navegación fluida y alternancia global entre **Modo Claro** y **Modo Oscuro**.
2. **Módulo de Usuarios (`usuarios_screen.dart`):** - Operaciones CRUD completas (Crear, Leer, Editar, Eliminar) en memoria local a través de estructuras `List<Map<String, String>>`.
   - Motor de búsqueda predictivo en milisegundos por Nombre o ID.
   - Solución a excepciones nulas (`Unexpected null value`) en Flutter Web reemplazando componentes interactivos inestables por contenedores personalizados (`BoxDecoration`).
   - Aislamiento de estados del formulario modal mediante `StatefulBuilder` para que el selector de roles cambie sin congelar la interfaz.
3. **Módulo de Libros (`libros_screen.dart`):**
   - Panel adaptativo al Modo Oscuro (`0xFF121212`) para mantener la coherencia de accesibilidad.
   - Buscador predictivo por Título o Autor.
   - Formulario expandido y ergonómico dentro de un `SizedBox` de `400px` con un `ListView(shrinkWrap: true)` para evitar la compresión de los textfields en navegadores web.

---

## 🚀 Características Principales
* **Gestión Síncrona:** Flujo de datos optimizado para evitar errores de memoria.
* **Búsqueda en Tiempo Real:** Filtros dinámicos sin latencia.
* **Modularidad:** Estructura limpia basada en componentes reutilizables (`widgets`).
* **Seguridad:** Eliminación de datos basada en referencias de objetos, garantizando cero errores de índice.

---

## 📈 Lógica del Flujo del Sistema
Este diagrama ilustra cómo el sistema gestiona la interacción del usuario con los datos, asegurando una experiencia estable mediante la sincronización de estados:

![Flujo del Sistema](assets/Logica_del_Flujo_del_Sistema.png)


---

## 🛠️ Estructura Técnica
Nuestro proyecto se organiza de la siguiente manera para facilitar el mantenimiento:

- `lib/models/`: Definición de clases de datos (`Usuario`, `Libro`).
- `lib/screens/`: Pantallas principales de gestión.
- `lib/widgets/`: Componentes visuales independientes.

---

## 💡 Sustentación Técnica
Para la defensa y documentación del proyecto, resaltamos tres pilares:

1. **Modularidad:** Acoplamiento débil mediante widgets independientes.
2. **Estabilidad:** Uso de `itemCount` vinculado a listas filtradas para eliminar el `RangeError`.
3. **Optimización:** Redibujado selectivo de componentes mediante `setState` al eliminar objetos por referencia.

---
## 🛠️ Flujo de Trabajo en Git / GitHub

Para descargar el código que acabo de subir, integrar tus cambios y mantener el repositorio sincronizado sin conflictos, sigue estrictamente estos comandos en tu terminal de Git:

1. **Clonar u Obtener los últimos cambios del repositorio:**
   Si ya tienes el proyecto localmente, asegúrate de situarte en tu rama principal y descargar la última versión limpia que acabo de desplegar:
   ```bash
   git checkout main
   git pull origin main

2. Crear tu propia rama de trabajo: No trabajes directamente sobre main. Crea una rama específica para tus modelos y widgets:
    git checkout -b feature/modelos-y-widgets

3. Subir tus cambios al terminar:
    Cuando verifiques que el proyecto compila perfectamente en web/móvil ejecutando flutter run, añade tus archivos, haz el commit con una descripción clara y súbelo a GitHub:
    git add .
    git commit -m "feat: implementar modelos de datos y modularizar componentes de la UI"
    git push origin feature/modelos-y-widgets

