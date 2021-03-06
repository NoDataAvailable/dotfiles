-- xmonad config file

import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.UrgencyHook
import System.IO(hPutStrLn)
import XMonad.Layout.Spacing
import Data.List
import Data.Map    (fromList)
import Data.Monoid (mappend)

import XMonad.Actions.MouseResize
-- import XMonad.Actions.Volume
import XMonad.Layout.WindowArranger
import XMonad.Hooks.ICCCMFocus

import XMonad.Util.Dzen

-- Experimental:
import XMonad.Layout.StackTile
import XMonad.Layout.Tabbed

-- The preferred terminal program
--
myTerminal      = "lilyterm"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 2

--
myModMask       = mod1Mask

--
myWorkspaces :: [WorkspaceId]
myWorkspaces = [
    "^i(dzen-icons/xbm8x8/arch.xbm)",
    "^i(dzen-icons/xbm8x8/fox.xbm)",
    "^i(dzen-icons/xbm8x8/bug_01.xbm)",
    "^i(dzen-icons/xbm8x8/scorpio.xbm)",
    "^i(dzen-icons/xbm8x8/eye_l.xbm)",
    "^i(dzen-icons/xbm8x8/eye_r.xbm)",
    "^i(dzen-icons/xbm8x8/note.xbm)",
    "^i(dzen-icons/xbm8x8/dish.xbm)",
    "^i(dzen-icons/xbm8x8/pacman.xbm)"
    ]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#444444"
myFocusedBorderColor = "#666666"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "export PATH=$PATH:~/bin && dmenu_run -b") --"exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_g     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- My own shortcuts
    , ((0                 , xK_Print	), spawn "scrot")
    --, ((modm              , xK_Print	), spawn "byzanz-record ~/Dropbox/Public/desktop.gif")
   -- , ((modm              , xK_KP_Add	), lowerVolume 4 >>= alert)
   -- , ((modm              , xK_KP_Subtract), raiseVolume 4 >>= alert)
    , ((modm              , xK_KP_Add	),	spawn "~/bin/pa-vol minus")
    , ((modm              , xK_KP_Subtract), spawn "~/bin/pa-vol plus")
    , ((modm              , xK_Page_Up	), spawn "mpc volume +3")
    , ((modm              , xK_Page_Down), spawn "mpc volume -3")

    , ((modm		      ,	xK_l		), spawn "slock")
    , ((modm              ,	xK_grave    ), spawn "xterm --geometry 150x75 -e htop")
    , ((modm .|. shiftMask,	xK_grave    ), spawn "xterm --geometry 100x9 -e htop")
    , ((modm			  ,	xK_i		), spawn "xterm -g 80x21 -e ~/scripts/sys-info")
    , ((modm .|. shiftMask,	xK_m		), spawn "~/bin/touchpad_toggle")
    , ((0				  ,	0x1008ffa9	), spawn "~/bin/touchpad_toggle")

    , ((0				  ,	0x1008ff05	), spawn "asus-kbd-backlight up")
    , ((0				  ,	0x1008ff06	), spawn "asus-kbd-backlight down")

	-- XF86AudioMute
    , ((0				  , 0x1008ff12), spawn "mute_toggle")
    -- XF86AudioRaiseVolume
    , ((0				  , 0x1008ff13), spawn "vol_up")
    -- XF86AudioLowerVolume
    , ((0				  , 0x1008ff11), spawn "vol_down")
    , ((0				  , 0x1008ff14), spawn "mpc toggle")
    , ((0				  , 0x1008ff17), spawn "mpc next")
    , ((0				  , 0x1008ff16), spawn "mpc prev")
    , ((0				  , 0x1008ff15), spawn "mpc stop")
    , ((0				  , 0x1008ff12), spawn "mute_toggle")

	-- Special Keys
	-- ROG Logo:
    , ((0				  , 0x1008ff41), spawn "xcompmgr -cfC -D 5")
	-- Speedometer:
    , ((0				  , 0x1008ff46), spawn "urxvt -e ncmpcpp")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:
--
myLayout = mouseResize $ windowArrange $ avoidStruts $ tiled ||| focused_tiled ||| Mirror tiled ||| Mirror stackedTile ||| simpleTabbed ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = spacing 10 $ Tall nmaster delta ratio
    focused_tiled   = spacing 10 $ Tall nmaster delta fratio
    stackedTile = StackTile nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    fratio  = 3/4

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "mplayer2"       --> doFloat
    , className =? "mpv"       --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "Vlc"            --> doFloat
    , className =? "Steam"			--> doFloat
    , className =? "Apple2"	   		--> doFloat
    , className =? "feh"      	    --> doFloat
	  , className =? "XTerm"			--> doFloat
--	, className =? "URxvt"			--> doFloat
	, className =? "hl2_linux"		--> doShift "game"
	]

------------------------------------------------------------------------
-- Event handling
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging
--
--myLogHook = dynamicLogWithPP $ xmobarPP {
--    ppOutput = hPutStrLn $ xmproc,
--    ppCurrent = xmobarColor "cyan" "" . wrap "[" "]",
--    ppTitle = xmobarColor "purple" "" . shorten 40,
--    ppVisible = wrap "(" ")",
--    ppUrgent  = xmobarColor "red" "yellow",
--    ppLayout = const ""
--}

alert = dzenConfig centered . show . round
centered =
        onCurr (center 150 66)
    >=> font "-*-aller-*-r-*-*-64-*-*-*-*-*-*-*"
    -- >=> addArgs ["-fg", "#80c0ff"]
    -- >=> addArgs ["-bg", "#222222"]

------------------------------------------------------------------------
-- Startup hook
--
myStartupHook = return ()

------------------------------------------------------------------------
-- Run it all!
--
main = do
    xmproc <- spawnPipe "xmobar /home/robert/.xmobarrc"
    dzproc <- spawnPipe "dzen2 -ta l -w 1470 -h 15 -y 0 -dock"
    xmonad $ defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = manageDocks <+> myManageHook <+> manageHook defaultConfig,
        handleEventHook    = myEventHook,
		logHook 		   = dynamicLogWithPP $ dzenPP {
			ppOutput 		   = hPutStrLn $ dzproc,
            ppWsSep 		   = " ",
            ppSep 			   = "  ",
            --ppCurrent 		   = dzenColor "#FF4848" "#59955C" . wrap " " " ",
            --ppHidden  		   = dzenColor "#8ADCFF" "#59955C" . wrap " " " " . wrapClick . (\a -> (a,a)),
            --ppHiddenNoWindows  = dzenColor "#5EAE9E" "#4A9586" . pad . wrap "" "" . wrapClick . (\a -> (a,a)),
            ppCurrent 		   = dzenColor "#606060" "#C0C0C0" . wrap " " " ",
            ppHidden  		   = dzenColor "#C0C0C0" "#606060" . wrap " " " " . wrapClick . (\a -> (a,a)),
            ppHiddenNoWindows= dzenColor "#606060" "#303030" . pad . wrap "" "" . wrapClick . (\a -> (a,a)),
            ppTitle 		     = dzenColor "#C0C0C0" "#404040" . shorten 100 . wrap " " " ",
            ppVisible 		   = dzenColor "#DD79AB" "#C0C0C0" . wrap " " " ",
            ppUrgent  		   = dzenColor "red" "yellow",
            ppLayout 		     = const ""
		},

        startupHook        = myStartupHook

    }

	where
		wrapClick (idx,str) = "^ca(1," ++ xdo "w;" ++ xdo index ++ ")" ++ "^ca(3," ++ xdo "e;" ++ xdo index ++ ")" ++ str ++ "^ca()^ca()"
			where
				wsIdxToString Nothing = "1"
				wsIdxToString (Just n) = show (n+1)
				index = wsIdxToString (elemIndex idx myWorkspaces)
				xdo key = "xdotool key alt+" ++ key

