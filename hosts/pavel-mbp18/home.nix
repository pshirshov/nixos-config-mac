{ pkgs, lib, config, ... }: {
  home.activation.compile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -f $HOME/.zshrc.zwc
    ${"find /Applications -maxdepth 1 -type d \! -uid 0  -exec xattr -r -d com.apple.quarantine {}"} \;
  '';

  home.activation.secrets = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    SRC=$HOME/Sync/mega/secrets
    SECRETS=(
      aws
      ssh
      npmrc
    )
    for secret in "''${SECRETS[@]}"; do
      ln -sf $SRC/$secret $HOME/.$secret
    done

    mkdir -p $HOME/.sbt
    ln -sf $SRC/sbt $HOME/.sbt/secrets

    SRC=$HOME/Sync/mega/secrets/gnupg
    TGT=$HOME/.config/gnupg
    mkdir -p $TGT
    SECRETS=(
      secring.gpg
      pubring.gpg
      trustdb.gpg
      gpg-agent.conf
    )
    for secret in "''${SECRETS[@]}"; do
      ln -sf $SRC/$secret $TGT/$secret
    done
    chmod 700 $TGT
  '';


  # programs.firefox = {
  #   enable = true;
  # };

  programs.firefox = {
    enable = true;
    package = pkgs.hello;
    profiles = {
      main = {
        name = "main";
        isDefault = true;
        settings = {
          "services.sync.username" = "pshirshov@gmail.com";
          "browser.startup.homepage" = "about:home";
          "browser.startup.page" = 3; # Restore previous session

          "browser.toolbars.bookmarks.visibility" = "newtab";
          "browser.search.update" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.newtabpage.enabled" = true;
          "browser.newtabpage.pinned" = builtins.toJSON [ ];

          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = true;
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "google"; # Don't autopin google on first run
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.blocked" = builtins.toJSON {
            # Dismiss builtin shortcuts
            "26UbzFJ7qT9/4DhodHKA1Q==" = 1;
            "4gPpjkxgZzXPVtuEoAL9Ig==" = 1;
            "eV8/WsSLxHadrTL1gAxhug==" = 1;
            "gLv0ja2RYVgxKdp0I5qwvA==" = 1;
            "oYry01JR5qiqP3ru9Hdmtg==" = 1;
            "T9nJot5PurhJSy8n038xGA==" = 1;
          };

          #browser.uiCustomization.state" = builtins.toJSON { };

          "app.shield.optoutstudies.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "devtools.selfxss.count" = 5; # Allow pasting into console
          "extensions.formautofill.creditCards.available" = false;
          "extensions.formautofill.creditCards.enabled" = false;

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "devtools.netmonitor.persistlog" = true;
          "devtools.theme" = "dark";

          "browser.link.open_newwindow.restriction" = 0;

          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;
          "browser.contentblocking.category" = "strict";
          "browser.discovery.enabled" = false;

          #"gfx.webrender.compositor" = true;
          #"gfx.webrender.all" = true;
          "security.enterprise_roots.enabled" = true;

          "dom.push.enabled" = false;
          "dom.webnotifications.enabled" = false;
          "dom.webnotifications.serviceworker.enabled" = false;
          "dom.pushconnection.enabled" = false;
          "security.sandbox.content.level" = 3;

          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };

        userChrome = ''
          #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
            opacity: 0;
            pointer-events: none;
          }
          #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
            visibility: collapse !important;
          }
          #sidebar-header {
            display: none;
          }
        '';

        # https://gitlab.com/kira-bruneau/home-config/-/blob/90b1d21ad48ddeb590bd5c8c72a0de4ead015202/package/firefox/default.nix#L9-53
        # search = {
        #   enable = true;
        #   default = "DuckDuckGo";
        #   order = [ "DuckDuckGo" "Google" ];
        #   engines = {
        #     "Amazon.ca".metaData.alias = "@a";
        #     "Bing".metaData.hidden = true;
        #     "eBay".metaData.hidden = true;
        #     "Google".metaData.alias = "@g";
        #     "Wikipedia (en)".metaData.alias = "@w";

        #     "Nix Packages" = {
        #       urls = [{
        #         template = "https://search.nixos.org/packages";
        #         params = [
        #           { name = "channel"; value = "unstable"; }
        #           { name = "query"; value = "{searchTerms}"; }
        #         ];
        #       }];
        #       icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        #       definedAliases = [ "@np" ];
        #     };

        #     "NixOS Wiki" = {
        #       urls = [{
        #         template = "https://nixos.wiki/index.php";
        #         params = [{ name = "search"; value = "{searchTerms}"; }];
        #       }];
        #       icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        #       definedAliases = [ "@nw" ];
        #     };

        #     "Youtube" = {
        #       urls = [{
        #         template = "https://www.youtube.com/results";
        #         params = [{ name = "search_query"; value = "{searchTerms}"; }];
        #       }];
        #       icon = "${pkgs.fetchurl {
        #         url = "www.youtube.com/s/desktop/8498231a/img/favicon_144x144.png";
        #         sha256 = "sha256-lQ5gbLyoWCH7cgoYcy+WlFDjHGbxwB8Xz0G7AZnr9vI=";
        #       }}";
        #       definedAliases = [ "@yt" ];
        #     };
        #   };
        # };


      };

    };

  };

  programs.git = {
    userName = "Pavel Shirshov";
    userEmail = "pshirshov@eml.cc";
    signing.signByDefault = false;
    signing.key = "FF6A100B";
    enable = true;
    aliases = {
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      ignore = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi";
      ignorej = "!gi() { curl -L -s https://www.gitignore.io/api/java,scala,jetbrains+all,sbt,maven,bloop ;}; gi";
    };
    extraConfig = {
      core = {
        reloadindex = true;
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        compression = 9;
        editor = "nano";
        untrackedcache = true;
        fsmonitor = true;
      };
      push.default = "simple";
      branch.autosetuprebase = "always";

      receive.fsckObjects = true;
      status.submodulesummary = true;
      pack.packSizeLimit = "2g";
      fetch.prune = "false";
      rebase.autoStash = true;
      help.autocorrect = 3;
      init.defaultBranch = "main";

      mergetool.keepBackup = "false";

      merge.tool = "smerge";
      diff.tool = "vscode";

      "difftool \"vscode\"".cmd = "code --wait --diff $LOCAL $REMOTE";
      "difftool \"p4mergetool\"".cmd = "p4merge $LOCAL $REMOTE";

      "mergetool \"vscode\"".cmd = "code --wait $MERGED";
      "mergetool \"smerge\"".cmd = "cmd = smerge mergetool \"$BASE\" \"$LOCAL\" \"$REMOTE\" -o \"$MERGED\"";
      "mergetool \"p4mergetool\"".cmd = "p4merge $PWD/$BASE $PWD/$REMOTE $PWD/$LOCAL $PWD/$MERGED";
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    aggressiveResize = true;
    extraConfig = ''
      # Mouse works as expected, incl. scrolling
      set-option -g mouse on
      set -g default-terminal "screen-256color"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 300;
      scala.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    history = {
      ignoreDups = true;
      share = true;
    };
    oh-my-zsh = {
      enable = true;
      theme = "kphoen";
      plugins = [
        "autojump"
        "zsh-navigation-tools"
      ];
    };
    localVariables = {
      COMPLETION_WAITING_DOTS = true;
      HIST_STAMPS = "yyyy-mm-dd";
      #ZSH_THEME="";
    };
    sessionVariables = { };
    initExtra = ''
      _fzf_comprun () {
        local command = $1
        shift
        case "$command" in
            cd)           fzf "$@" --preview 'tree -C {} | head -200';;
            *)            fzf "$@" ;;
        esac
      }
    '';
  };
  programs.autojump.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd .$HOME";
    fileWidgetCommand = "$FZF_DEFAULT_COMMAND";
    changeDirWidgetCommand = "fd -t d . $HOME";
    defaultOptions = [
      "--layout=reverse"
      "--border"
      "--info=inline"
      "--height=80%"
      "--multi"
      "--preview-window=:hidden"
      "--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
      "--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'"
      "--prompt='∼ '"
      "--pointer='▶'"
      "--marker='✓'"
      "--bind '?:toggle-preview'"
    ];
    tmux.enableShellIntegration = true;
  };

  programs.htop = {
    enable = true;
    settings = {
      fields = with config.lib.htop.fields; [
        PID
        USER
        PRIORITY
        NICE
        M_SIZE
        M_RESIDENT
        M_SHARE
        STATE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        COMM
      ];

      sort_key = 46;
      sort_direction = 0;
      tree_sort_key = 46;
      tree_sort_direction = 0;

      hide_kernel_threads = 1;
      hide_userland_threads = 1;

      shadow_other_users = 1;
      show_thread_names = 0;
      show_program_path = 0;

      highlight_base_name = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;
      highlight_changes = 1;
      highlight_changes_delay_secs = 1;

      find_comm_in_cmdline = 1;

      strip_exe_from_cmdline = 1;
      show_merged_command = 0;
      tree_view = 0;
      tree_view_always_by_pid = 0;

      header_margin = 0;
      detailed_cpu_time = 1;
      cpu_count_from_one = 1;
      show_cpu_usage = 1;
      show_cpu_frequency = 0;
      update_process_names = 0;
      account_guest_in_cpu_meter = 1;
      color_scheme = 0;
      enable_mouse = 1;
      delay = 15;
      left_meters = [ "LeftCPUs2" "Memory" "Swap" ];
      left_meter_modes = [ 1 1 1 ];
      right_meters = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
      right_meter_modes = [ 1 2 2 2 ];
      hide_function_bar = 0;

    };
  };

  xdg.configFile."mc/ini".text = ''
      [ Midnight-Commander ]
      verbose=true
    shell_patterns=true
    auto_save_setup=true
    preallocate_space=false
    auto_menu=false
    use_internal_view=true
    use_internal_edit=true
    clear_before_exec=true
    confirm_delete=true
    confirm_overwrite=true
    confirm_execute=false
    confirm_history_cleanup=true
    confirm_exit=false
    confirm_directory_hotlist_delete=false
    confirm_view_dir=false
    safe_delete=false
    safe_overwrite=false
    use_8th_bit_as_meta=false
    mouse_move_pages_viewer=true
    mouse_close_dialog=false
    fast_refresh=false
    drop_menus=false
    wrap_mode=true
    old_esc_mode=true
    cd_symlinks=true
    show_all_if_ambiguous=false
    use_file_to_guess_type=true
    alternate_plus_minus=false
    only_leading_plus_minus=true
    show_output_starts_shell=false
    xtree_mode=false
    file_op_compute_totals=true
    classic_progressbar=true
    use_netrc=true
    ftpfs_always_use_proxy=false
    ftpfs_use_passive_connections=true
    ftpfs_use_passive_connections_over_proxy=false
    ftpfs_use_unix_list_options=true
    ftpfs_first_cd_then_ls=true
    ignore_ftp_chattr_errors=true
    editor_fill_tabs_with_spaces=false
    editor_return_does_auto_indent=true
    editor_backspace_through_tabs=false
    editor_fake_half_tabs=true
    editor_option_save_position=true
    editor_option_auto_para_formatting=false
    editor_option_typewriter_wrap=false
    editor_edit_confirm_save=true
    editor_syntax_highlighting=true
    editor_persistent_selections=true
    editor_drop_selection_on_copy=true
    editor_cursor_beyond_eol=false
    editor_cursor_after_inserted_block=false
    editor_visible_tabs=true
    editor_visible_spaces=true
    editor_line_state=false
    editor_simple_statusbar=false
    editor_check_new_line=false
    editor_show_right_margin=false
    editor_group_undo=false
    editor_state_full_filename=false
    editor_ask_filename_before_edit=false
    nice_rotating_dash=true
    mcview_remember_file_position=false
    auto_fill_mkdir_name=true
    copymove_persistent_attr=true
    pause_after_run=1
    mouse_repeat_rate=100
    double_click_speed=250
    old_esc_mode_timeout=1000000
    max_dirt_limit=10
    num_history_items_recorded=60
    vfs_timeout=60
    ftpfs_directory_timeout=900
    ftpfs_retry_seconds=30
    fish_directory_timeout=900
    editor_tab_spacing=8
    editor_word_wrap_line_length=72
    editor_option_save_mode=0
    editor_backup_extension=~
    editor_filesize_threshold=64M
    editor_stop_format_chars=-+*\\,.;:&>
    mcview_eof=
    skin=yadt256
    filepos_max_saved_entries=1024
    shadows=true
    [Layout]
    message_visible=true
    keybar_visible=true
    xterm_title=true
    output_lines=0
    command_prompt=true
    menubar_visible=true
    free_space=true
    horizontal_split=false
    vertical_equal=true
    left_panel_size=80
    horizontal_equal=true
    top_panel_size=1
    [Misc]
    timeformat_recent=%b %e %H:%M
    timeformat_old=%b %e  %Y
    ftp_proxy_host=gate
    ftpfs_password=anonymous@
    display_codepage=UTF-8
    source_codepage=Other_8_bit
    autodetect_codeset=
    clipboard_store=
    clipboard_paste=
    [Colors]
    xterm-256color=
    color_terminals=
    base_color=linux:normal=white,black:marked=yellow,black:input=,green:menu=black:menusel=white:menuhot=red,:menuhotsel=black,red:dfocus=white,black:dhotnormal=white,black:dhotfocus=white,black:executable=,black:directory=white,black:link=white,black:device=white,black:special=white,black:core=,black:stalelink=red,black:editnormal=white,black
    xterm-kitty=
    [Panels]
    show_mini_info=true
    kilobyte_si=false
    mix_all_files=false
    show_backups=true
    show_dot_files=true
    fast_reload=false
    fast_reload_msg_shown=false
    mark_moves_down=true
    reverse_files_only=true
    auto_save_setup_panels=false
    navigate_with_arrows=false
    panel_scroll_pages=true
    panel_scroll_center=false
    mouse_move_pages=true
    filetype_mode=true
    permission_mode=false
    torben_fj_mode=false
    quick_search_mode=2
    select_flags=6
    simple_swap=false
    [Panelize]
    Find *.orig after patching=find . -name \\*.orig -print
    Find SUID and SGID programs=find . \\( \\( -perm -04000 -a -perm /011 \\) -o \\( -perm -02000 -a -perm /01 \\) \\) -print
    Find rejects after patching=find . -name \\*.rej -print
    Modified git files=git ls-files --modified
  '';
}
