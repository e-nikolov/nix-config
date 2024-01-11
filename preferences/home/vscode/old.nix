#   userSettings = {
#     go.formatTool = "gofumports";
#     go.useCodeSnippetsOnFunctionSuggest = true;
#     go.useLanguageServer = true;
#     go.lintTool = "golangci-lint";
#     go.autocompleteUnimportedPackages = true;
#     rest-client.previewResponsePanelTakeFocus = false;
#     rest-client.timeoutinmilliseconds = 10000;
#     bookmarks.keepBookmarksOnLineDelete = true;
#     bookmarks.sideBar.expanded = true;
#     bookmarks.showNoMoreBookmarksWarning = false;
#     bookmarks.label.suggestion = "suggestWhenSelectedOrLineWhenNoSelected";
#     nix.enableLanguageServer = true;
#     indentRainbow.lightIndicatorStyleLineWidth = 2;
#     editor.inlineSuggest.enabled = true;
#     editor.bracketPairColorization.enabled = true;
#     editor.bracketPairColorization.independentColorPoolPerBracketType = true;
#     editor.formatOnSave = true;
#     editor.suggestSelection = "first";
#     bracket-pair-colorizer-2.highlightActiveScope = true;
#     editor.mouseWheelZoom = true;
#     # terminal.integrated.fontFamily = "'MesloLGS NF'";
#     terminal.integrated.fontFamily = "'Fira Code'";
#     terminal.integrated.tabs.enabled = true;
#     workbench.colorTheme = "One Dark Pro Darker";
#     workbench.iconTheme = "material-icon-theme";
#     "livePreview.httpHeaders" = {
#       Cross-Origin-Opener-Policy = "same-origin";
#       Cross-Origin-Embedder-Policy = "require-corp";
#     };
#     workbench.editor.wrapTabs = true;
#     workbench.editor.decorations.colors = true;
#     local-history.path = "~/.vscode-history";
#     local-history.daysLimit = 3;
#     files.hotExit = "onExitAndWindowClose";
#     latex-workshop.view.pdf.external.viewer.args = [
#       "-shell-escape"
#       "%PDF%"
#     ];
#     latex-workshop.latex.outDir = "%DIR%/build";
#     # latex-workshop.latex.tools = [{
#     #   "name" = "pdflatex";
#     #   "command" = "pdflatex";
#     #   "args" = [
#     #     "-shell-escape"
#     #     "-synctex=1"
#     #     "-interaction=nonstopmode"
#     #     "-file-line-error"
#     #     "%DOC%"
#     #   ];
#     #   "env" = { };
#     # }];
#     latex-workshop.latex.magic.args = [
#       "-shell-escape"
#       "-synctex=1"
#       "-interaction=nonstopmode"
#       "-file-line-error"
#       "%DOC%"
#     ];
#   };
#   keybindings = [
#     {
#       key = "ctrl+n ctrl+n";
#       command = "workbench.action.files.newUntitledFile";
#     }
#     {
#       key = "ctrl+n";
#       command = "-workbench.action.files.newUntitledFile";
#     }
#     {
#       key = "ctrl+w";
#       command = "-editor.action.smartSelect.grow";
#       when = "editorTextFocus";
#     }
#     {
#       key = "ctrl+shift+tab";
#       command = "workbench.action.previousEditor";
#     }
#     {
#       key = "ctrl+tab";
#       command = "workbench.action.nextEditor";
#     }
#     {
#       key = "ctrl+f";
#       command = "workbench.action.terminal.focusFindWidget";
#       when = "terminalFocus";
#     }
#     {
#       key = "ctrl+f";
#       command = "-workbench.action.terminal.focusFindWidget";
#       when = "terminalFocus";
#     }
#     {
#       key = "ctrl+shift+b";
#       command = "editor.action.referenceSearch.trigger";
#       when = "editorHasReferenceProvider && editorTextFocus && !inReferenceSearchEditor";
#     }
#     {
#       key = "alt+f7";
#       command = "-editor.action.referenceSearch.trigger";
#       when = "editorHasReferenceProvider && editorTextFocus && !inReferenceSearchEditor";
#     }
#     {
#       key = "ctrl+f2";
#       command = "-editor.action.changeAll";
#       when = "editorTextFocus && !editorReadonly";
#     }
#     {
#       key = "enter";
#       command = "acceptSelectedSuggestion";
#       when = "suggestWidgetVisible && textInputFocus";
#     }
#     {
#       key = "ctrl+shift+c";
#       command = "-copyFilePath";
#       when = "!editorFocus";
#     }
#     {
#       key = "ctrl+enter";
#       command = "rest-client.request";
#       when = "editorTextFocus && editorLangId == 'http'";
#     }
#     {
#       key = "ctrl+alt+r";
#       command = "-rest-client.request";
#       when = "editorTextFocus && editorLangId == 'http'";
#     }
#     {
#       key = "ctrl+e";
#       command = "bookmarks.toggle";
#       when = "editorTextFocus";
#     }
#     {
#       key = "ctrl+alt+k";
#       command = "-bookmarks.toggle";
#       when = "editorTextFocus";
#     }
#     {
#       key = "shift+f6";
#       command = "-editor.action.changeAll";
#       when = "editorTextFocus && !editorHasRenameProvider && !editorReadonly";
#     }
#     {
#       key = "ctrl+alt+up";
#       command = "bookmarks.jumpToNext";
#       when = "editorTextFocus";
#     }
#     {
#       key = "ctrl+alt+l";
#       command = "-bookmarks.jumpToNext";
#       when = "editorTextFocus";
#     }
#     {
#       key = "ctrl+alt+down";
#       command = "bookmarks.jumpToPrevious";
#       when = "editorTextFocus";
#     }
#     {
#       key = "ctrl+alt+j";
#       command = "-bookmarks.jumpToPrevious";
#       when = "editorTextFocus";
#     }
#     {
#       key = "ctrl+s";
#       command = "-workbench.action.files.saveAll";
#     }
#     {
#       key = "ctrl+s";
#       command = "workbench.action.files.saveFiles";
#     }
#     {
#       key = "ctrl+b";
#       command = "editor.action.openLink";
#     }
#   ];
{}
