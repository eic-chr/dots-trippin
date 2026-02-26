[English](./emacs.getting-started.top10.md) | Español

# Las 10 Cosas Principales que los Nuevos Usuarios de Doom Emacs Deberían Saber
## 🚀 **Primeros Pasos con Doom Emacs**

¡Bienvenido a Doom Emacs! Aquí están las 10 cosas más esenciales que todo nuevo usuario debería dominar para ser productivo rápidamente.

---

## 1. 🗝️ **Domina la Tecla Líder: `SPC`**

**La tecla Espacio es tu puerta de entrada a todo en Doom Emacs.**

- `SPC` se llama la "tecla líder" - abre menús para casi todas las acciones
- Después de presionar `SPC`, verás sugerencias útiles que muestran los comandos disponibles
- Los comandos están organizados lógicamente: `SPC f` para archivos, `SPC g` para git, `SPC p` para proyectos

**Comandos esenciales para empezar:**

- `SPC f f` - Buscar/abrir archivos
- `SPC f s` - Guardar archivo actual
- `SPC q q` - Salir de Emacs
- `SPC h` - Menú de ayuda (¡muy importante!)

**Consejo Profesional:** Si olvidas lo que sigue, simplemente presiona `SPC` y espera - ¡Doom te mostrará las opciones!

---

## 2. 📁 **Navega por los Archivos como un Profesional**

**La navegación de archivos es fundamental para la productividad.**

- `SPC .` - **Abrir explorador de archivos** (Dired) en el directorio actual
- `SPC f f` - **Buscar archivo** en cualquier parte de tu sistema
- `SPC f r` - **Archivos recientes** en los que has trabajado
- `SPC SPC` - **Buscar archivo en el proyecto actual** (¡súper útil!)

📋 _Consulta la guía completa: `emacs.file-explorer.cheatsheet.md`_

**Flujo de trabajo rápido:**

1. Abre el directorio de tu proyecto en la terminal
2. Inicia Emacs: `emacs` (o `emacsclient -c` para GUI, `et` para TTY)
3. Usa `SPC .` para explorar archivos o `SPC SPC` para encontrar archivos rápidamente

---

## 3. ⌨️ **Entiende el Modo Evil (Atajos de Teclado de Vim)**

**Doom Emacs usa atajos de teclado al estilo de Vim por defecto.**

**Movimiento básico (en modo Normal):**

- `h j k l` - Izquierda, abajo, arriba, derecha
- `w` - Saltar a la siguiente palabra
- `b` - Saltar una palabra hacia atrás
- `gg` - Ir al principio del archivo
- `G` - Ir al final del archivo

**Cambio de modo:**

- `i` - Entrar en modo de Inserción (para escribir texto)
- `ESC` - Volver al modo Normal
- `v` - Modo Visual (para seleccionar texto)

**Si no estás familiarizado con Vim:** ¡No te asustes! Puedes aprender gradualmente. Lo básico anterior te ayudará a empezar.

---

## 4. 🔍 **Busca y Reemplaza Eficientemente**

**Encontrar y cambiar texto es una tarea diaria.**

- `/` - Buscar hacia adelante en el búfer actual
- `?` - Buscar hacia atrás en el búfer actual
- `n/N` - Resultado de búsqueda siguiente/anterior
- `SPC s s` - Buscar en el búfer actual (interactivo)
- `SPC s p` - Buscar en todo el proyecto
- `SPC s r` - Buscar y reemplazar en el búfer actual

**Para búsquedas en todo el proyecto:** `SPC s p` es increíblemente poderoso para encontrar código en todo tu proyecto.

---

## 5. 🗂️ **Trabaja con Búferes y Ventanas**

**Los búferes son archivos abiertos, las ventanas son cómo los ves.**

**Gestión de búferes:**

- `SPC b b` - Cambiar entre búferes abiertos
- `SPC b k` - Matar (cerrar) el búfer actual
- `SPC b s` - Guardar el búfer actual

**Gestión de ventanas:**

- `SPC w v` - Dividir la ventana verticalmente
- `SPC w s` - Dividir la ventana horizontalmente
- `SPC w c` - Cerrar la ventana actual
- `SPC w w` - Cambiar entre ventanas
- `C-h j/k/h/l` - Navegar entre ventanas (estilo Vim)

**Piénsalo de esta manera:** Puedes tener muchos archivos abiertos (búferes) pero solo ver algunos de ellos a la vez (ventanas).

---

## 6. 🛠️ **Configura y Personaliza Doom**

**Doom es altamente configurable, pero empieza de forma sencilla.**

**Archivos clave que debes conocer:**

- `~/.doom.d/config.el` - Tu configuración personal
- `~/.doom.d/init.el` - Habilitar/deshabilitar módulos de Doom
- `~/.doom.d/packages.el` - Añadir paquetes adicionales

**Comandos esenciales:**

- `SPC h r r` - Recargar la configuración de Doom
- `SPC h d h` - Ayuda y documentación de Doom
- `doom doctor` - Comprobar si hay problemas de configuración (ejecutar en la terminal)
- `doom upgrade` - Actualizar Doom (ejecutar en la terminal)

**Empieza poco a poco:** No intentes personalizar todo de una vez. Usa primero los valores predeterminados de Doom y luego ajusta las cosas gradualmente.

---

## 7. 📝 **Domina los Conceptos Básicos de Edición de Texto**

**Comandos de edición esenciales que funcionan en cualquier modo.**

**En modo Normal (Evil):**

- `x` - Eliminar el carácter bajo el cursor
- `dd` - Eliminar la línea entera
- `yy` - Copiar (yank) la línea entera
- `p` - Pegar después del cursor
- `u` - Deshacer
- `C-r` - Rehacer

**En modo de Inserción:**

- `C-w` - Eliminar palabra hacia atrás
- `C-u` - Eliminar hasta el principio de la línea

**Selección y manipulación:**

- `v` - Iniciar selección visual
- `V` - Seleccionar la línea entera
- `d` - Eliminar el texto seleccionado
- `y` - Copiar el texto seleccionado

---

## 8. 💻 **Usa la Autocompletación de Código y las Funciones del Lenguaje**

**Doom viene con un excelente soporte de código de fábrica.**

**Autocompletación:**

- Simplemente empieza a escribir - las terminaciones aparecen automáticamente
- `TAB` - Aceptar la terminación
- `C-n/C-p` o `j/k` - Navegar por las opciones de terminación

**Navegación de código:**

- `gd` - Ir a la definición
- `gr` - Encontrar referencias
- `K` - Mostrar documentación
- `SPC c a` - Acciones de código (refactorizar, arreglar, etc.)

📋 _Consulta la guía completa: `emacs.code-completion.cheatsheet.md`_

**Lenguajes soportados:** La mayoría de los lenguajes populares funcionan de fábrica (Python, JavaScript, C/C++, Rust, Go, etc.)

---

## 9. 📚 **Usa el Sistema de Ayuda Incorporado**

**Doom tiene una excelente documentación incorporada.**

- `SPC h` - **Menú principal de ayuda**
- `SPC h d h` - **Ayuda específica de Doom**
- `SPC h k` - **Describir tecla** (¿qué hace esta tecla?)
- `SPC h f` - **Describir función**
- `SPC h v` - **Describir variable**
- `C-h m` - **Mostrar ayuda para el modo actual**

**Cuando estés perdido:** Presiona `SPC h` y explora. El sistema de ayuda es completo y siempre está disponible.

**Consejo Profesional:** Si presionas una combinación de teclas y no sabes qué pasó, usa `SPC h l` para ver los comandos recientes.

---

## 10. 🔧 **Aprende la Integración con Git (Magit)**

**Magit es una de las mejores interfaces de Git disponibles en cualquier lugar.**

- `SPC g g` - Abrir el estado de Magit (¡tu comando principal de Git!)
- `s` - Preparar archivos o fragmentos
- `c c` - Confirmar cambios
- `P P` - Empujar al remoto
- `F F` - Traer del remoto

📋 _Consulta la guía completa: `emacs.magit.cheatsheet.md`_

**Flujo de trabajo básico:**

1. `SPC g g` - Ver qué ha cambiado
2. `s` en los archivos para prepararlos
3. `c c` para confirmar (escribe el mensaje, luego `C-c C-c`)
4. `P P` para empujar

**Por qué es esencial:** Si trabajas con Git, Magit transformará tu flujo de trabajo. Es visual, rápido e increíblemente poderoso.

---

## 🎯 **Lista de Verificación de Inicio Rápido**

Una vez que hayas leído lo anterior, prueba este flujo de trabajo de 5 minutos:

1. ✅ **Abre Doom:** `emacs` en la terminal
2. ✅ **Encuentra un archivo:** `SPC f f` y abre cualquier archivo de texto
3. ✅ **Edita algo:** Presiona `i`, escribe texto, presiona `ESC`
4. ✅ **Guarda:** `SPC f s`
5. ✅ **Abre el explorador de archivos:** `SPC .`
6. ✅ **Obtén ayuda:** `SPC h`
7. ✅ **Divide la ventana:** `SPC w v`
8. ✅ **Cambia de búfer:** `SPC b b`
9. ✅ **Busca en el proyecto:** `SPC s p` (si estás en un proyecto)
10. ✅ **Sal:** `SPC q q`

---

## 📖 **Próximos Pasos: Profundiza**

Una vez que te sientas cómodo con lo básico anterior:

1. **Lee las hojas de trucos específicas:**
   - `emacs.file-explorer.cheatsheet.md` - Gestión de archivos
   - `emacs.code-completion.cheatsheet.md` - Funciones de codificación
   - `emacs.magit.cheatsheet.md` - Integración con Git
   - `emacs.markdown.cheatsheet.md` - Edición de Markdown

2. **Personaliza gradualmente:** Empieza a ajustar tu `config.el`
3. **Aprende tu lenguaje:** Explora las funciones específicas del lenguaje
4. **Únete a la comunidad:** Discord de Doom, Reddit, discusiones de GitHub

---

## 🆘 **Cuando Estés Atascado**

**Comandos de emergencia:**

- `C-g` - Cancelar el comando actual (como presionar ESC)
- `SPC q q` - Salir de Emacs
- `SPC h d h` - Ayuda de Doom
- `:q` - Salir del búfer actual (comando de Vim)

**Recuerda:** Todo experto fue una vez un principiante. No intentes aprender todo de una vez. Domina estas 10 cosas primero, luego explora gradualmente funciones más avanzadas.

**El consejo más importante:** Usa `SPC` y explora los menús. ¡Doom está diseñado para ser descubrible - deja que te guíe!

---

## 🎓 **Filosofía de Aprendizaje**

**Empieza con flujos de trabajo, no con funciones:** En lugar de memorizar cada atajo de teclado, aprende flujos de trabajo completos para las tareas que haces a diario (editar archivos, confirmar código, buscar en proyectos).

**Usa primero los valores predeterminados:** Los valores predeterminados de Doom son excelentes. Resiste la tentación de personalizar todo de inmediato.

**Una cosa a la vez:** Domina la navegación de archivos antes de sumergirte en funciones de código avanzadas. Construye tus habilidades de forma incremental.

**Practica a diario:** Usa Doom para el trabajo real, incluso si al principio eres más lento. La memoria muscular se desarrolla con la práctica.

¡Bienvenido a Doom Emacs! 🚀
