# Firefox Konfiguration für NixOS
{ config, pkgs, lib, hasPlasma ? false, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    
    # Profile konfigurieren
    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "default";
        
        # Extensions installieren
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden  
          privacy-badger
          clearurls
          decentraleyes
          darkreader
        ];

        # about:config Einstellungen
        settings = {
          # Privacy & Security
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.history" = false;
          "browser.safebrowsing.malware.enabled" = true;
          "browser.safebrowsing.phishing.enabled" = true;
          
          # Performance
          "gfx.webrender.all" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "layers.acceleration.force-enabled" = true;
          
          # UI & UX
          "browser.tabs.firefox-view" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.shortcuts.bookmarks" = false;
          "browser.urlbar.shortcuts.tabs" = false;
          "browser.urlbar.shortcuts.history" = false;
          "browser.compactmode.show" = true;
          
          # Downloads
          "browser.download.useDownloadDir" = false; # Immer fragen wo speichern
          
          # Developer Tools
          "devtools.theme" = "dark";
          "devtools.toolbox.host" = "right";
          
          # Fonts
          "font.name.serif.x-western" = "Liberation Serif";
          "font.name.sans-serif.x-western" = "Liberation Sans";
          "font.name.monospace.x-western" = "Liberation Mono";
          
          # Search
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          
          # Platform-specific settings
        } // (if hasPlasma then {
          # Linux-spezifische Einstellungen
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "media.ffmpeg.vaapi.enabled" = true;
        } else {
          # macOS-spezifische Einstellungen
          "gfx.canvas.azure.accelerated" = true;
        });

        # Bookmarks
        bookmarks = [
          {
            name = "Development";
            bookmarks = [
              {
                name = "GitHub";
                url = "https://github.com";
              }
              {
                name = "NixOS Wiki";
                url = "https://nixos.wiki";
              }
              {
                name = "Nix Package Search";
                url = "https://search.nixos.org/packages";
              }
            ];
          }
          {
            name = "Tools";
            bookmarks = [
              {
                name = "Regex101";
                url = "https://regex101.com";
              }
              {
                name = "JSON Formatter";
                url = "https://jsonformatter.org";
              }
            ];
          }
        ];

        # Search engines
        # search = {
        #   default = "DuckDuckGo";
        #   engines = {
        #     "Nix Packages" = {
        #       urls = [{
        #         template = "https://search.nixos.org/packages";
        #         params = [
        #           { name = "type"; value = "packages"; }
        #           { name = "query"; value = "{searchTerms}"; }
        #         ];
        #       }];
        #       icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        #       definedAliases = [ "@np" ];
        #     };
        #
        #     "NixOS Wiki" = {
        #       urls = [{
        #         template = "https://nixos.wiki/index.php?search={searchTerms}";
        #       }];
        #       definedAliases = [ "@nw" ];
        #     };
        #
        #     "GitHub" = {
        #       urls = [{
        #         template = "https://github.com/search?q={searchTerms}";
        #       }];
        #       definedAliases = [ "@gh" ];
        #     };
        #
        #     # Disable unwanted search engines
        #     "Google".metaData.hidden = true;
        #     "Amazon.de".metaData.hidden = true;
        #     "Bing".metaData.hidden = true;
        #     "eBay".metaData.hidden = true;
        #   };
        # };

        # User CSS (userChrome.css)
        userChrome = ''
          /* Hide tab bar when only one tab */
          #tabbrowser-tabs {
            visibility: collapse !important;
          }
          
          /* Show tab bar when multiple tabs */
          #tabbrowser-tabs[overflow="true"] {
            visibility: visible !important;
          }
          
          /* Compact toolbar */
          :root {
            --toolbarbutton-border-radius: 2px !important;
          }
          
          /* Hide Firefox View button */
          #firefox-view-button {
            display: none !important;
          }
        '';

        # User content CSS (userContent.css)
        userContent = ''
          /* Dark mode für Seiten ohne eigenes dark theme */
          @-moz-document url-prefix(about:) {
            body {
              background: #2b2a33 !important;
              color: #fbfbfe !important;
            }
          }
        '';
        extraConfig = ''
          user_pref("identity.sync.tokenserver.uri", "https://syncserver.dev.ewolutions.de/token/1.0/sync/1.5");
        user_pref("services.sync.deletePwdFxA", true);
        user_pref("services.sync.engine.addresses", true);
        user_pref("services.sync.engine.addresses.available", true);
        user_pref("services.sync.engine.creditcards", true);
        user_pref("services.sync.engine.prefs.modified", false);
        user_pref("services.sync.globalScore", 0);
        user_pref("services.sync.syncInterval", 600000);
        user_pref("services.sync.syncThreshold", 300);
        user_pref("services.sync.username", "eic.chr@gmail.com");
        '';

      };

      # Zusätzliches Profil für Work/Privacy
      work = {
        id = 1;
        name = "work";
        
        settings = {
          # Strengere Privacy-Einstellungen für Work
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "network.cookie.cookieBehavior" = 1; # Block third-party cookies
        };
        
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          privacy-badger
          clearurls
        ];
      };
    };
    
    # Firefox Policies (Enterprise-style configuration)
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = false;
      DisableAccounts = false;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
    };
  };

home.file.".mozilla/firefox/default/search.json.mozlz4".enable = false;
  # NUR ist jetzt systemweit verfügbar durch das Overlay in common.nix
}
