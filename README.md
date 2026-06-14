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

## 🛠️ Instrucciones para el Integrante D

**Rol Asignado:** Estructura de Datos y UI Avanzada.
**Tu Misión:** Debes encapsular la lógica actual que se encuentra en variables locales emparejadas dentro de los componentes y abstraerla hacia **Modelos de Datos formalizados** y **Widgets modulares reutilizables** para limpiar y optimizar el código fuente.

### 📦 Tareas Técnicas Requeridas:
1. **Creación de Modelos (`lib/models/`):**
   - `usuario.dart`: Definir la clase `Usuario` con atributos (`id`, `nombre`, `rol`) y un método constructor.
   - `libro.dart`: Definir la clase `Libro` con atributos (`codigo`, `titulo`, `autor`) y un método constructor.
2. **Abstracción de Listas Temporales:** Migrar las listas de mapas planos actuales (`List<Map<String, String>>`) hacia listas de objetos basados en tus nuevos modelos (`List<Usuario>` y `List<Libro>`).
3. **Modularización de UI (`lib/widgets/`):** Extraer los componentes repetitivos o complejos como las tarjetas personalizadas de las listas (`ListTile` adaptativos) y los campos de entrada de texto estilizados (`TextFormField` con su padding interno) hacia archivos independientes en la carpeta de widgets para desacoplar el código de las pantallas.

---

## 🤖 Prompts Guía para la Inteligencia Artificial (Copia y pega esto en tu IA)

Para completar tus tareas de la misma manera limpia, precisa y estética en que se estructuró el código base, utiliza los siguientes prompts específicos con tu asistente de IA:

### 🔹 Prompt 1: Creación de Modelos y Refactorización de Listas
> *"Estoy trabajando en un proyecto de Flutter Web/Móvil que opera de forma autónoma en memoria interna. Actualmente las pantallas `usuarios_screen.dart` y `libros_screen.dart` manejan la información usando una lista estructurada como `List<Map<String, String>> _allUsuarios = [...]`. Necesito que crees el archivo de modelo independiente `lib/models/usuario.dart` con una clase limpia que maneje ID, Nombre y Rol. Explícame de forma muy precisa cómo debo cambiar el tipado en la pantalla principal de la lista de mapas a una lista de objetos de este nuevo modelo sin romper los métodos de filtrado síncronos de la barra de búsqueda."*

### 🔹 Prompt 2: Modularización de Componentes de Interfaz
> *"En mi pantalla de gestión de usuarios en Flutter, tengo un `ListView.builder` que renderiza tarjetas de personal utilizando un `AnimatedContainer` que cambia de color de fondo adaptándose dinámicamente si el tema es Dark o Light (`Theme.of(context).brightness`), además de badges de colores personalizados para los roles. Quiero extraer todo este ítem de la lista a un widget personalizado y reutilizable en `lib/widgets/usuario_card.dart`. Dame el código modular exacto asegurándote de pasarle las propiedades necesarias mediante el constructor para mantener la consistencia estética y que soporte el cambio de modo oscuro perfectamente."*

---

## 📈 Lógica General del Flujo del Sistema

Para el documento explicativo de la entrega, la interacción lógica de las pantallas y el flujo de los datos en memoria se rige bajo la siguiente arquitectura:

┌─────────────────────────────┐
                 │     DASHBOARD PRINCIPAL     │◄──────────────────┐
                 │  (Menú de Navegación y      │                   │
                 │   Control de Modo Oscuro)   │                   │
                 └──────┬───────────────┬──────┘                   │
                        │               │                          │
    ┌───────────────────┘               └───────────────────┐      │
    ▼ (Clic: Gestión Usuarios)                              ▼ (Clic: Inventario Libros)
┌───────────────────────────────┐                       ┌───────────────────────────────┐
│        usuarios_screen        │                       │         libros_screen         │
│  (Lista de Personal Técnico)  │                       │ (Catálogo de Obras Físicas)   │
└──────┬─────────────────┬──────┘                       └──────┬─────────────────┬──────┘
│                 │                                     │                 │
│                 │ (Filtrado Síncrono)                 │                 │ (Filtrado Síncrono)
│                 ▼                                     │                 ▼
│         [Caja de Búsqueda]                            │         [Caja de Búsqueda]
│         Filtra por Nombre o ID                        │         Filtra por Título/Autor
│                                                       │
▼ (Clic: Botón "+" o "Editar")                          ▼ (Clic: Botón FAB o "Editar")
┌───────────────────────────────┐                       ┌───────────────────────────────┐
│  AlertDialog (Formulario UI)  │                       │  AlertDialog (Formulario UI)  │
│  - Encapsulado en             │                       │  - Ancho Fijo de 400px        │
│    StatefulBuilder            │                       │  - Espaciado Interno Amplio   │
│  - Control de Rol (Dropdown)  │                       │  - Campos de Texto Validados  │
└──────────────┬────────────────┘                       └──────────────┬────────────────┘
│                                                       │
▼ (Clic: Registrar/Actualizar)                          ▼ (Clic: Guardar/Actualizar)
┌─────────────────────────────┐                         ┌─────────────────────────────┐
│  - Valida Campos del Form   │                         │  - Valida Campos del Form   │
│  - Inserta/Modifica el Mapa │                         │  - Inserta/Modifica el Mapa │
│    en la Lista Local        │                         │    en la Lista Local        │
│  - Cierra Cuadro de Diálogo │                         │  - Cierra Cuadro de Diálogo │
└─────────────┬───────────────┘                         └─────────────┬───────────────┘
│                                                       │
└─────────────────►[ Retorna el Foco ]◄─────────────────┘
(Redibuja la UI con los
nuevos datos en memoria)

> 💡 **Nota para la Documentación:** Para generar el diagrama vectorial del informe final, ingresa a [mermaid.live](https://mermaid.live/), pega el bloque de código que se encuentra documentado en la bitácora de desarrollo interna, ajústate a los estilos azul/teal institucionales y descarga la imagen en alta definición (PNG) para incluirla en la sección 3 del PDF del grupo.

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

