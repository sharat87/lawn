# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

config.load_autoconfig(False)

# When to show a changelog after qutebrowser was upgraded.
# Type: String
# Valid values:
#   - major: Show changelog for major upgrades (e.g. v2.0.0 -> v3.0.0).
#   - minor: Show changelog for major and minor upgrades (e.g. v2.0.0 -> v2.1.0).
#   - patch: Show changelog for major, minor and patch upgrades (e.g. v2.0.0 -> v2.0.1).
#   - never: Never show changelog after upgrades.
c.changelog_after_upgrade = 'minor'

# Always restore open sites when qutebrowser is reopened. Without this
# option set, `:wq` (`:quit --save`) needs to be used to save open tabs
# (and restore them), while quitting qutebrowser in any other way will
# not save/restore the session. By default, this will save to the
# session which was last loaded. This behavior can be customized via the
# `session.default_name` setting.
# Type: Bool
c.auto_save.session = True

# Which cookies to accept. With QtWebEngine, this setting also controls
# other features with tracking capabilities similar to those of cookies;
# including IndexedDB, DOM storage, filesystem API, service workers, and
# AppCache. Note that with QtWebKit, only `all` and `never` are
# supported as per-domain values. Setting `no-3rdparty` or `no-
# unknown-3rdparty` per-domain on QtWebKit will have the same effect as
# `all`. If this setting is used with URL patterns, the pattern gets
# applied to the origin/first party URL of the page making the request,
# not the request URL.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')

# Which cookies to accept. With QtWebEngine, this setting also controls
# other features with tracking capabilities similar to those of cookies;
# including IndexedDB, DOM storage, filesystem API, service workers, and
# AppCache. Note that with QtWebKit, only `all` and `never` are
# supported as per-domain values. Setting `no-3rdparty` or `no-
# unknown-3rdparty` per-domain on QtWebKit will have the same effect as
# `all`. If this setting is used with URL patterns, the pattern gets
# applied to the origin/first party URL of the page making the request,
# not the request URL.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'devtools://*')

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version} Edg/{upstream_browser_version}', 'https://accounts.google.com/*')

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

# Load images automatically in web pages.
# Type: Bool
config.set('content.images', True, 'chrome-devtools://*')

# Load images automatically in web pages.
# Type: Bool
config.set('content.images', True, 'devtools://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome-devtools://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'devtools://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

# Custom userstyles.
config.set('content.user_stylesheets', '~/.qutebrowser/user_styles.css')

# Duration (in milliseconds) to ignore normal-mode key bindings after a
# successful auto-follow.
# Type: Int
c.hints.auto_follow_timeout = 200

# Mode to use for hints.
# Type: String
# Valid values:
#   - number: Use numeric hints. (In this mode you can also type letters from the hinted element to filter and reduce the number of elements that are hinted.)
#   - letter: Use the characters in the `hints.chars` setting.
#   - word: Use hints words based on the html elements and the extra words.
c.hints.mode = 'number'

# Leave hint mode when starting a new page load.
# Type: Bool
c.hints.leave_on_load = True

# Enter insert mode if an editable element is clicked.
# Type: Bool
c.input.insert_mode.auto_enter = True

# When/how to show the scrollbar.
# Type: String
# Valid values:
#   - always: Always show the scrollbar.
#   - never: Never show the scrollbar.
#   - when-searching: Show the scrollbar when searching for text in the webpage. With the QtWebKit backend, this is equal to `never`.
#   - overlay: Show an overlay scrollbar. On macOS, this is unavailable and equal to `when-searching`; with the QtWebKit backend, this is equal to `never`. Enabling/disabling overlay scrollbars requires a restart.
c.scrolling.bar = 'always'

# Enable smooth scrolling for web pages. Note smooth scrolling does not
# work with the `:scroll-px` command.
# Type: Bool
c.scrolling.smooth = False

# How to behave when the last tab is closed. If the
# `tabs.tabs_are_windows` setting is set, this is ignored and the
# behavior is always identical to the `close` value.
# Type: String
# Valid values:
#   - ignore: Don't do anything.
#   - blank: Load a blank page.
#   - startpage: Load the start page.
#   - default-page: Load the default page.
#   - close: Close the window.
c.tabs.last_close = 'blank'

# Default zoom level.
# Type: Perc
c.zoom.default = '125%'
# config.set("zoom.default", "175%", "*://duckduckgo.com/")

# Available zoom levels.
# Type: List of Perc
c.zoom.levels = ['25%', '33%', '50%', '67%', '75%', '90%', '100%', '110%', '125%', '150%', '175%', '200%', '250%', '300%', '400%', '500%']

# Default font families to use. Whenever "default_family" is used in a
# font setting, it's replaced with the fonts listed here. If set to an
# empty value, a system-specific monospace default is used.
# Type: List of Font, or Font
c.fonts.default_family = 'Code New Roman'

# Default font size to use. Whenever "default_size" is used in a font
# setting, it's replaced with the size listed here. Valid values are
# either a float value with a "pt" suffix, or an integer value with a
# "px" suffix.
# Type: String
c.fonts.default_size = '18pt'

# Font used for the downloadbar.
# Type: Font
c.fonts.downloads = 'default_size default_family'

# This setting can be used to map keys to other keys. When the key used
# as dictionary-key is pressed, the binding for the key used as
# dictionary-value is invoked instead. This is useful for global
# remappings of keys, for example to map Ctrl-[ to Escape. Note that
# when a key is bound (via `bindings.default` or `bindings.commands`),
# the mapping is ignored.
# Type: Dict
c.bindings.key_mappings = {
    '<Ctrl+[>': '<Escape>',
    '<Ctrl+6>': '<Ctrl+^>',
    '<Ctrl+m>': '<Return>',
    '<Ctrl+j>': '<Return>',
    '<Ctrl+i>': '<Tab>',
    '<Shift+Return>': '<Return>',
    '<Enter>': '<Return>',
    '<Shift+Enter>': '<Return>',
    '<Ctrl+Enter>': '<Ctrl+Return>',
    '<Space>': ':',
}


# Scrolling without needing the <Ctrl> key:
config.bind("d", "scroll-page 0 0.5")
config.bind("u", "scroll-page 0 -0.5")
config.bind("x", "tab-close")
config.bind("U", "undo")
config.unbind("xo", mode="normal")
config.unbind("xO", mode="normal")


# Open new tab with just a `t`.
config.bind("t", "set-cmd-text -s :open -t")
config.unbind("th", mode="normal")
config.unbind("tl", mode="normal")
config.bind(",d", "set-cmd-text -s :tab-select")
config.bind("<Ctrl-9>", "tab-prev")
config.unbind("J", mode="normal")
config.bind("<Ctrl-0>", "tab-next")
config.unbind("K", mode="normal")
config.bind("<Ctrl-n>", "tab-focus last")
tab_actions_prefix = "e"
config.bind(tab_actions_prefix + "h", "back -t")
config.bind(tab_actions_prefix + "l", "forward -t")
config.bind(tab_actions_prefix + "c", "tab-clone")
config.bind(tab_actions_prefix + "d", "tab-give")  # detach


# Change the default config-cycle bindings to be prefixed with `c`, instead of `t`.
config.bind("cCH", "config-cycle -p -u *://*.{url:host}/* content.cookies.accept all no-3rdparty never ;; reload")
config.bind("cCh", "config-cycle -p -u *://{url:host}/* content.cookies.accept all no-3rdparty never ;; reload")
config.bind("cCu", "config-cycle -p -u {url} content.cookies.accept all no-3rdparty never ;; reload")
config.bind("cIH", "config-cycle -p -u *://*.{url:host}/* content.images ;; reload")
config.bind("cIh", "config-cycle -p -u *://{url:host}/* content.images ;; reload")
config.bind("cIu", "config-cycle -p -u {url} content.images ;; reload")
config.bind("cPH", "config-cycle -p -u *://*.{url:host}/* content.plugins ;; reload")
config.bind("cPh", "config-cycle -p -u *://{url:host}/* content.plugins ;; reload")
config.bind("cPu", "config-cycle -p -u {url} content.plugins ;; reload")
config.bind("cSH", "config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload")
config.bind("cSh", "config-cycle -p -u *://{url:host}/* content.javascript.enabled ;; reload")
config.bind("cSu", "config-cycle -p -u {url} content.javascript.enabled ;; reload")
config.bind("ccH", "config-cycle -p -t -u *://*.{url:host}/* content.cookies.accept all no-3rdparty never ;; reload")
config.bind("cch", "config-cycle -p -t -u *://{url:host}/* content.cookies.accept all no-3rdparty never ;; reload")
config.bind("ccu", "config-cycle -p -t -u {url} content.cookies.accept all no-3rdparty never ;; reload")
config.bind("ciH", "config-cycle -p -t -u *://*.{url:host}/* content.images ;; reload")
config.bind("cih", "config-cycle -p -t -u *://{url:host}/* content.images ;; reload")
config.bind("ciu", "config-cycle -p -t -u {url} content.images ;; reload")
config.bind("cpH", "config-cycle -p -t -u *://*.{url:host}/* content.plugins ;; reload")
config.bind("cph", "config-cycle -p -t -u *://{url:host}/* content.plugins ;; reload")
config.bind("cpu", "config-cycle -p -t -u {url} content.plugins ;; reload")
config.bind("csH", "config-cycle -p -t -u *://*.{url:host}/* content.javascript.enabled ;; reload")
config.bind("csh", "config-cycle -p -t -u *://{url:host}/* content.javascript.enabled ;; reload")
config.bind("csu", "config-cycle -p -t -u {url} content.javascript.enabled ;; reload")

config.unbind("tCH", mode="normal")
config.unbind("tCh", mode="normal")
config.unbind("tCu", mode="normal")
config.unbind("tIH", mode="normal")
config.unbind("tIh", mode="normal")
config.unbind("tIu", mode="normal")
config.unbind("tPH", mode="normal")
config.unbind("tPh", mode="normal")
config.unbind("tPu", mode="normal")
config.unbind("tSH", mode="normal")
config.unbind("tSh", mode="normal")
config.unbind("tSu", mode="normal")
config.unbind("tcH", mode="normal")
config.unbind("tch", mode="normal")
config.unbind("tcu", mode="normal")
config.unbind("tiH", mode="normal")
config.unbind("tih", mode="normal")
config.unbind("tiu", mode="normal")
config.unbind("tpH", mode="normal")
config.unbind("tph", mode="normal")
config.unbind("tpu", mode="normal")
config.unbind("tsH", mode="normal")
config.unbind("tsh", mode="normal")
config.unbind("tsu", mode="normal")
