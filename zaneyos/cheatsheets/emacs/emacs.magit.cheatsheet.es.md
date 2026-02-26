[English](./emacs.magit.cheatsheet.md) | Español

# Cheatsheet de Magit para Doom Emacs
## 🚀 **¿Qué es Magit?**

Magit es una herramienta extremadamente poderosa para gestionar tu proyecto de Git.

- Flujos de trabajo de Git visuales e interactivos
- Prepara para confirmación (stage) fragmentos (hunks), líneas o archivos completos con facilidad
- Confirma (commit), empuja (push), trae (pull), fusiona (merge), reorganiza (rebase) - todo desde menús intuitivos
- Ve el estado de tu repositorio de un vistazo

## 📋 **Requisitos**

- Git instalado en tu sistema
- Doom Emacs con Magit habilitado (incluido por defecto)
- Estar trabajando dentro de un repositorio de Git

## ⌨️ **Abriendo Magit**

### **Interfaz Principal de Magit:**

- `SPC g g` - **Estado de Magit** (¡tu comando principal!)
- `SPC g d` - **Despacho de archivos de Magit**
- `SPC g f` - **Comandos de archivo de Magit**
- `SPC g l` - **Registro (log) de Magit**
- `SPC g b` - **Culpar (blame) de Magit**

## 🎯 **El Búfer de Estado de Magit** (Tu Centro de Mando)

### **Navegación:**

- `j/k` o `n/p` - **Moverse arriba/abajo** entre secciones
- `TAB` - **Expandir/contraer** la sección bajo el cursor
- `M-TAB` - **Expandir/contraer** todas las secciones
- `g` - **Refrescar** el búfer de estado

### **Resumen de Secciones:**

```
Archivos sin seguimiento - Archivos que no están en Git
Cambios sin preparar     - Archivos modificados no preparados para confirmación
Cambios preparados       - Archivos listos para confirmar
Confirmaciones recientes - Tu historial de confirmaciones
Aliijos (Stashes)        - Tu trabajo en progreso guardado
```

## 📝 **Preparando y Despreparando (Staging & Unstaging)**

### **Preparar Archivos:**

- `s` - **Preparar** archivo/fragmento bajo el cursor
- `S` - **Preparar todos** los cambios sin preparar
- `i` - **Ignorar** archivo (añadir a .gitignore)

### **Despreparar Archivos:**

- `u` - **Despreparar** archivo/fragmento bajo el cursor
- `U` - **Despreparar todos** los cambios preparados

### **Descartar Cambios:**

- `k` - **Descartar** cambios en el archivo/fragmento bajo el cursor
- `K` - **Descartar todos** los cambios en el directorio de trabajo

### **Preparando Fragmentos y Líneas:**

- `RET` o `SPC` - **Mostrar diferencias (diff)** del archivo bajo el cursor
- En la vista de diferencias:
  - `s` - **Preparar fragmento** bajo el cursor
  - `u` - **Despreparar fragmento** bajo el cursor
  - `k` - **Descartar fragmento** bajo el cursor
  - `+/-` - **Mostrar más/menos** líneas de contexto

## 💾 **Confirmando (Committing)**

### **Crear Confirmaciones:**

- `c c` - **Confirmar** (abre el búfer de mensaje de confirmación)
- `c a` - **Enmendar** la última confirmación
- `c e` - **Extender** la última confirmación (sin cambio de mensaje)
- `c w` - **Reescribir** el mensaje de la última confirmación
- `c f` - **Arreglar (fixup)** una confirmación
- `c s` - **Aplastar (squash)** una confirmación

### **En el Búfer de Mensaje de Confirmación:**

- `C-c C-c` - **Finalizar confirmación**
- `C-c C-k` - **Cancelar confirmación**
- `M-p/M-n` - **Mensaje de confirmación anterior/siguiente** del historial

## 🌿 **Ramas y Cambio (Branching & Switching)**

### **Operaciones con Ramas:**

- `b b` - **Cambiar de rama** (checkout)
- `b c` - **Crear nueva rama**
- `b n` - **Crear rama** desde el HEAD actual
- `b s` - **Crear rama** y cambiar a ella
- `b r` - **Renombrar rama**
- `b k` - **Eliminar rama**

### **Ramas Remotas:**

- `b a` - **Establecer rama de seguimiento (upstream)** para la rama actual
- `b u` - **Establecer rama de seguimiento** y empujar

## 🔄 **Operaciones Remotas**

### **Traer y Actualizar (Fetch & Pull):**

- `f f` - **Traer** desde el remoto predeterminado
- `f a` - **Traer desde todos** los remotos
- `F F` - **Actualizar** desde la rama de seguimiento
- `F u` - **Actualizar desde la rama de seguimiento** (rebase)

### **Empujar (Push):**

- `P P` - **Empujar** a la rama de seguimiento
- `P u` - **Empujar y establecer rama de seguimiento**
- `P f` - **Forzar empuje** (¡úsalo con cuidado!)
- `P t` - **Empujar etiquetas**

## 📚 **Viendo Historial y Registros**

### **Vistas de Registro:**

- `l l` - **Mostrar registro** para la rama actual
- `l o` - **Mostrar registro** para otras ramas
- `l h` - **Mostrar registro** para HEAD
- `l a` - **Mostrar registro** para todas las ramas
- `l f` - **Mostrar registro** para el archivo bajo el cursor

### **En la Vista de Registro:**

- `RET` - **Mostrar detalles** de la confirmación
- `d d` - **Mostrar diferencias** para la confirmación
- `c c` - **Crear nueva confirmación**
- `r r` - **Revertir confirmación**

## 🔍 **Diferencias y Comparaciones**

### **Comandos de Diferencias:**

- `d d` - **Diferencias del directorio de trabajo** vs preparado
- `d s` - **Diferencias de lo preparado** vs HEAD
- `d u` - **Diferencias de los cambios sin preparar**
- `d r` - **Diferencias de un rango** entre confirmaciones

### **En las Vistas de Diferencias:**

- `j/k` - **Navegar** entre fragmentos
- `n/p` - **Archivo siguiente/anterior**
- `TAB` - **Alternar** visibilidad de la sección de diferencias
- `+/-` - **Aumentar/disminuir** líneas de contexto

## 🔧 **Reorganizando y Fusionando (Rebasing & Merging)**

### **Fusionar:**

- `m m` - **Fusionar** rama
- `m a` - **Abortar fusión**
- `m c` - **Continuar fusión**

### **Reorganizar:**

- `r i` - **Reorganización interactiva**
- `r r` - **Reorganizar** rama
- `r a` - **Abortar reorganización**
- `r c` - **Continuar reorganización**

### **Durante la Reorganización Interactiva:**

- `j/k` - **Moverse** entre confirmaciones
- `p` - **Elegir (pick)** confirmación (predeterminado)
- `r` - **Reescribir (reword)** mensaje de confirmación
- `e` - **Editar (edit)** confirmación
- `s` - **Aplastar (squash)** confirmación
- `f` - **Arreglar (fixup)** confirmación
- `d` - **Descartar (drop)** confirmación

## 📦 **Aliijos (Stashing)**

### **Operaciones con Aliijos:**

- `z z` - **Alijar** los cambios actuales
- `z i` - **Alijar** con mensaje
- `z a` - **Aplicar alijo**
- `z p` - **Sacar alijo** (aplicar y eliminar)
- `z k` - **Descartar alijo**
- `z l` - **Listar alijos**

## 🏷️ **Etiquetas (Tags)**

### **Operaciones con Etiquetas:**

- `t t` - **Crear etiqueta**
- `t a` - **Crear etiqueta anotada**
- `t k` - **Eliminar etiqueta**
- `t p` - **Empujar etiqueta**

## ⚡ **Consejos Profesionales y Flujos de Trabajo**

### **Flujo de Trabajo Diario de Git:**

1. `SPC g g` - **Abrir estado de Magit**
2. Revisar cambios, preparar con `s`
3. `c c` - **Confirmar cambios**
4. `P P` - **Empujar al remoto**

### **Trucos de Usuario Avanzado:**

- Usa `M-x magit-find-file` para abrir rápidamente archivos del historial de Git
- `SPC g f s` - **Preparar archivo actual** sin abrir Magit
- `SPC g f u` - **Despreparar archivo actual**
- `SPC g f d` - **Mostrar diferencias del archivo**

### **Granularidad de la Preparación:**

- Prepara archivos completos con `s` en el búfer de estado
- Prepara fragmentos individuales entrando en la vista de diferencias (`RET`) y luego `s`
- Prepara líneas individuales seleccionando una región en la diferencia y luego `s`

### **Buenas Prácticas de Confirmación:**

- Usa `c c` para confirmaciones normales
- Usa `c a` para arreglar tu última confirmación
- Usa `c f` para crear confirmaciones de arreglo para una reorganización interactiva posterior

## 🔧 **Solución de Problemas**

### **Problemas Comunes:**

- **¿Magit no se abre?** Asegúrate de estar en un repositorio de Git
- **¿Rendimiento lento?** Prueba `M-x magit-refresh` o reinicia Emacs
- **¿Conflictos de fusión?** Magit resalta los conflictos - resuélvelos y usa `m c`

### **Obteniendo Ayuda:**

- `?` - **Mostrar ayuda** en cualquier búfer de Magit
- `C-h m` - **Mostrar ayuda del modo**
- `SPC h d m magit` - **Documentación completa de Magit**

## 🚀 **Flujo de Trabajo de Inicio Rápido**

1. **Navega a tu repositorio de Git** en Doom Emacs
2. **Presiona `SPC g g`** - Abre el estado de Magit
3. **Prepara archivos** con `s`, revisa las diferencias con `RET`
4. **Confirma** con `c c`, escribe el mensaje, finaliza con `C-c C-c`
5. **Empuja** con `P P`

## 📚 **Resumen de Atajos Esenciales**

| Acción    | Tecla     | Descripción          |
| --------- | --------- | -------------------- |
| Estado    | `SPC g g` | Abrir estado de Magit|
| Preparar  | `s`       | Preparar archivo/fragmento |
| Despreparar| `u`       | Despreparar archivo/fragmento |
| Confirmar | `c c`     | Crear confirmación   |
| Empujar   | `P P`     | Empujar a la rama de seguimiento |
| Actualizar| `F F`     | Actualizar desde la rama de seguimiento |
| Rama      | `b b`     | Cambiar de rama      |
| Registro  | `l l`     | Mostrar registro     |
| Diferencias| `d d`     | Mostrar diferencias  |
| Alijar    | `z z`     | Alijar cambios       |
| Ayuda     | `?`       | Mostrar ayuda contextual |

## 🎉 **Por Qué Magit es Increíble**

- **Visual**: Ve todo el estado de tu repositorio de un vistazo
- **Interactivo**: Prepara fragmentos, líneas o archivos con simples pulsaciones de teclas
- **Rápido**: Navega por las operaciones de Git más rápido que cualquier CLI
- **Potente**: Accede a todas las funciones de Git a través de menús intuitivos
- **Integrado**: Funciona perfectamente con Doom Emacs y el modo Evil

**Consejo Profesional**: Una vez que aprendas Magit, ¡nunca más querrás usar Git desde la línea de comandos! 🚀
