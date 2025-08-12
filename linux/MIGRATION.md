# Migration Guide: Von alter Makefile-Konfiguration zu Flakes

Diese Anleitung führt dich durch die Migration von der alten `configuration.nix` + Makefile-basierten Konfiguration zur neuen Flake-basierten Multi-Host-Struktur.

## Überblick der Änderungen

### Vorher (Alt)
```
linux/
├── configuration.nix          # Monolithische Konfiguration
├── home-manager.nix          # Home-Manager Konfiguration
├── users/
│   ├── christian.nix         # Benutzerkonfigurationen
│   └── charlotte.nix
└── Makefile                  # Channel-basierte Befehle
```

### Nachher (Neu)
```
linux/
├── flake.nix                 # Flake-Definition für beide Hosts
├── hosts/
│   ├── common.nix           # Gemeinsame Konfiguration
│   ├── devnix/              # devnix-spezifische Konfiguration
│   └── offnix/              # offnix-spezifische Konfiguration
├── home-manager/
│   └── users/               # Benutzerkonfigurationen
└── Makefile                 # Flake-basierte Befehle
```

## Automatische Migration

### Schritt 1: Migration ausführen
```bash
cd dots-trippin/linux
make migrate
```

Das Migrationsskript:
- Erstellt Backups deiner aktuellen Konfiguration
- Kopiert Hardware-Konfiguration in die neue Struktur
- Erstellt fehlende Konfigurationsdateien
- Testet die neue Konfiguration
- Bietet an, sofort zu wechseln

### Schritt 2: Migration prüfen
```bash
# Konfiguration testen
make check

# Status anzeigen
make status

# Verfügbare Befehle anzeigen
make help
```

## Manuelle Migration (falls gewünscht)

### Schritt 1: Hardware-Konfiguration kopieren
```bash
# Aktuelle Hardware-Konfiguration abrufen
sudo nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix
```

### Schritt 2: Flake testen
```bash
nix flake check
```

### Schritt 3: Neue Konfiguration bauen
```bash
# Für devnix
nixos-rebuild build --flake .#devnix

# Für offnix  
nixos-rebuild build --flake .#offnix
```

### Schritt 4: Wechseln
```bash
# Für das aktuelle System
sudo nixos-rebuild switch --flake .#$(hostname)

# Oder spezifisch
sudo nixos-rebuild switch --flake .#devnix
sudo nixos-rebuild switch --flake .#offnix
```

## Neue Workflow-Befehle

### Tägliche Nutzung
```bash
# System aktualisieren (automatische Host-Erkennung)
make auto

# Spezifischer Host
make devnix
make offnix
```

### Entwicklung/Wartung
```bash
# Nur bauen (ohne wechseln)
make build-devnix
make build-offnix

# Flake-Inputs aktualisieren
make update

# Alte Generationen aufräumen
make clean

# Konfiguration prüfen
make check

# System-Status anzeigen
make status
```

## Unterschiede zu vorher

### Channels → Flakes
- **Vorher**: `nix-channel --update` + Channel-basierte Builds
- **Nachher**: `nix flake update` + Lock-File für reproduzierbare Builds

### Ein System → Mehrere Hosts
- **Vorher**: Eine `configuration.nix` für ein System
- **Nachher**: Host-spezifische Konfigurationen mit gemeinsamer Basis

### Befehle
| Alt | Neu | Zweck |
|-----|-----|-------|
| `make apply` | `make devnix` oder `make offnix` | System wechseln |
| `make update` | `make update && make <host>` | Updates installieren |
| - | `make migrate` | Von alter Konfiguration migrieren |
| - | `make check` | Konfiguration testen |
| - | `make status` | System-Status anzeigen |

## Fehlerbehebung

### "Flake not found" Fehler
```bash
# Sicherstellen, dass du im richtigen Verzeichnis bist
cd dots-trippin/linux

# Git-Repository initialisieren (falls nötig)
git add .
```

### "Hardware configuration missing"
```bash
# Hardware-Konfiguration neu generieren
sudo nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix
```

### "Invalid hostname"
```bash
# Hostname prüfen
hostname

# Unterstützte Hosts anzeigen
ls -la hosts/
```

### Fehlende Konfigurationsdateien
Das Migrationsskript erstellt automatisch minimale Versionen von:
- `p10k-config/.p10k.zsh`
- `starship/starship.toml`
- `wezterm.lua`
- `thunderbird.nix`

Diese können später angepasst werden.

## Nach der Migration

### Charlotte's E-Mail
- KMail ist automatisch mit `charlotte@ewolutions.de` konfiguriert
- Beim ersten Start nur Passwort eingeben
- Deutsche MacBook-Tastatur automatisch aktiviert

### Christian's Setup
- Thunderbird weiterhin verfügbar
- US International Tastatur automatisch aktiviert
- Entwicklungstools nur auf devnix

### Backup-Wiederherstellung (falls nötig)
```bash
# Alte Konfiguration wiederherstellen
sudo cp /etc/nixos/configuration.nix.backup /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

## Vorteile der neuen Struktur

1. **Multi-Host-Support**: Eine Konfiguration für mehrere Computer
2. **Flake-basiert**: Reproduzierbare Builds mit Lock-Files
3. **Modularer Aufbau**: Gemeinsame und host-spezifische Konfigurationen
4. **Bessere Organisation**: Getrennte Benutzer- und System-Konfigurationen
5. **Einfache Wartung**: Klare Befehle für verschiedene Aufgaben