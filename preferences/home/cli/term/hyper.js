module.exports = {
  config: {

    // choose either `'stable'` for receiving highly polished,
    // or `'canary'` for less polished but more frequent updates
    updateChannel: 'stable',

    // default font size in pixels for all tabs
    fontSize: 15,

    // font family with optional fallbacks
    fontFamily: "JetBrainsMono Nerd Font Propo",

    // default font weight: 'normal' or 'bold'
    fontWeight: 'normal',

    // font weight for bold characters: 'normal' or 'bold'
    fontWeightBold: 'bold',

    // line height as a relative unit
    lineHeight: 1.200000,

    // letter spacing as a relative unit
    letterSpacing: 0,

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: "#C5CDD3",

    // terminal text color under BLOCK cursor
    cursorAccentColor: '#000',

    // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
    cursorShape: "BEAM",

    // set to `true` (without backticks and without quotes) for blinking cursor
    cursorBlink: 1,

    // color of the text
    // foregroundColor: "#986811",
    foregroundColor: "#d8a559",

    // terminal background color
    // opacity is only supported on macOS
    // backgroundColor: "#1B2932",
    backgroundColor: "#212a30",

    // terminal selection color
    selectionColor: "#496D83",

    // border color (window, tabs)
    borderColor: '#333',

    // custom CSS to embed in the main window
    css: "",

    // custom CSS to embed in the terminal window
    termCSS: "",

    // if you're using a Linux setup which show native menus, set to false
    // default: `true` on Linux, `true` on Windows, ignored on macOS
    showHamburgerMenu: "",

    // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
    showWindowControls: "",

    // custom padding (CSS format, i.e.: `top right bottom left`)
    padding: '12px 14px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: "#5E0000",
      red: "#FF0004",
      green: "#58CC48",
      yellow: "#CC430D",
      blue: "#F5146D",
      magenta: "#DE6187",
      cyan: "#FFC699",
      white: "#C5CDD3",
      lightBlack: "#666042",
      lightRed: "#C40000",
      lightGreen: "#61C838",
      lightYellow: "#D1D1B8",
      lightBlue: "#1A2830",
      lightMagenta: "#FF709B",
      lightCyan: "#FC874F",
      lightWhite: "#C5D1D3",
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    //
    // Windows
    // - Make sure to use a full path if the binary name doesn't work
    // - Remove `--login` in shellArgs
    //
    // Bash on Windows
    // - Example: `C:\\Windows\\System32\\bash.exe`
    //
    // PowerShell on Windows
    // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
    shell: 'C:\\Program Files\\WSL\\wsl.EXE',

    // for setting shell arguments (i.e. for using interactive shellArgs: `['-i']`)
    // by default `['--login']` will be used
    shellArgs: ['--cd', '~'],

    // for environment variables
    env: {},

    // set to `false` for no bell
    bell: false,

    // if `true` (without backticks and without quotes), selected text will automatically be copied to the clipboard
    copyOnSelect: false,

    // if `true` (without backticks and without quotes), hyper will be set as the default protocol client for SSH
    defaultSSHApp: true,

    // if `true` (without backticks and without quotes), on right click selected text will be copied or pasted if no
    // selection is present (`true` by default on Windows and disables the context menu feature)
    quickEdit: false,

    // choose either `'vertical'`, if you want the column mode when Option key is hold during selection (Default)
    // or `'force'`, if you want to force selection regardless of whether the terminal is in mouse events mode
    // (inside tmux or vim with mouse mode enabled for example).
    macOptionSelectionMode: 'vertical',

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // Whether to use the WebGL renderer. Set it to false to use canvas-based
    // rendering (slower, but supports transparent backgrounds)
    webGLRenderer: true,

    // for advanced config flags please refer to https://hyper.is/#cfg
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],

  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  },
};

