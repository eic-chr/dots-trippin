# Localization Guide for NixOS Configuration

## Overview

This guide explains how localization is configured for the different hosts and users in our NixOS setup, with language-specific configurations managed through Plasma Manager.

## Language Configuration

### Host-Specific Locales

**devnix (Development System)**
- **System Locale**: English (en_US.UTF-8)
- **User Interface**: English
- **Keyboard Layout**: US International
- **Primary User**: Christian (English environment)

**offnix (Office System)**
- **System Locale**: German (de_DE.UTF-8)
- **User Interface**: German
- **Keyboard Layout**: German
- **Users**: Christian (German environment), Charlotte (German environment)

## Configuration Structure

### System-Level Configuration

#### devnix Host
```nix
i18n.defaultLocale = "en_US.UTF-8";
i18n.extraLocaleSettings = {
  LC_ADDRESS = "en_US.UTF-8";
  LC_IDENTIFICATION = "en_US.UTF-8";
  # ... all other LC_* variables set to en_US.UTF-8
};

services.xserver = {
  layout = "us";
  xkbVariant = "intl";
  xkbOptions = "compose:ralt,caps:escape";
};
```

#### offnix Host
```nix
i18n.defaultLocale = "de_DE.UTF-8";
i18n.extraLocaleSettings = {
  LC_ADDRESS = "de_DE.UTF-8";
  LC_IDENTIFICATION = "de_DE.UTF-8";
  # ... all other LC_* variables set to de_DE.UTF-8
};

services.xserver = {
  layout = "de";
  xkbVariant = "";
  xkbOptions = "compose:ralt,caps:escape";
};
```

### User-Level Configuration (Home-Manager + Plasma Manager)

#### Christian on devnix (English)
```nix
home.language.base = "en_US.UTF-8";
home.sessionVariables = {
  LANG = "en_US.UTF-8";
  LC_ALL = "en_US.UTF-8";
  LC_MESSAGES = "en_US.UTF-8";
};

programs.plasma = {
  enable = true;
  configFile = {
    "kdeGlobals" = {
      "Locale" = {
        "LANG" = "en_US.UTF-8";
        "LC_MESSAGES" = "en_US.UTF-8";
        "Country" = "us";
        "Language" = "en";
      };
    };
  };
};
```

#### Christian on offnix (German)
```nix
home.language.base = "de_DE.UTF-8";
home.sessionVariables = {
  LANG = "de_DE.UTF-8";
  LC_ALL = "de_DE.UTF-8";
  LC_MESSAGES = "de_DE.UTF-8";
};

programs.plasma = {
  enable = true;
  configFile = {
    "kdeGlobals" = {
      "Locale" = {
        "LANG" = "de_DE.UTF-8";
        "LC_MESSAGES" = "de_DE.UTF-8";
        "Country" = "de";
        "Language" = "de";
      };
    };
  };
};
```

#### Charlotte on offnix (German)
```nix
# Same German configuration as Christian on offnix
# Managed through flake.nix for system integration
```

## Keyboard Layouts

### devnix
- **Layout**: US International
- **Compose Key**: Right Alt (ralt)
- **Special Keys**: Caps Lock → Escape
- **Purpose**: International development with easy access to special characters

### offnix
- **Layout**: German (standard)
- **Charlotte**: German MacBook layout (de mac)
- **Compose Key**: Right Alt (ralt)
- **Special Keys**: Caps Lock → Escape
- **Purpose**: German office environment

## Implementation Details

### Plasma Manager Integration

The configuration uses plasma-manager to handle KDE-specific settings:

1. **Theme**: Breeze Dark for all users
2. **Locale Settings**: Managed per user/host combination
3. **Regional Settings**: Automatically configured based on locale
4. **Input Methods**: Handled at system level

### File Locations

**System Configuration:**
- `hosts/devnix/default.nix` - English system settings
- `hosts/offnix/default.nix` - German system settings
- `hosts/common.nix` - Common settings (timezone, base configuration)

**User Configuration:**
- `flake.nix` - Plasma Manager integration with locale settings
- `home-manager/users/christian.nix` - Base Christian configuration
- `home-manager/users/charlotte.nix` - Base Charlotte configuration

### Home-Manager Standalone Configurations

For standalone Home-Manager usage:

```bash
# English environment (devnix)
home-manager switch --flake .#christian@devnix

# German environment (offnix)
home-manager switch --flake .#christian@offnix
home-manager switch --flake .#charlotte@offnix
```

## Customization

### Adding New Languages

To add support for a new language (e.g., French):

1. **Add locale to host configuration:**
```nix
i18n.defaultLocale = "fr_FR.UTF-8";
i18n.extraLocaleSettings = {
  LC_ADDRESS = "fr_FR.UTF-8";
  # ... other LC_* variables
};
```

2. **Update Plasma Manager configuration:**
```nix
programs.plasma.configFile."kdeGlobals"."Locale" = {
  "LANG" = "fr_FR.UTF-8";
  "LC_MESSAGES" = "fr_FR.UTF-8";
  "Country" = "fr";
  "Language" = "fr";
};
```

3. **Set appropriate keyboard layout:**
```nix
services.xserver = {
  layout = "fr";
  xkbVariant = "";
};
```

### Per-User Language Override

To override language for a specific user without changing the system default:

```nix
home.language.base = "desired_LOCALE.UTF-8";
home.sessionVariables = {
  LANG = "desired_LOCALE.UTF-8";
  LC_MESSAGES = "desired_LOCALE.UTF-8";
};
```

## Testing Language Changes

### VM Testing
Use the VM testing setup to verify language configurations:

```bash
# Test German configuration
make vm-create-offnix
make vm-start-offnix
make vm-install-offnix

# Test English configuration  
make vm-create-devnix
make vm-start-devnix
make vm-install-devnix
```

### Quick Verification Commands

After system installation, verify localization:

```bash
# Check system locale
locale

# Check KDE language settings
kreadconfig5 --file kdeGlobals --group Locale --key LANG

# Check keyboard layout
setxkbmap -query

# Check environment variables
echo $LANG $LC_MESSAGES
```

## Troubleshooting

### Common Issues

**Keyboard layout not applying:**
- Check X11 configuration files in `/etc/X11/xorg.conf.d/`
- Verify sessionCommands in display manager configuration
- Restart X11 session or reboot

**KDE not showing in correct language:**
- Verify Plasma Manager configuration applied correctly
- Check `~/.config/kdeGlobals` file content
- Log out and back in to KDE

**Mixed language environment:**
- Ensure both system and user locale settings match
- Check for conflicting environment variables
- Verify Home-Manager configuration matches system configuration

### Debug Commands

```bash
# Check available locales
locale -a

# Generate missing locales (if needed)
sudo locale-gen de_DE.UTF-8

# Test keyboard layout
setxkbmap -print -verbose 10

# Check Plasma configuration
kreadconfig5 --file kdeGlobals --group Locale --key Language
```

## Migration Notes

When migrating between language configurations:

1. **Backup user settings** before applying changes
2. **Test in VM first** to verify configuration
3. **Clear KDE cache** if switching languages: `rm -rf ~/.cache/kde*`
4. **Regenerate user directories** with new locale if needed

This setup provides a flexible, maintainable approach to multi-language support across different systems and users.