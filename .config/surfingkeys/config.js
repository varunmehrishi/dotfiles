// Paste this snippet into Surfingkeys' Advanced settings (`;e`).

// Let complex editors handle their own keyboard input. In lurk mode,
// Surfingkeys can still be activated temporarily with Alt-i or `p`.
settings.lurkingPattern = /^https:\/\/(?:(?:[^/]+\.)?quip\.com\/|docs\.google\.com\/(?:document|spreadsheets|presentation)\/)/i;

// Keep Chrome's built-in PDF viewer. This is the persistent setting toggled
// by Surfingkeys' built-in `;s` command.
api.RUNTIME("updateSettings", { settings: { noPdfViewer: 1 } });

// Optional: while an editable element is focused, Ctrl-; asks the installed
// Firenvim extension to activate on that element. Remove this block if you
// prefer to use Firenvim's Chrome shortcut directly.
api.imapkey("<Ctrl-;>", "Activate Firenvim for the focused editor", function () {
  chrome.runtime.sendMessage(
    "egpjdkipkomnmjhjmdamaniclmdlobbo",
    { command: "nvimify" },
    function () {
      // Reading lastError prevents Chrome from logging an unchecked error if
      // Firenvim is disabled or unavailable.
      void chrome.runtime.lastError;
    },
  );
});
