{...}: {
  home.file.
    "signature-ewolutions-ce.txt" = {
    text = ''
      __________________________________________________________

      EWolutions - Eickhoff & Wölfing IT Solutions GbR

      Einöd 395
      D-98663 Heldburg

      Telefon:   036 871 / 318 625
      E-Mail:  christian@ewolutions.de
      __________________________________________________________

      Bitte denken Sie an die Umwelt, bevor Sie diese Mail ausdrucken.
    '';
  };

  programs.thunderbird = {
    enable = true;
    profiles = {
      "my-thunderbird-profile" = {
        isDefault = true;
        extraConfig = ''
            user_pref("mail.identity.default.compose_html", false);
          user_pref("mail.default_html_action", 1);
          user_pref("mailnews.send_plaintext_flowed", false);
        '';
        settings = {
          "mail.identity.id2.sig_file-rel" = "[ProfD]../../signature-ewolutions-ce.txt";
          "mailnews.default_news_sort_order" = 2;
          "mailnews.default_sort_order" = 2;
          "mail.server.server1.check_new_mail" = true;
          "mail.server.server1.directory-rel" = "[ProfD]ImapMail/imap.mailbox.org";
          "mail.server.server1.hostname" = "imap.mailbox.org";
          "mail.server.server1.lastFilterTime" = 28624797;
          "mail.server.server1.login_at_startup" = true;
          "mail.server.server1.max_cached_connections" = 5;
          "mail.server.server1.name" = "christian.eickhoff@mailbox.org";
          "mail.server.server1.namespace.other_users" = ''"shared/"'';
          "mail.server.server1.namespace.personal" = ''""'';
          "mail.server.server1.nextFilterTime" = 28624807;
          "mail.server.server1.port" = 993;
          "mail.server.server1.serverIDResponse" = ''("name" "Dovecot")'';
          "mail.server.server1.socketType" = 3;
          "mail.server.server1.spamActionTargetAccount" = "imap://christian.eickhoff%40mailbox.org@imap.mailbox.org";
          "mail.server.server1.storeContractID" = "@mozilla.org/msgstore/berkeleystore;1";
          "mail.server.server1.timeout" = 29;
          "mail.server.server1.type" = "imap";
          "mail.server.server1.userName" = "christian.eickhoff@mailbox.org";
          "mail.server.server2.directory-rel" = "[ProfD]Mail/Local Folders";
          "mail.server.server2.hostname" = "Local Folders";
          "mail.server.server2.lastFilterTime" = 28624797;
          "mail.server.server2.name" = "Local Folders";
          "mail.server.server2.nextFilterTime" = 28624807;
          "mail.server.server2.spamActionTargetAccount" = "mailbox://nobody@Local%20Folders";
          "mail.server.server2.storeContractID" = "@mozilla.org/msgstore/berkeleystore;1";
          "mail.server.server2.type" = "none";
          "mail.server.server2.userName" = "nobody";
          "mail.server.server3.ageLimit" = 30;
          "mail.server.server3.applyToFlaggedMessages" = false;
          "mail.server.server3.check_new_mail" = true;
          "mail.server.server3.cleanupBodies" = false;
          "mail.server.server3.cleanup_inbox_on_exit" = true;
          "mail.server.server3.daysToKeepBodies" = 30;
          "mail.server.server3.daysToKeepHdrs" = 30;
          "mail.server.server3.directory-rel" = "[ProfD]ImapMail/mail.ewolutions.de";
          "mail.server.server3.downloadByDate" = false;
          "mail.server.server3.downloadUnreadOnly" = false;
          "mail.server.server3.empty_trash_on_exit" = true;
          "mail.server.server3.hostname" = "mail.ewolutions.de";
          "mail.server.server3.lastFilterTime" = 28624797;
          "mail.server.server3.login_at_startup" = true;
          "mail.server.server3.max_cached_connections" = 5;
          "mail.server.server3.moveOnSpam" = true;
          "mail.server.server3.name" = "christian@ewolutions.de";
          "mail.server.server3.namespace.personal" = ''""'';
          "mail.server.server3.nextFilterTime" = 28624807;
          "mail.server.server3.numHdrsToKeep" = 2000;
          "mail.server.server3.serverIDResponse" = ''("name" "Dovecot")'';
          "mail.server.server3.socketType" = 2;
          "mail.server.server3.spamActionTargetAccount" = "imap://christian%40ewolutions.de@mail.ewolutions.de";
          "mail.server.server3.spamActionTargetFolder" = "imap://christian%40ewolutions.de@mail.ewolutions.de/Junk";
          "mail.server.server3.storeContractID" = "@mozilla.org/msgstore/berkeleystore;1";
          "mail.server.server3.timeout" = 29;
          "mail.server.server3.type" = "imap";
          "mail.server.server3.userName" = "christian@ewolutions.de";
          "mail.smtp.defaultserver" = "smtp1";
          "mail.smtpserver.smtp1.authMethod" = 3;
          "mail.smtpserver.smtp1.description" = "mailbox.org -- damit Privates privat bleibt";
          "mail.smtpserver.smtp1.hostname" = "smtp.mailbox.org";
          "mail.smtpserver.smtp1.port" = 465;
          "mail.smtpserver.smtp1.try_ssl" = 3;
          "mail.smtpserver.smtp1.username" = "christian.eickhoff@mailbox.org";
          "mail.smtpserver.smtp2.authMethod" = 3;
          "mail.smtpserver.smtp2.description" = "";
          "mail.smtpserver.smtp2.hostname" = "mail.ewolutions.de";
          "mail.smtpserver.smtp2.port" = 25;
          "mail.smtpserver.smtp2.try_ssl" = 2;
          "mail.smtpserver.smtp2.username" = "christian@ewolutions.de";
          "mail.smtpservers" = "smtp1,smtp2";
          "mail.account.account1.identities" = "id1";
          "mail.account.account1.server" = "server1";
          "mail.account.account2.server" = "server2";
          "mail.account.account3.identities" = "id2";
          "mail.account.account3.server" = "server3";
          "mail.account.lastKey" = 3;
          "mail.accountmanager.accounts" = "account1,account3,account2";
          "mail.accountmanager.defaultaccount" = "account1";
          "mail.accountmanager.localfoldersserver" = "server2";
          "mail.displayname.version" = 1;
          "mail.folder.views.version" = 1;
          "mail.identity.id1.archive_folder" = "imap://christian.eickhoff%40mailbox.org@imap.mailbox.org/Archives";
          "mail.identity.id1.doBcc" = false;
          "mail.identity.id1.draft_folder" = "imap://christian.eickhoff%40mailbox.org@imap.mailbox.org/Drafts";
          "mail.identity.id1.drafts_folder_picker_mode" = "0";
          "mail.identity.id1.fcc_folder" = "imap://christian.eickhoff%40mailbox.org@imap.mailbox.org/Sent";
          "mail.identity.id1.fcc_folder_picker_mode" = "0";
          "mail.identity.id1.fullName" = "Christian Eickhoff";
          "mail.identity.id1.is_gnupg_key_id" = true;
          "mail.identity.id1.reply_on_top" = 1;
          "mail.identity.id1.smtpServer" = "smtp1";
          "mail.identity.id1.stationery_folder" = "imap://christian.eickhoff%40mailbox.org@imap.mailbox.org/Templates";
          "mail.identity.id1.tmpl_folder_picker_mode" = "0";
          "mail.identity.id1.useremail" = "christian.eickhoff@mailbox.org";
          "mail.identity.id1.valid" = true;
          "mail.identity.id2.archive_folder" = "imap://christian%40ewolutions.de@mail.ewolutions.de/Archives";
          "mail.identity.id2.doBcc" = false;
          "mail.identity.id2.draft_folder" = "imap://christian%40ewolutions.de@mail.ewolutions.de/Drafts";
          "mail.identity.id2.drafts_folder_picker_mode" = "0";
          "mail.identity.id2.fcc_folder" = "imap://christian%40ewolutions.de@mail.ewolutions.de/Sent";
          "mail.identity.id2.fcc_folder_picker_mode" = "0";
          "mail.identity.id2.fullName" = "Christian Eickhoff";
          "mail.identity.id2.reply_on_top" = 1;
          "mail.identity.id2.sig_bottom" = true;
          "mail.identity.id2.smtpServer" = "smtp2";
          "mail.identity.id2.stationery_folder" = "imap://christian%40ewolutions.de@mail.ewolutions.de/Templates";
          "mail.identity.id2.tmpl_folder_picker_mode" = "0";
          "mail.identity.id2.useremail" = "christian@ewolutions.de";
          "mail.identity.id2.valid" = true;
        };
      };
    };
  };
}
