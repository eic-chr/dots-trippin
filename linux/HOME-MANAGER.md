# Home-Manager Targets Guide

Home-Manager ermöglicht es, Benutzerkonfigurationen unabhängig von System-Rebuilds zu aktualisieren. Das ist deutlich schneller und praktisch für Entwicklung und Tests.

## Verfügbare Home-Manager Targets

### Benutzer-spezifische Targets

```bash
# Christian's Konfiguration (automatische Host-Erkennung)
make hm-christian

# Charlotte's Konfiguration (nur auf offnix verfügbar)
make hm-charlotte
```

### Host-spezifische Targets

```bash
# Christian auf verschiedenen Hosts
make hm-christian-devnix
make hm-christian-offnix

# Charlotte (nur auf offnix)
make hm-charlotte-offnix
```

### Automatische Targets

```bash
# Aktueller Benutzer auf aktuellem Host
make hm-switch

# Nur bauen (ohne switchen)
make hm-build

# Alle Home-Manager Konfigurationen prüfen
make hm-check
```

## Wann Home-Manager Targets verwenden?

### ✅ Verwende Home-Manager Targets für:
- **Dotfiles-Änderungen**: `.bashrc`, `.zshrc`, Starship-Config
- **Programm-Konfigurationen**: Git, Wezterm, Thunderbird
- **Benutzer-spezifische Pakete**: Entwicklungstools, Desktop-Apps
- **Shell-Aliases und -Funktionen**
- **Desktop-Einstellungen** (falls über Home-Manager konfiguriert)

### ❌ Verwende System-Rebuilds für:
- **System-Services**: SSH, Docker, Akonadi
- **Kernel-Module und Hardware-Konfiguration**
- **System-Benutzer hinzufügen/entfernen**
- **Bootloader-Änderungen**
- **Netzwerk-Konfiguration**

## Praktische Beispiele

### Entwicklung mit Home-Manager

```bash
# 1. Änderungen an Christian's ZSH-Konfiguration testen
vim home-manager/users/christian.nix
make hm-christian

# 2. Charlotte's KMail-Einstellungen anpassen
vim home-manager/users/charlotte.nix
make hm-charlotte

# 3. Starship-Theme aktualisieren
vim starship/starship.toml
make hm-switch  # Für aktuellen Benutzer
```

### Schnelle Paket-Installation

```bash
# Paket zu Christian's Konfiguration hinzufügen
echo 'pkgs.neovim' >> home-manager/users/christian.nix
make hm-christian  # Viel schneller als make devnix
```

## Unterschied zu System-Rebuilds

| Aspekt | Home-Manager | System-Rebuild |
|--------|--------------|----------------|
| **Geschwindigkeit** | ~30 Sekunden | ~2-5 Minuten |
| **Umfang** | Nur Benutzerkonfiguration | Komplettes System |
| **Root-Rechte** | Nicht erforderlich | `sudo` erforderlich |
| **Reboot nötig** | Nein | Nur bei Kernel-Änderungen |
| **Services** | Benutzer-Services | System-Services |

## Fehlerbehebung

### "home-manager command not found"

```bash
# Home-Manager installieren
nix-shell -p home-manager
```

### "No such flake output"

```bash
# Prüfen, ob die Konfiguration existiert
nix flake show | grep homeConfigurations
```

### Benutzer-/Host-Kombination nicht unterstützt

Unterstützte Kombinationen:
- `christian@devnix` ✅
- `christian@offnix` ✅
- `charlotte@offnix` ✅
- `charlotte@devnix` ❌ (Charlotte ist nur auf offnix konfiguriert)

### Rollback bei Problemen

```bash
# Home-Manager Generation anzeigen
home-manager generations

# Zu vorheriger Generation zurück
home-manager switch --switch-generation 123
```

## Workflow-Empfehlungen

### Für Christian (Entwickler)

```bash
# Tägliche Entwicklung - nur Home-Manager
make hm-christian

# System-Updates - vollständiger Rebuild
make devnix  # oder make offnix
```

### Für Charlotte (Office)

```bash
# KMail-Konfiguration anpassen
make hm-charlotte

# System-Updates
make offnix
```

### Testing-Workflow

```bash
# 1. Konfiguration testen
make hm-check

# 2. Nur bauen (ohne switchen)
make hm-build

# 3. Switchen wenn OK
make hm-switch
```

## Integration mit System-Rebuilds

Home-Manager ist auch in die System-Rebuilds integriert:

```bash
make devnix   # Baut System UND Home-Manager
make hm-christian-devnix  # Nur Home-Manager
```

**Tipp**: Für reine Konfigurationsänderungen verwende Home-Manager Targets - sie sind viel schneller!