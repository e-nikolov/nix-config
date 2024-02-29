
$env.config = {
  highlight_resolved_externals: true,
  color_config: {
    shape_external_resolved: green,
    shape_internalcall: green,
  }
  show_banner: false,

  history: {
    max_size: 10_000_000
    file_format: "sqlite" 
    # sync_on_enter: false 
    isolation: false
  }

  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    external: {
      enable: true
      max_results: 100
      completer: null
    }
  }

  menus: [ 
    {
      name: fzf_history_menu_fzf_ui
      only_buffer_difference: false
      marker: "󰋼 "
      type: {
        layout: columnar
        columns: 4
        col_width: 20    
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "# "
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        open $nu.history-path | get history.command_line | to text | fzf +s --tac | str trim
        | where $it =~ $buffer
        | each { |v| {value: ($v | str trim) } }
      }
    }
    {
      name: fzf_history_menu_nu_ui
      only_buffer_difference: true
      marker: "# "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: "#66ff66"
        selected_text: { fg: "#66ff66" attr: r }
        description_text: yellow
      }
      source: { |buffer, position|
        open $nu.history-path | get history.command_line | to text
        | fzf -f $buffer
        | lines
        | each { |v| {value: ($v | str trim) } }
      }
    }
    {
      name: fzf_dir_menu_nu_ui
      only_buffer_difference: true
      marker: "# "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: "#66ff66"
        selected_text: { fg: "#66ff66" attr: r }
        description_text: yellow
      }
      source: { |buffer, position|
        ls $'($env.PWD)' | where type == dir
        | sort-by name | get name | to text
        | fzf -f $buffer
        | each { |v| { value: ($v | str trim) }}
      }
    }
    # {
    #   name: fzf_history_menu_fzf_ui
    #   only_buffer_difference: false
    #   marker: "# "
    #   type: {
    #     layout: columnar
    #     columns: 4
    #     col_width: 20
    #     col_padding: 2
    #   }
    #   style: {
    #     text: green
    #     selected_text: green_reverse
    #     description_text: yellow
    #   }
    #   source: { |buffer, position|
    #     open -r $nu.history-path | fzf +s --tac | str trim
    #     | where $it =~ $buffer
    #     | each { |v| {value: ($v | str trim) } }
    #   }
    # }
    # {
    #   name: fzf_menu_nu_ui
    #   only_buffer_difference: false
    #   marker: "# "
    #   type: {
    #     layout: list
    #     page_size: 10
    #   }
    #   style: {
    #     text: "#66ff66"
    #     selected_text: { fg: "#66ff66" attr: r }
    #     description_text: yellow
    #   }        
    #   source: { |buffer, position|
    #     open -r $nu.history-path
    #     | fzf -f $buffer
    #     | lines
    #     | each { |v| {value: ($v | str trim) } }
    #   }
    # }
  ]
  keybindings: [
    {
      name: fuzzy_history_fzf
      modifier: control
      keycode: char_r
      mode: [emacs , vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "commandline (
          history
            | each { |it| $it.command }
            | uniq
            | reverse
            | str join (char -i 0)
            | fzf --read0 --tiebreak=chunk --layout=reverse  --multi --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% -q (commandline)
            | decode utf-8
            | str trim
        )"
      }
    },
    {
      name: SelectAll
      modifier: control
      keycode: char_a
      mode: [emacs , vi_normal, vi_insert]
      event: {
        edit: SelectAll
      }
    }
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_menu2
      modifier: control
      keycode: char_n
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menuprevious }
    }
    {
      name: delete_one_word_backward
      modifier: control
      keycode: backspace
      mode: [emacs, vi_insert]
      event: {edit: BackspaceWord}
    },
    {
      name: open_command_editor
      modifier: control
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: openeditor }
    }
    {
      name: cut_selection
      modifier: control
      keycode: char_x
      mode: [emacs, vi_insert]
      event: {edit: CutSelection}
    },
    {
      name: redo_change
      modifier: shift
      keycode: backtab 
      mode: emacs
      event: {edit: redo}
    }
    {
      name: fzf_history_menu_fzf_ui
      modifier: control
      keycode: char_e
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: fzf_history_menu_fzf_ui }
    }
    {
      name: fzf_history_menu_nu_ui
      modifier: control
      keycode: char_w
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: fzf_menu_nu_ui }
    }
    {
      name: fzf_dir_menu_nu_ui
      modifier: control
      keycode: char_q
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: fzf_dir_menu_nu_ui }
    }
  ]
}

### Functions ###

def xc [] {
  xclip -selection clipboard
}

def --wrapped nhs [...args] {
  home-manager switch --flake ~/nix-config ...$args
  exec nu
}

def --wrapped gst [...args] {
  git status ...$args
}

def --wrapped nfu [...args] {
  nix flake update --flake ~/nix-config ...$args
}

def --wrapped nh [...args] {
  home-manager --flake ~/nix-config ...$args
}

def --wrapped ns [...args] {
  nix shell ...$args
}

def --wrapped gc [...args] {
  git commit ...$args
}
def --wrapped gcl [...args] {
  git clone --recurse-submodules ...$args
}

def --wrapped ga [...args] {
  git add ...$args
}
def --wrapped gd [...args] {
  git diff ...$args
} 

def --wrapped nrs [...args] {
  sudo nixos-rebuild switch --flake ~/nix-config/ --verbose ...$args
  exec nu
}

def --wrapped nd [...args] {
  nix ...$args --command nu develop
}

def --wrapped sudo [...args] {
  sudo -E env "PATH=$PATH" ...$args
}

def --wrapped xargs [...args] {
  xargs ...$args
}

def --wrapped code [...args] {
  code-insiders ...$args
}

def --wrapped gct [...args] {
  code-insiders ...git commit -am 'tmp'
}
def --wrapped l [...args] {
  eza ...$args
}

def --wrapped ls [...args] {
  eza -o -lh --group-directories-first --color always --icons --classify --time-style relative --created --changed  
}

def --wrapped lsa [...args] {
  ls -a ...$args
}
def --wrapped tree [...args] {
  "eza --tree -alh --group-directories-first --color always --icons ";
}
def --wrapped grep [...args] {
  grep --color --ignore-case --line-number --context=3 ...$args;
}

def --wrapped zfg [...args] {
  code ~/.zshrc ...$args
}

def --wrapped gi [...args] {
  go install ./... ...$args
}

def --wrapped gomt [...args] {
  go mod tidy  ...$args
}
def --wrapped d [...args] {
  docker ...$args
}
def --wrapped dc [...args] {
  docker-compose ...$args
}

def --wrapped dcu [...args] {
  docker-compose up ...$args
}

def --wrapped dcr [...args] {
  docker-compose run ...$args
}

def --wrapped dclt [...args] {
  docker-compose logs --follow --tail=100 ...$args
}
# ne = lib.mkDefault "$EDITOR ~/nix-config/ ";
# src = "source ~/.zshrc";

# port = "sudo lsof -i -P -n | fzf";
# pp = "ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' '";

