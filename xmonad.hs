{-# LANGUAGE FlexibleContexts, NamedFieldPuns, LambdaCase #-}

import Data.Monoid
import qualified Data.Map as M
import System.Exit
import System.Environment
import Control.Concurrent

import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W

extendConfig conf =
  conf
    {
      manageHook =
        pbManageHook <>
        manageDocks <>
        manageHook conf,
      layoutHook = avoidStruts (smartBorders tiled),
      handleEventHook =
        ewmhDesktopsEventHook <>
        docksEventHook <>
        fullscreenEventHook,
      workspaces = map show [1 .. 9 :: Int],
      logHook = ewmhDesktopsLogHook,
      startupHook =
        startupHook conf <>
        ewmhDesktopsStartup <>
        setWMName "LG3D" {- Java app focus fix -},
      keys = myKeys,
      normalBorderColor =  "#232323",
      focusedBorderColor = "#008080",
      borderWidth = 1,
      terminal = exo "TerminalEmulator",
      modMask = mod4Mask
    }

tiled = Tall 1 (3/100) (1/2)

pbManageHook :: ManageHook
pbManageHook =
  composeAll
    [ manageDocks,
      manageHook defaultConfig,
      isDialog --> doCenterFloat,
      isFullscreen --> doFullFloat,
      fmap not isDialog --> doF avoidMaster,
      appName =? "xfce4-appfinder" --> doFullFloat
    ]

avoidMaster :: W.StackSet i l a s sd -> W.StackSet i l a s sd
avoidMaster = W.modify' $ \case
  W.Stack t [] (r:rs) -> W.Stack t [r] rs
  c -> c

exo s = "exo-open --launch " ++ s

appfinder = spawn "xfce4-appfinder"
browser = spawn (exo "WebBrowser")
filemanager = spawn (exo "FileManager")

data I3LockTy = WithBg | WithBlur

i3lock lt = unwords
  [ "i3lock-color -f",
    "--insidevercolor='#008080ff'",
    "--ringvercolor='#008080ff'",
    "--insidewrongcolor='#8f3630ff'",
    "--ringwrongcolor='#8f3630ff'",
    "--insidecolor='#1a1a1abb'",
    "--ringcolor='#008080bb'",
    "--linecolor='#00000000'",
    "--separatorcolor='#008080ff'",
    "--textcolor='#d0d0d0ff'",
    "--timecolor='#d0d0d0ff'",
    "--datecolor='#d0d0d0ff'",
    "--keyhlcolor='#d0d0d0ff'",
    "--bshlcolor='#8f3630ff'",
    "--screen 0",
    case lt of { WithBg -> "--color 1a1a1a"; WithBlur -> "--blur 5" },
    "--clock",
    "--indicator",
    "--timestr=\"%H:%M:%S\"",
    "--datestr=\"%Y-%m-%d, %a\"",
    "--veriftext='checking'",
    "--wrongtext='rejected'"
  ]

myKeys conf@(XConfig {modMask, terminal, layoutHook, workspaces}) = M.fromList $
  [ ((modMask, xK_Return), spawn terminal),
    ((modMask, xK_p), appfinder),
    ((modMask, xK_g), browser),
    ((modMask, xK_f), filemanager),
    ((modMask, xK_c), kill),
    ((modMask, xK_b), sendMessage ToggleStruts),
    ((modMask, xK_e), spawn "nvim-qt"),
    ((0, xK_Print), spawn "xfce4-screenshooter"),

    ((modMask, xK_space), sendMessage NextLayout),
    ((modMask .|. shiftMask, xK_space), setLayout layoutHook),
    ((modMask, xK_t), withFocused $ windows . W.sink),
    ((modMask, xK_j), windows W.focusDown),
    ((modMask, xK_k), windows W.focusUp),

    ((modMask .|. shiftMask,  xK_Return), windows W.swapMaster),
    ((modMask .|. shiftMask,  xK_j), windows W.swapDown),
    ((modMask .|. shiftMask,  xK_k), windows W.swapUp),

    ((modMask, xK_comma), sendMessage (IncMasterN 1)),
    ((modMask, xK_period), sendMessage (IncMasterN (-1))),

    ((modMask, xK_h), sendMessage Shrink),
    ((modMask, xK_l), sendMessage Expand),

    ((modMask .|. shiftMask, xK_l), spawn (i3lock WithBlur)),
    ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
  ]
  ++
  [ ((m .|. modMask, k), windows $ f i)
    | (i, k) <- zip workspaces [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]

main :: IO ()
main = do
  spawn "xrandr --output eDP1 --gamma 0.8:0.8:0.8"
  spawn "xfsettingsd"
  homeDir <- getEnv "HOME"
  spawn $ "feh --bg-scale \"" ++ homeDir ++ "/.wallpaper\" && xsetroot -cursor_name left_ptr"
  spawn "xfce4-panel --disable-wm-check"
  spawn "xfce4-power-manager"
  spawn "xfce4-volumed-pulse"
  spawn "nm-applet"
  xmonad (extendConfig xfceConfig)
