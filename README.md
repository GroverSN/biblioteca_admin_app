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

## 📈 Lógica General del Flujo del Sistema

A continuación, se detalla de forma síncrona cómo viajan los datos desde que el usuario interactúa con la interfaz, realiza búsquedas en tiempo real, edita registros o elimina elementos de forma segura.

```mermaid
sequenceDiagram
    autonumber
    actor U as Alejandro (Usuario/Admin)
    participant UI as Pantalla Principal (Screens)
    participant W as Widgets Personalizados (Cards)
    participant LM as Listas en Memoria (_all/_filtered)
    participant Form as Formulario (BottomSheet)

    %% Inicio del Sistema
    Note over U, LM: Inicialización del Sistema
    U->>UI: Entra a Gestión (Usuarios / Inventario)
    UI->>LM: Carga síncrona inicial (initState)
    LM-->>UI: Devuelve elementos (ej. length = 3)
    UI->>W: Renderiza tarjetas dinámicamente usando itemCount

    %% Flujo de Búsqueda
    Note over U, LM: Flujo de Búsqueda en Tiempo Real
    U->>UI: Escribe en la barra de búsqueda
    UI->>LM: Filtra elementos en _filteredList
    LM-->>UI: Actualiza el estado (setState)
    UI->>W: Redibuja solo las tarjetas coincidentes

    %% Flujo de Edición
    Note over U, Form: Flujo de Edición de Datos
    U->>W: Clic en botón Editar (Lápiz)
    W->>UI: Dispara onEdit con el índice
    UI->>Form: Despliega BottomSheet con datos precargados
    U->>Form: Modifica datos y guarda
    Form->>LM: Actualiza el objeto específico
    LM-->>UI: Refresca la UI con los nuevos datos

    %% Flujo de Eliminación Seguro
    Note over U, LM: Flujo de Eliminación Síncrono Seguro
    U->>W: Clic en botón Eliminar (Basurero)
    W->>UI: Dispara onDelete pasando el Objeto directo
    UI->>LM: Remueve objeto de _allList y _filteredList
    LM-->>UI: Reduce el length e invoca setState()
    UI->>U: Desaparece la tarjeta de la pantalla (Cero errores)


   1.  **Modularidad y Acoplamiento Débil:** Se aplicó una arquitectura limpia dividiendo las responsabilidades. Separamos las pantallas de gestión (Screens) de los componentes visuales repeti tivos, encapsulando estos últimos en widgets personalizados independientes (UsuarioCard y LibroCard). Esto otorga un acoplamiento débil; si se decide cambiar el diseño de las tarjetas, no se altera la lógica de control de la pantalla.

   2. Manejo Seguro del Estado (Mitigación de RangeError): La lógica del flujo general se maneja de forma estrictamente síncrona mediante dos listas en memoria por pantalla: una lista maestra (_allList) y una lista de renderizado dinámico (_filteredList). El sistema asegura la estabilidad al sincronizar ambas listas en el initState y al asociar obligatoriamente la propiedad itemCount del ListView.builder al tamaño real de la lista filtrada.

   3. Eliminación por Referencia Directa: Al ejecutar una acción de eliminación, el widget delega el evento mediante un callback síncrono pasando directamente la referencia del objeto completo, y no su índice numérico. Al hacer .remove(objeto) dentro de un setState, ambas listas se actualizan y el árbol de widgets se redibuja recalculando el tamaño exacto al instante, lo que mitiga de raíz cualquier posibilidad de lanzar un error de índice fuera de rango (RangeError).

   4. Optimización de la UI en Tiempo Real: El flujo contempla búsquedas en tiempo real. Cada interacción en la barra de filtrado ejecuta una función síncrona que reduce el tamaño de _filteredList. Flutter, al detectar el cambio de estado, redibuja únicamente las tarjetas afectadas en la interfaz, ofreciendo una experiencia de usuario sumamente fluida y reactiva.

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

