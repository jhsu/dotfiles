# # Options {{{
# Window move/resize steps in pixel per keypress
set :step, 5
# Window screen border snapping
set :snap, 10
# Default starting gravity for windows. Comment out to use gravity of
# currently active client
set :gravity, :center
# Make transient windows urgent
set :urgent, true
# Honor resize size hints globally
set :resize, false
# Enable gravity tiling
set :tiling, false

# Font string either take from e.g. xfontsel or use xft
# set :font, "-*-*-medium-*-*-*-14-*-*-*-*-*-*-*"
set :font, "xft:Ubuntu Mono:pixelsize=16:antialias=true:hinting=true"

# Separator between sublets
set :separator, "•"

# Set the WM_NAME of subtle (Java quirk)
set :wmname, "LG3D"

# }}}

# # Screen {{{
screen 1 do
  # Add stipple to panels
  stipple false

  top     [:views, :title, :spacer, :sublets ]
  # bottom  [:views, :spacer, :tray]
end

screen 2 do
  stipple false
  top     [ :title, :sublets ]
end
# }}}

# # Styles {{{
# Style for all style elements
style :all do
  background  "#202020"
  icon        "#757575"
end

# Style for focus window title
style :title do
  padding 0, 8, 0, 16
  foreground  "#ffffff"
  background "#000000"
  font "xft:Ubuntu Mono:pixelsize=16:antialias=true:hinting=true"
end

# Style for active/inactive windows
style :clients do
  border      "#ffffff", 2
  active      "#cedfea", 2
  inactive    "#151515", 2
  margin      3
  padding     6
end

# Style for subtle
style :subtle do
  background  "#3d3d3d"
  padding     2
  panel_top   "#151515"
  panel_bottom "#151515"
  stipple     "#757575"
end

style :sublets do
  foreground "#ececec"
  background "#000000"
  style :volume do
    foreground "#bdf13d"
    margin 0, 10
  end
  style :clock do
    foreground "#5496ff"
  end
end

style :views do
  foreground "#cccccc"
  background "#232323"
  padding 2, 6

  style :focus do
    padding     2, 8, 0, 8
    #border_bottom "#606060", 2
    border_top "#222222", 3 
    border_bottom "#222222", 4
    foreground  "#d82f44"
    background  "#222222"
  end

  style :urgent do
    padding     2, 8, 0, 8
    #border      "#303030", 0
    border_top "#222222", 2
    border_bottom "#222222", 4
    foreground  "#eae39d"
    background  "#519f50"
  end

  style :occupied do
    padding     2, 8, 0, 8
    #border_bottom "#424242", 2
    border_top "#222222", 2
    border_bottom "#222222", 4
    foreground  "#0aa2c9"
    background  "#222222"
  end
end

# style :focus do
#   foreground     "#38D178"
#   background     "#1a1a1a"
#   padding        0, 10
# end

# style :urgent do
#   foreground     "#cd5c5c"
#   background     "#1a1a1a"
# end

# style :occupied do
#   foreground     "#659fbd"
#   background     "#1a1a1a"
#   padding        0, 3, 0, 3
# end

# }}}

# # Gravities {{{
# Top left
gravity :top_left,       [   0,   0,  50,  50 ]
gravity :top_left66,     [   0,   0,  50,  66 ]
gravity :top_left33,     [   0,   0,  50,  34 ]

# Top
gravity :top,            [   0,   0, 100,  50 ]
gravity :top88,          [   12,   0, 88,  50 ]

# Top right
gravity :top_right,      [  50,   0,  50,  50 ]
gravity :top_right66,    [  50,   0,  50,  66 ]
gravity :top_right33,    [  50,   0,  50,  33 ]

# Left
gravity :left,           [   0,   0,  50, 100 ]
gravity :left44,         [   12,  0,  44, 100 ]
gravity :left66,         [   0,   0,  66, 100 ]
gravity :left33,         [   0,   0,  33, 100 ]

# Center
gravity :center,         [   0,   0, 100, 100 ]
gravity :center66,       [  17,  17,  66,  66 ]
gravity :center33,       [  33,  33,  33,  33 ]

# Right
gravity :right,          [  50,   0,  50, 100 ]
gravity :right44,        [  56,   0,  44, 100 ]
gravity :right66,        [  34,   0,  66, 100 ]
gravity :right88,        [  12,   0,  88, 100 ]

# Bottom left
gravity :bottom_left,    [   0,  50,  50,  50 ]
gravity :bottom_left66,  [   0,  34,  50,  66 ]
gravity :bottom_left33,  [   0,  67,  50,  33 ]

# Bottom
gravity :bottom,         [   0,  50, 100,  50 ]
gravity :bottom88,       [   12, 50, 88,   50 ]
gravity :bottom66,       [   0,  34, 100,  66 ]
gravity :bottom33,       [   0,  67, 100,  33 ]

# Bottom right
gravity :bottom_right,   [  50,  50,  50,  50 ]
gravity :bottom_right66, [  50,  34,  50,  66 ]
gravity :bottom_right33, [  50,  67,  50,  33 ]

# Gimp
gravity :gimp_image,     [  10,   0,  80, 100 ]
gravity :gimp_toolbox,   [   0,   0,  10, 100 ]
gravity :gimp_dock,      [  90,   0,  10, 100 ]

# }}}

# # Grabs {{{

# Jump to view1, view2, ...
grab "W-S-1", :ViewJump1
grab "W-S-2", :ViewJump2
grab "W-S-3", :ViewJump3
grab "W-S-4", :ViewJump4


grab "W-h",  :WindowLeft
grab "W-j",  :WindowDown
grab "W-k",    :WindowUp
grab "W-l", :WindowRight


# Switch current view
grab "W-1", :ViewSwitch1
grab "W-2", :ViewSwitch2
grab "W-3", :ViewSwitch3
grab "W-4", :ViewSwitch4
grab "W-5", :ViewSwitch5
grab "W-6", :ViewSwitch6
grab "W-7", :ViewSwitch7

# Select next and prev view */
grab "KP_Add",      :ViewNext
grab "KP_Subtract", :ViewPrev

# Move mouse to screen1, screen2, ...
grab "W-A-1", :ScreenJump1
grab "W-A-2", :ScreenJump2
grab "W-A-3", :ScreenJump3
grab "W-A-4", :ScreenJump4

# Force reload of config and sublets
grab "W-C-r", :SubtleReload

# Force restart of subtle
grab "W-C-S-r", :SubtleRestart

# Quit subtle
grab "W-C-q", :SubtleQuit

# Move current window
grab "W-B1", :WindowMove

# Resize current window
grab "W-B3", :WindowResize

# Toggle floating mode of window
grab "W-f", :WindowFloat

# Toggle fullscreen mode of window
grab "W-space", :WindowFull

# Toggle sticky mode of window (will be visible on all views)
# grab "W-s", :WindowStick

# Toggle zaphod mode of window (will span across all screens)
grab "W-equal", :WindowZaphod

# Raise window
grab "W-r", :WindowRaise

# Lower window
grab "W-l", :WindowLower

# Select next windows
grab "W-Left",  :WindowLeft
grab "W-Down",  :WindowDown
grab "W-Up",    :WindowUp
grab "W-Right", :WindowRight

# Kill current window
grab "W-S-k", :WindowKill

# In case no numpad is available e.g. on notebooks
grab "W-w", [ :top, :top88 ]
grab "W-x", [ :bottom, :bottom88 ]
grab "W-s", [ :center, :right88]
grab "W-a", [ :left, :left44, :right44, :right88 ]
grab "W-d", [ :right, :right44, :left44, :right88  ]

# Exec programs
grab "W-Return", "terminal"
grab "C-space", "dmenu_run -p '*'"
grab "W-o", "google-chrome"

# Run Ruby lambdas
grab "S-F2" do |c|
  puts c.name
end

grab "S-F3" do
  puts Subtlext::VERSION
end
# }}}

# # Tags {{{
# Simple tags
tag "terms",   "xterm|[u]?rxvt|terminal"
tag "browser", "uzbl|opera|firefox|navigator|google-chrome"
tag "google-chrome", "google-chrome"
tag "chromium", "chromium"
tag "virtualbox", "VirtualBox"
tag "pavucontrol", "pavucontrol"

# Placement
tag "editor" do
  match  "[g]?vim"
  resize true
end

tag "skype" do
  match /[s]kype/
  gravity :right
end

tag "hon" do
  match /hon-x86/
  full true
  borderless true
end

# wine
tag "wine" do
  match "Wine|wine|explorer.exe"
  float true
end

tag "flash" do
 match "<unkown>|exe|operapluginwrapper|npviewer"
 stick true
end

tag "wesnoth" do
  match "wesnoth"
end

tag "vlc_all","vlc"
tag "vlc_video" do
  match :name =>"VLC.*"
  gravity :vlc_video
end

tag "zomboid" do 
  match "zombie-FrameLoader"
  float true
  gravity :center
  brderless true
end

tag "vlc_playlist" do
  match :name => "Playlist"
  gravity :vlc_playlist
end

tag "vlc_mumble" do
  match [:name, :title] => "mumble"
end

tag "vlc_ventrilo" do
  match [:name, :title] => "mangler"
end

tag "steam" do
  match "steam.exe"
  float true
  type :dialog
  resize true
end

tag "fixed" do
  geometry [ 10, 10, 100, 100 ]
  stick    true
end

tag "resize" do
  match  "sakura|gvim"
  resize true
end

tag "webcamstudio" do
  mwatch "webcamstudio-Main"
  resize true
  float true
  type :dialog
end

tag "gravity" do
  gravity :center
end

tag "stick" do
  match "mplayer"
  float true
  stick true
end

tag "float" do
  match "display"
  float true
end

# Gimp
tag "gimp_image" do
  match   :role => "gimp-image-window"
  gravity :gimp_image
end

tag "gimp_toolbox" do
  match   :role => "gimp-toolbox$"
  gravity :gimp_toolbox
end

tag "gimp_dock" do
  match   :role => "gimp-dock"
  gravity :gimp_dock
end

tag "desura" do
  match "desura"
end
# }}}

# # Views {{{
iconpath = "#{ENV["HOME"]}/.icons/subtle"
view "terms" do
  match "terms"
  icon "#{iconpath}/arch1.xbm"
  icon_only true 
end

view "www" do
  match "chromium|google-chrome|browser"
  icon "#{iconpath}/rss1.xbm"
end
# view "chat",   "chat"
view "games" do
  match "hon"
  icon "#{iconpath}/play2.xbm"
end
view "wine", "wine|wesnot"
view "default",   "default"
view "media",  "vlc.*|banshee|rhythmbox|chromium"
view "vm",   "vm|steam|skype.*|desura|virtualbox|pavucontrol"
# }}}

# vim:ts=2:bs=2:sw=2:et:fdm=marker
