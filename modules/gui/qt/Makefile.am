## Howto
# For each Q_OBJECT:
#   - Add *.moc.cpp to nodist_..._SOURCES
#   - Add *.cpp to ..._SOURCES
#   - Add *.hpp to ..._SOURCES
# For each UI
#   - Add *.ui to ..._UI
#   - Add *.h to nodist_..._SOURCES
# For each ressource (icon, png, ...)
#   - Add it to DEPS_res
# For each qml and js ressource
#   - Add it to ..._QML

SUFFIXES += .ui .h .hpp .moc.cpp .qml

libqt_plugin_la_CPPFLAGS = $(AM_CPPFLAGS) \
	-I$(srcdir)/gui/qt -I$(builddir)/gui/qt/ui
libqt_plugin_la_CXXFLAGS = $(AM_CXXFLAGS) $(QT_CFLAGS) $(CXXFLAGS_qt)
libqt_plugin_la_LIBADD = $(QT_LIBS) $(LIBS_qt) $(LIBM)
libqt_plugin_la_LDFLAGS = $(AM_LDFLAGS) -rpath '$(guidir)'
if HAVE_DARWIN
libqt_plugin_la_LDFLAGS += -Wl,-framework,Cocoa
endif
if HAVE_QT5_X11
libqt_plugin_la_CXXFLAGS += $(QT5_X11_CFLAGS) -DQT5_HAS_X11
libqt_plugin_la_LIBADD += $(QT5_X11_LIBS) $(X_LIBS) $(X_PRE_LIB) -lX11
endif
if HAVE_XCB
libqt_plugin_la_CXXFLAGS += -DQT5_HAS_XCB
endif
if HAVE_WAYLAND
libqt_plugin_la_CPPFLAGS += -DQT5_HAS_WAYLAND \
	-DQPNI_HEADER=\<$(QT_VERSION)/QtGui/qpa/qplatformnativeinterface.h\>
libqt_plugin_la_CXXFLAGS += $(WAYLAND_CLIENT_CFLAGS)
libqt_plugin_la_LIBADD += $(WAYLAND_CLIENT_LIBS)
endif
if HAVE_WIN32
libqt_plugin_la_LIBADD += $(LIBCOM) -lcomctl32 -luuid
endif
if UPDATE_CHECK
libqt_plugin_la_CPPFLAGS += -DUPDATE_CHECK
endif
if QT_QML_DEBUG
libqt_plugin_la_CPPFLAGS += -DQT_QML_DEBUG
endif

libqt_plugin_la_SOURCES = \
	gui/qt/qt.cpp gui/qt/qt.hpp \
	gui/qt/menus.cpp gui/qt/menus.hpp \
	gui/qt/main_interface.cpp gui/qt/main_interface.hpp \
	gui/qt/dialogs_provider.cpp gui/qt/dialogs_provider.hpp \
	gui/qt/extensions_manager.cpp gui/qt/extensions_manager.hpp \
	gui/qt/managers/addons_manager.cpp gui/qt/managers/addons_manager.hpp \
	gui/qt/managers/renderer_manager.cpp gui/qt/managers/renderer_manager.hpp \
	gui/qt/recents.cpp gui/qt/recents.hpp \
	gui/qt/adapters/chromaprint.cpp gui/qt/adapters/chromaprint.hpp \
	gui/qt/adapters/var_common_p.hpp \
	gui/qt/adapters/variables.cpp gui/qt/adapters/variables.hpp \
	gui/qt/adapters/var_choice_model.cpp  gui/qt/adapters/var_choice_model.hpp \
	gui/qt/dialogs/bookmarks.cpp gui/qt/dialogs/bookmarks.hpp \
	gui/qt/dialogs/preferences.cpp gui/qt/dialogs/preferences.hpp \
	gui/qt/dialogs/mediainfo.cpp gui/qt/dialogs/mediainfo.hpp \
	gui/qt/dialogs/epg.cpp gui/qt/dialogs/epg.hpp \
	gui/qt/dialogs/extended.cpp gui/qt/dialogs/extended.hpp \
	gui/qt/dialogs/messages.cpp gui/qt/dialogs/messages.hpp \
	gui/qt/dialogs/errors.cpp gui/qt/dialogs/errors.hpp \
	gui/qt/dialogs/plugins.cpp gui/qt/dialogs/plugins.hpp \
	gui/qt/dialogs/sout.cpp gui/qt/dialogs/sout.hpp \
	gui/qt/dialogs/convert.cpp gui/qt/dialogs/convert.hpp \
	gui/qt/dialogs/help.cpp gui/qt/dialogs/help.hpp \
	gui/qt/dialogs/gototime.cpp gui/qt/dialogs/gototime.hpp \
	gui/qt/dialogs/toolbar.cpp gui/qt/dialogs/toolbar.hpp \
	gui/qt/dialogs/toolbareditor.cpp gui/qt/dialogs/toolbareditor.hpp \
	gui/qt/dialogs/open.cpp gui/qt/dialogs/open.hpp \
	gui/qt/dialogs/openurl.cpp gui/qt/dialogs/openurl.hpp \
	gui/qt/dialogs/vlm.cpp gui/qt/dialogs/vlm.hpp \
	gui/qt/dialogs/firstrun.cpp gui/qt/dialogs/firstrun.hpp \
	gui/qt/dialogs/podcast_configuration.cpp \
	gui/qt/dialogs/podcast_configuration.hpp \
	gui/qt/dialogs/extensions.cpp gui/qt/dialogs/extensions.hpp \
	gui/qt/dialogs/fingerprintdialog.cpp \
	gui/qt/dialogs/fingerprintdialog.hpp \
	gui/qt/components/qml_main_context.cpp \
	gui/qt/components/qml_main_context.hpp \
	gui/qt/components/aboutmodel.cpp \
	gui/qt/components/aboutmodel.hpp \
	gui/qt/components/dialogmodel.cpp \
	gui/qt/components/dialogmodel.hpp \
	gui/qt/components/extended_panels.cpp \
	gui/qt/components/extended_panels.hpp \
	gui/qt/components/info_panels.cpp gui/qt/components/info_panels.hpp \
	gui/qt/components/info_widgets.cpp gui/qt/components/info_widgets.hpp \
	gui/qt/components/navigation_history.cpp gui/qt/components/navigation_history.hpp \
	gui/qt/components/player_controller.cpp gui/qt/components/player_controller.hpp gui/qt/components/player_controller_p.hpp \
	gui/qt/components/preferences_widgets.cpp \
	gui/qt/components/preferences_widgets.hpp \
	gui/qt/components/selectable_list_model.hpp \
	gui/qt/components/selectable_list_model.cpp \
	gui/qt/components/complete_preferences.cpp \
	gui/qt/components/complete_preferences.hpp \
	gui/qt/components/simple_preferences.cpp \
	gui/qt/components/simple_preferences.hpp \
	gui/qt/components/open_panels.cpp gui/qt/components/open_panels.hpp \
	gui/qt/components/interface_widgets.cpp \
	gui/qt/components/interface_widgets.hpp \
	gui/qt/components/controller.cpp gui/qt/components/controller.hpp \
	gui/qt/components/playercontrolbarmodel.cpp gui/qt/components/playercontrolbarmodel.hpp \
	gui/qt/components/controller_widget.cpp \
	gui/qt/components/controller_widget.hpp \
	gui/qt/components/recent_media_model.cpp  \
	gui/qt/components/recent_media_model.hpp \
	gui/qt/components/settings.cpp \
	gui/qt/components/settings.hpp \
	gui/qt/components/audio_device_model.cpp  \
	gui/qt/components/audio_device_model.hpp \
	gui/qt/components/mediacenter/ml_folders_model.hpp  \
	gui/qt/components/mediacenter/ml_folders_model.cpp \
	gui/qt/components/voutwindow/videosurface.cpp \
	gui/qt/components/voutwindow/videosurface.hpp \
	gui/qt/components/voutwindow/qvoutwindow.cpp \
	gui/qt/components/voutwindow/qvoutwindow.hpp \
	gui/qt/components/voutwindow/qvoutwindowdummy.cpp \
	gui/qt/components/voutwindow/qvoutwindowdummy.hpp \
	gui/qt/components/custom_menus.cpp \
	gui/qt/components/custom_menus.hpp \
	gui/qt/components/epg/EPGChannels.cpp \
	gui/qt/components/epg/EPGChannels.hpp \
	gui/qt/components/epg/EPGItem.cpp \
	gui/qt/components/epg/EPGItem.hpp \
	gui/qt/components/epg/EPGProgram.cpp \
	gui/qt/components/epg/EPGProgram.hpp \
	gui/qt/components/epg/EPGRuler.cpp gui/qt/components/epg/EPGRuler.hpp \
	gui/qt/components/epg/EPGView.cpp gui/qt/components/epg/EPGView.hpp \
	gui/qt/components/epg/EPGWidget.cpp \
	gui/qt/components/epg/EPGWidget.hpp \
	gui/qt/components/mediacenter/mcmedialib.cpp \
	gui/qt/components/mediacenter/mcmedialib.hpp \
	gui/qt/components/mediacenter/mlhelper.hpp \
	gui/qt/components/mediacenter/mlqmltypes.hpp \
	gui/qt/components/mediacenter/mlbasemodel.cpp \
	gui/qt/components/mediacenter/mlbasemodel.hpp \
	gui/qt/components/mediacenter/mlalbum.cpp \
	gui/qt/components/mediacenter/mlalbum.hpp \
	gui/qt/components/mediacenter/mlalbummodel.cpp \
	gui/qt/components/mediacenter/mlalbummodel.hpp \
	gui/qt/components/mediacenter/mlalbumtrack.cpp \
	gui/qt/components/mediacenter/mlalbumtrack.hpp \
	gui/qt/components/mediacenter/mlalbumtrackmodel.cpp \
	gui/qt/components/mediacenter/mlalbumtrackmodel.hpp \
	gui/qt/components/mediacenter/mlartist.cpp \
	gui/qt/components/mediacenter/mlartist.hpp \
	gui/qt/components/mediacenter/mlartistmodel.cpp \
	gui/qt/components/mediacenter/mlartistmodel.hpp \
	gui/qt/components/mediacenter/mlgenre.cpp \
	gui/qt/components/mediacenter/mlgenre.hpp \
	gui/qt/components/mediacenter/mlgenremodel.cpp \
	gui/qt/components/mediacenter/mlgenremodel.hpp \
	gui/qt/components/mediacenter/mlnetworkmodel.cpp \
	gui/qt/components/mediacenter/mlnetworkmodel.hpp \
	gui/qt/components/mediacenter/mlvideo.hpp \
	gui/qt/components/mediacenter/mlvideo.cpp \
	gui/qt/components/mediacenter/mlvideomodel.cpp \
	gui/qt/components/mediacenter/mlvideomodel.hpp \
	gui/qt/components/mediacenter/mlrecentsvideomodel.cpp \
	gui/qt/components/mediacenter/mlrecentsvideomodel.hpp \
	gui/qt/components/playlist/media.hpp \
	gui/qt/components/playlist/playlist_common.cpp \
	gui/qt/components/playlist/playlist_common.hpp \
	gui/qt/components/playlist/playlist_controller.cpp \
	gui/qt/components/playlist/playlist_controller.hpp \
	gui/qt/components/playlist/playlist_controller_p.hpp \
	gui/qt/components/playlist/playlist_item.cpp \
	gui/qt/components/playlist/playlist_item.hpp \
	gui/qt/components/playlist/playlist_model.cpp \
	gui/qt/components/playlist/playlist_model.hpp \
	gui/qt/components/playlist/playlist_model_p.hpp \
	gui/qt/components/sout/profile_selector.cpp \
	gui/qt/components/sout/profile_selector.hpp \
	gui/qt/components/sout/sout_widgets.cpp \
	gui/qt/components/sout/sout_widgets.hpp \
	gui/qt/components/sout/profiles.hpp \
	gui/qt/util/animators.cpp gui/qt/util/animators.hpp \
	gui/qt/util/input_slider.cpp gui/qt/util/input_slider.hpp \
	gui/qt/util/input_models.cpp gui/qt/util/input_models.hpp \
	gui/qt/util/timetooltip.cpp gui/qt/util/timetooltip.hpp \
	gui/qt/util/customwidgets.cpp gui/qt/util/customwidgets.hpp \
	gui/qt/util/searchlineedit.cpp gui/qt/util/searchlineedit.hpp \
	gui/qt/util/registry.cpp gui/qt/util/registry.hpp \
	gui/qt/util/qt_dirs.cpp gui/qt/util/qt_dirs.hpp \
	gui/qt/util/validators.cpp gui/qt/util/validators.hpp \
	gui/qt/util/buttons/BrowseButton.cpp \
	gui/qt/util/buttons/BrowseButton.hpp \
	gui/qt/util/buttons/DeckButtonsLayout.cpp \
	gui/qt/util/buttons/DeckButtonsLayout.hpp \
	gui/qt/util/buttons/RoundButton.cpp \
	gui/qt/util/buttons/RoundButton.hpp \
	gui/qt/util/qvlcframe.cpp \
	gui/qt/util/qvlcframe.hpp \
	gui/qt/util/qvlcapp.hpp \
	gui/qt/util/qmleventfilter.cpp \
	gui/qt/util/qmleventfilter.hpp \
	gui/qt/util/singleton.hpp \
	gui/qt/util/vlctick.cpp \
	gui/qt/util/vlctick.hpp \
	gui/qt/util/imagehelper.cpp gui/qt/util/imagehelper.hpp \
	gui/qt/styles/seekstyle.cpp gui/qt/styles/seekstyle.hpp
if HAVE_WIN32
libqt_plugin_la_SOURCES += \
	gui/qt/main_interface_win32.cpp gui/qt/main_interface_win32.hpp
endif

# Meta-object compilation

moc_verbose = $(moc_verbose_$(V))
moc_verbose_ = $(moc_verbose__$(AM_DEFAULT_VERBOSITY))
moc_verbose_0 = @echo "  MOC   " $@;
moc_verbose__0 = $(moc_verbose_0)

.hpp.moc.cpp:
	$(moc_verbose)$(MOC) $(MOC_CPPFLAGS) -o $@ $<

# These MOC files depend on the configure settings:
dialogs_provider.moc.cpp dialogs/vlm.moc.cpp: $(top_builddir)/config.h

nodist_libqt_plugin_la_SOURCES = \
	gui/qt/main_interface.moc.cpp \
	gui/qt/menus.moc.cpp \
	gui/qt/dialogs_provider.moc.cpp \
	gui/qt/extensions_manager.moc.cpp \
	gui/qt/managers/addons_manager.moc.cpp \
	gui/qt/managers/renderer_manager.moc.cpp \
	gui/qt/recents.moc.cpp \
	gui/qt/adapters/chromaprint.moc.cpp \
	gui/qt/adapters/variables.moc.cpp \
	gui/qt/adapters/var_choice_model.moc.cpp \
	gui/qt/dialogs/bookmarks.moc.cpp \
	gui/qt/dialogs/mediainfo.moc.cpp \
	gui/qt/dialogs/extended.moc.cpp \
	gui/qt/dialogs/messages.moc.cpp \
	gui/qt/dialogs/epg.moc.cpp \
	gui/qt/dialogs/errors.moc.cpp \
	gui/qt/dialogs/plugins.moc.cpp \
	gui/qt/dialogs/preferences.moc.cpp \
	gui/qt/dialogs/sout.moc.cpp \
	gui/qt/dialogs/convert.moc.cpp \
	gui/qt/dialogs/help.moc.cpp \
	gui/qt/dialogs/gototime.moc.cpp \
	gui/qt/dialogs/toolbar.moc.cpp \
	gui/qt/dialogs/toolbareditor.moc.cpp \
	gui/qt/dialogs/open.moc.cpp \
	gui/qt/dialogs/openurl.moc.cpp \
	gui/qt/dialogs/podcast_configuration.moc.cpp \
	gui/qt/dialogs/firstrun.moc.cpp \
	gui/qt/dialogs/extensions.moc.cpp \
	gui/qt/dialogs/fingerprintdialog.moc.cpp \
	gui/qt/components/qml_main_context.moc.cpp \
	gui/qt/components/aboutmodel.moc.cpp \
	gui/qt/components/dialogmodel.moc.cpp \
	gui/qt/components/extended_panels.moc.cpp \
	gui/qt/components/info_panels.moc.cpp \
	gui/qt/components/info_widgets.moc.cpp \
	gui/qt/components/player_controller.moc.cpp \
	gui/qt/components/preferences_widgets.moc.cpp \
	gui/qt/components/complete_preferences.moc.cpp \
	gui/qt/components/simple_preferences.moc.cpp \
	gui/qt/components/open_panels.moc.cpp \
	gui/qt/components/interface_widgets.moc.cpp \
	gui/qt/components/navigation_history.moc.cpp \
	gui/qt/components/controller.moc.cpp \
	gui/qt/components/playercontrolbarmodel.moc.cpp \
	gui/qt/components/controller_widget.moc.cpp \
	gui/qt/components/custom_menus.moc.cpp \
	gui/qt/components/recent_media_model.moc.cpp \
	gui/qt/components/selectable_list_model.moc.cpp \
	gui/qt/components/settings.moc.cpp \
	gui/qt/components/audio_device_model.moc.cpp \
	gui/qt/components/mediacenter/ml_folders_model.moc.cpp \
	gui/qt/components/voutwindow/videosurface.moc.cpp \
	gui/qt/components/voutwindow/qvoutwindow.moc.cpp \
	gui/qt/components/voutwindow/qvoutwindowdummy.moc.cpp \
	gui/qt/components/epg/EPGChannels.moc.cpp \
	gui/qt/components/epg/EPGProgram.moc.cpp \
	gui/qt/components/epg/EPGRuler.moc.cpp \
	gui/qt/components/epg/EPGView.moc.cpp \
	gui/qt/components/epg/EPGWidget.moc.cpp \
	gui/qt/components/mediacenter/mcmedialib.moc.cpp \
	gui/qt/components/mediacenter/mlqmltypes.moc.cpp \
	gui/qt/components/mediacenter/mlbasemodel.moc.cpp \
	gui/qt/components/mediacenter/mlalbum.moc.cpp \
	gui/qt/components/mediacenter/mlalbummodel.moc.cpp \
	gui/qt/components/mediacenter/mlalbumtrack.moc.cpp \
	gui/qt/components/mediacenter/mlalbumtrackmodel.moc.cpp \
	gui/qt/components/mediacenter/mlartist.moc.cpp \
	gui/qt/components/mediacenter/mlartistmodel.moc.cpp \
	gui/qt/components/mediacenter/mlgenre.moc.cpp \
	gui/qt/components/mediacenter/mlgenremodel.moc.cpp \
	gui/qt/components/mediacenter/mlnetworkmodel.moc.cpp \
	gui/qt/components/mediacenter/mlvideo.moc.cpp \
	gui/qt/components/mediacenter/mlvideomodel.moc.cpp \
	gui/qt/components/mediacenter/mlrecentsvideomodel.moc.cpp \
	gui/qt/components/playlist/playlist_common.moc.cpp \
	gui/qt/components/playlist/playlist_item.moc.cpp \
	gui/qt/components/playlist/playlist_model.moc.cpp \
	gui/qt/components/playlist/playlist_controller.moc.cpp \
	gui/qt/components/sout/profile_selector.moc.cpp \
	gui/qt/components/sout/sout_widgets.moc.cpp \
	gui/qt/util/animators.moc.cpp \
	gui/qt/util/input_slider.moc.cpp \
	gui/qt/util/input_models.moc.cpp \
	gui/qt/util/timetooltip.moc.cpp \
	gui/qt/util/customwidgets.moc.cpp \
	gui/qt/util/qmleventfilter.moc.cpp \
	gui/qt/util/searchlineedit.moc.cpp \
	gui/qt/util/qvlcapp.moc.cpp \
	gui/qt/util/vlctick.moc.cpp \
	gui/qt/util/validators.moc.cpp \
	gui/qt/util/buttons/RoundButton.moc.cpp \
	gui/qt/util/buttons/DeckButtonsLayout.moc.cpp \
	gui/qt/util/buttons/BrowseButton.moc.cpp \
	gui/qt/styles/seekstyle.moc.cpp

if HAVE_WIN32
nodist_libqt_plugin_la_SOURCES += gui/qt/main_interface_win32.moc.cpp
endif

nodist_libqt_plugin_la_SOURCES += \
	gui/qt/ui/ui_equalizer.h \
	gui/qt/ui/ui_video_effects.h \
	gui/qt/ui/ui_open_file.h \
	gui/qt/ui/ui_open_disk.h \
	gui/qt/ui/ui_open_net.h \
	gui/qt/ui/ui_open_capture.h \
	gui/qt/ui/ui_open.h \
	gui/qt/ui/ui_vlm.h \
	gui/qt/ui/ui_podcast_configuration.h \
	gui/qt/ui/ui_profiles.h \
	gui/qt/ui/ui_sprefs_audio.h \
	gui/qt/ui/ui_sprefs_input.h \
	gui/qt/ui/ui_sprefs_interface.h \
	gui/qt/ui/ui_sprefs_subtitles.h \
	gui/qt/ui/ui_sprefs_video.h \
	gui/qt/ui/ui_streampanel.h \
	gui/qt/ui/ui_messages_panel.h \
	gui/qt/ui/ui_about.h \
	gui/qt/ui/ui_update.h \
	gui/qt/ui/ui_fingerprintdialog.h \
	gui/qt/ui/ui_sout.h

# User interface compilation

uic_verbose = $(uic_verbose_$(V))
uic_verbose_ = $(uic_verbose__$(AM_DEFAULT_VERBOSITY))
uic_verbose_0 = @echo "  UIC   " $@;
uic_verbose__0 = $(uic_verbose_0)

MOC_CPPFLAGS = $(DEFS) \
	-I$(top_srcdir)/include -I$(top_builddir)/include -I$(top_builddir) \
	$(libqt_plugin_la_CPPFLAGS)
if HAVE_DARWIN
MOC_CPPFLAGS += -DQ_OS_MAC
endif
if HAVE_WIN32
MOC_CPPFLAGS += -D_WIN32
endif

libqt_plugin_la_UI = \
	gui/qt/ui/equalizer.ui \
	gui/qt/ui/video_effects.ui \
	gui/qt/ui/open_file.ui \
	gui/qt/ui/open_disk.ui \
	gui/qt/ui/open_net.ui \
	gui/qt/ui/open_capture.ui \
	gui/qt/ui/open.ui \
	gui/qt/ui/podcast_configuration.ui \
	gui/qt/ui/profiles.ui \
	gui/qt/ui/sprefs_audio.ui \
	gui/qt/ui/sprefs_input.ui \
	gui/qt/ui/sprefs_interface.ui \
	gui/qt/ui/sprefs_subtitles.ui \
	gui/qt/ui/sprefs_video.ui \
	gui/qt/ui/streampanel.ui \
	gui/qt/ui/messages_panel.ui \
	gui/qt/ui/about.ui \
	gui/qt/ui/update.ui \
	gui/qt/ui/sout.ui \
	gui/qt/ui/vlm.ui \
	gui/qt/ui/fingerprintdialog.ui
EXTRA_DIST += $(libqt_plugin_la_UI)

ui_%.h: %.ui
	$(AM_V_at)$(MKDIR_P) "gui/qt/ui"
	$(AM_V_at)rm -f $@ $@.tmp
	$(AM_V_at)echo "#define Q_(a,b) QString::fromUtf8(_(a))" > $@.tmp
	$(uic_verbose)$(UIC) -tr "Q_" $< >> $@.tmp
	$(AM_V_at)sed -e 's/Q_(\"_(\\\"\(.*\)\\\")"/Q_("\1"/' $@.tmp >$@
	$(AM_V_at)rm -f $@.tmp

# Resources

libqt_plugin_la_RES = \
	gui/qt/pixmaps/VLCIcons.ttf \
	gui/qt/pixmaps/clear.svg \
	gui/qt/pixmaps/eject.svg \
	gui/qt/pixmaps/faster.svg \
	gui/qt/pixmaps/faster2.svg \
	gui/qt/pixmaps/go-next.svg \
	gui/qt/pixmaps/addons/addon.svg \
	gui/qt/pixmaps/addons/addon_broken.svg \
	gui/qt/pixmaps/addons/addon_blue.svg \
	gui/qt/pixmaps/addons/addon_cyan.svg \
	gui/qt/pixmaps/addons/addon_green.svg \
	gui/qt/pixmaps/addons/addon_magenta.svg \
	gui/qt/pixmaps/addons/addon_red.svg \
	gui/qt/pixmaps/addons/addon_yellow.svg \
	gui/qt/pixmaps/addons/score.svg \
	gui/qt/pixmaps/menu.svg \
	gui/qt/pixmaps/menus/exit_16px.svg \
	gui/qt/pixmaps/menus/help_16px.svg \
	gui/qt/pixmaps/menus/info_16px.svg \
	gui/qt/pixmaps/menus/messages_16px.svg \
	gui/qt/pixmaps/menus/playlist_16px.svg \
	gui/qt/pixmaps/menus/preferences_16px.svg \
	gui/qt/pixmaps/menus/settings_16px.svg \
	gui/qt/pixmaps/menus/stream_16px.svg \
	gui/qt/pixmaps/next.svg \
	gui/qt/pixmaps/noart-64.png \
	gui/qt/pixmaps/noart.png \
	gui/qt/pixmaps/noart_album.svg \
	gui/qt/pixmaps/noart_artist.svg \
	gui/qt/pixmaps/noart_artist_small.svg \
	gui/qt/pixmaps/pause.svg \
	gui/qt/pixmaps/play.svg \
	gui/qt/pixmaps/playlist/add.svg \
	gui/qt/pixmaps/playlist/playlist.svg \
	gui/qt/pixmaps/playlist/remove.svg \
	gui/qt/pixmaps/playlist/repeat_all.svg \
	gui/qt/pixmaps/playlist/repeat_off.svg \
	gui/qt/pixmaps/playlist/repeat_one.svg \
	gui/qt/pixmaps/playlist/active_indicator.svg \
	gui/qt/pixmaps/playlist/shuffle_on.svg \
	gui/qt/pixmaps/playlist/dropzone.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/capture.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/pictures.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/disc.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/playlist.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/lan.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/podcast.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/library.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/screen.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/movie.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/mtp.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/music.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/network.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/sd/appletrailers.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/sd/icecast.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/sd/katsomo.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/sd/fmc.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/sd/frenchtv.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/sd/jamendo.svg \
	gui/qt/pixmaps/playlist/sidebar-icons/sd/assembleenationale.svg \
	gui/qt/pixmaps/prefs/advprefs_audio.svg \
	gui/qt/pixmaps/prefs/advprefs_codec.svg \
	gui/qt/pixmaps/prefs/advprefs_extended.svg \
	gui/qt/pixmaps/prefs/advprefs_intf.svg \
	gui/qt/pixmaps/prefs/advprefs_playlist.svg \
	gui/qt/pixmaps/prefs/advprefs_sout.svg \
	gui/qt/pixmaps/prefs/advprefs_video.svg \
	gui/qt/pixmaps/prefs/spref_cone_Audio_64.png \
	gui/qt/pixmaps/prefs/spref_cone_Hotkeys_64.png \
	gui/qt/pixmaps/prefs/spref_cone_Input_64.png \
	gui/qt/pixmaps/prefs/spref_cone_Interface_64.png \
	gui/qt/pixmaps/prefs/spref_cone_Subtitles_64.png \
	gui/qt/pixmaps/prefs/spref_cone_Video_64.png \
	gui/qt/pixmaps/previous.svg \
	gui/qt/pixmaps/profile_new.svg \
	gui/qt/pixmaps/sample_complete.png \
	gui/qt/pixmaps/sample_minimal.png \
	gui/qt/pixmaps/sample_skins.png \
	gui/qt/pixmaps/slower.svg \
	gui/qt/pixmaps/slower2.svg \
	gui/qt/pixmaps/space.svg \
	gui/qt/pixmaps/stop.svg \
	gui/qt/pixmaps/toolbar/audiosub.svg \
	gui/qt/pixmaps/toolbar/arrows.svg \
	gui/qt/pixmaps/toolbar/aspect-ratio.svg \
	gui/qt/pixmaps/toolbar/atob.svg \
	gui/qt/pixmaps/toolbar/atob_noa.svg \
	gui/qt/pixmaps/toolbar/atob_nob.svg \
	gui/qt/pixmaps/toolbar/atob_bg_a.svg \
	gui/qt/pixmaps/toolbar/atob_bg_ab.svg \
	gui/qt/pixmaps/toolbar/atob_bg_b.svg \
	gui/qt/pixmaps/toolbar/atob_bg_none.svg \
	gui/qt/pixmaps/toolbar/atob_fg_a.svg \
	gui/qt/pixmaps/toolbar/atob_fg_ab.svg \
	gui/qt/pixmaps/toolbar/atob_fg_b.svg \
	gui/qt/pixmaps/toolbar/renderer.svg \
	gui/qt/pixmaps/toolbar/defullscreen.svg \
	gui/qt/pixmaps/toolbar/dvd_menu.svg \
	gui/qt/pixmaps/toolbar/dvd_next.svg \
	gui/qt/pixmaps/toolbar/dvd_prev.svg \
	gui/qt/pixmaps/toolbar/extended_16px.svg \
	gui/qt/pixmaps/toolbar/frame-by-frame.svg \
	gui/qt/pixmaps/toolbar/fullscreen.svg \
	gui/qt/pixmaps/toolbar/play_reverse.svg \
	gui/qt/pixmaps/toolbar/record_16px.svg \
	gui/qt/pixmaps/toolbar/snapshot.svg \
	gui/qt/pixmaps/toolbar/skip_for.svg \
	gui/qt/pixmaps/toolbar/skip_back.svg \
	gui/qt/pixmaps/toolbar/tv.svg \
	gui/qt/pixmaps/toolbar/tvtelx.svg \
	gui/qt/pixmaps/toolbar/visu.svg \
	gui/qt/pixmaps/toolbar/volume-high.svg \
	gui/qt/pixmaps/toolbar/volume-low.svg \
	gui/qt/pixmaps/toolbar/volume-medium.svg \
	gui/qt/pixmaps/toolbar/volume-muted.svg \
	gui/qt/pixmaps/toolbar/volume-slider-inside.svg \
	gui/qt/pixmaps/toolbar/volume-slider-outside.svg \
	gui/qt/pixmaps/types/capture-card_16px.svg \
	gui/qt/pixmaps/types/disc_16px.svg \
	gui/qt/pixmaps/types/file-asym_16px.svg \
	gui/qt/pixmaps/types/file-wide_16px.svg \
	gui/qt/pixmaps/types/file_black.svg \
	gui/qt/pixmaps/types/folder-blue_16px.svg \
	gui/qt/pixmaps/types/folder-grey_16px.svg \
	gui/qt/pixmaps/types/harddisk_16px.svg \
	gui/qt/pixmaps/types/network_16px.svg \
	gui/qt/pixmaps/types/tape_16px.svg \
	gui/qt/pixmaps/types/type_directory.svg \
	gui/qt/pixmaps/types/type_directory_black.svg \
	gui/qt/pixmaps/types/type_file.svg \
	gui/qt/pixmaps/types/type_stream.svg \
	gui/qt/pixmaps/types/type_node.svg \
	gui/qt/pixmaps/types/type_playlist.svg \
	gui/qt/pixmaps/types/type_unknown.xpm \
	gui/qt/pixmaps/util/wait1.svg \
	gui/qt/pixmaps/util/wait2.svg \
	gui/qt/pixmaps/util/wait3.svg \
	gui/qt/pixmaps/util/wait4.svg \
	gui/qt/pixmaps/win7/win7thumbnail_pause.svg \
	gui/qt/pixmaps/win7/win7thumbnail_prev.svg \
	gui/qt/pixmaps/win7/win7thumbnail_next.svg \
	gui/qt/pixmaps/win7/win7thumbnail_play.svg \
	gui/qt/pixmaps/update.svg \
	gui/qt/pixmaps/valid.svg \
	gui/qt/pixmaps/search_clear.svg \
	gui/qt/pixmaps/lock.svg \
	gui/qt/pixmaps/close.svg \
	gui/qt/pixmaps/rename.svg \
	gui/qt/pixmaps/del.svg \
	gui/qt/pixmaps/ellipsis.svg \
	gui/qt/pixmaps/topbar/grid.svg \
	gui/qt/pixmaps/topbar/list.svg

#QML and JS resources
libqt_plugin_la_QML = \
	gui/qt/qml/MainInterface.qml \
	gui/qt/qml/BannerSources.qml \
	gui/qt/qml/about/About.qml \
	gui/qt/qml/player/Player.qml \
	gui/qt/qml/player/TrackInfo.qml \
	gui/qt/qml/player/TrackSelector.qml \
	gui/qt/qml/player/ControlBar.qml \
	gui/qt/qml/player/ControlButtons.qml \
	gui/qt/qml/player/PlayerButtonsLayout.qml \
	gui/qt/qml/player/PlayerMenu.qml \
	gui/qt/qml/player/PlayerMenuItem.qml \
	gui/qt/qml/player/VolumeWidget.qml \
	gui/qt/qml/player/ModalControlBar.qml \
	gui/qt/qml/player/SliderBar.qml \
	gui/qt/qml/player/TeletextWidget.qml \
	gui/qt/qml/player/MiniPlayer.qml \
	gui/qt/qml/player/TopBar.qml \
	gui/qt/qml/dialogs/Dialogs.qml \
	gui/qt/qml/dialogs/ModalDialog.qml \
	gui/qt/qml/dialogs/EditorDummyButton.qml \
	gui/qt/qml/dialogs/EditorDNDDelegate.qml \
	gui/qt/qml/dialogs/EditorDNDView.qml\
	gui/qt/qml/dialogs/EditorTabButton.qml \
	gui/qt/qml/dialogs/ToolbarEditorButtonList.qml \
	gui/qt/qml/dialogs/ToolbarEditor.qml \
	gui/qt/qml/utils/DNDLabel.qml \
	gui/qt/qml/utils/ToolTipArea.qml \
	gui/qt/qml/utils/DrawerExt.qml \
	gui/qt/qml/utils/GridItem.qml \
	gui/qt/qml/utils/ContextButton.qml \
	gui/qt/qml/utils/IconToolButton.qml \
	gui/qt/qml/utils/ImageToolButton.qml \
	gui/qt/qml/utils/TextToolButton.qml \
	gui/qt/qml/utils/MenuExt.qml \
	gui/qt/qml/utils/MenuItemExt.qml \
	gui/qt/qml/utils/ListItem.qml \
	gui/qt/qml/utils/MultiCoverPreview.qml \
	gui/qt/qml/utils/ExpandGridView.qml \
	gui/qt/qml/utils/NavigableFocusScope.qml \
	gui/qt/qml/utils/NavigableCol.qml \
	gui/qt/qml/utils/NavigableRow.qml \
	gui/qt/qml/utils/KeyNavigableGridView.qml \
	gui/qt/qml/utils/KeyNavigableListView.qml \
	gui/qt/qml/utils/KeyNavigableTableView.qml \
	gui/qt/qml/utils/SelectableDelegateModel.qml \
	gui/qt/qml/utils/ComboBoxExt.qml \
	gui/qt/qml/utils/SpinBoxExt.qml \
	gui/qt/qml/utils/StackViewExt.qml \
	gui/qt/qml/utils/ScanProgressBar.qml \
	gui/qt/qml/utils/TabButtonExt.qml \
	gui/qt/qml/utils/LabelSeparator.qml \
	gui/qt/qml/utils/RoundButton.qml \
	gui/qt/qml/utils/RoundImage.qml \
	gui/qt/qml/utils/VideoQualityLabel.qml \
	gui/qt/qml/utils/VideoProgressBar.qml \
        gui/qt/qml/utils/SearchBox.qml \
        gui/qt/qml/utils/SortControl.qml \
	gui/qt/qml/menus/CheckableModelSubMenu.qml \
	gui/qt/qml/menus/AudioMenu.qml \
	gui/qt/qml/menus/HelpMenu.qml \
	gui/qt/qml/menus/MainDropdownMenu.qml \
	gui/qt/qml/menus/MainMenubar.qml \
	gui/qt/qml/menus/MediaMenu.qml \
	gui/qt/qml/menus/PlaybackMenu.qml \
	gui/qt/qml/menus/PopupMenu.qml \
	gui/qt/qml/menus/SubtitleMenu.qml \
	gui/qt/qml/menus/ToolsMenu.qml \
	gui/qt/qml/menus/ViewMenu.qml \
	gui/qt/qml/menus/VideoMenu.qml \
	gui/qt/qml/mediacenter/ArtistTopBanner.qml \
	gui/qt/qml/mediacenter/AudioGridItem.qml \
	gui/qt/qml/mediacenter/MCMainDisplay.qml \
	gui/qt/qml/mediacenter/MCMusicDisplay.qml \
	gui/qt/qml/mediacenter/MCVideoDisplay.qml \
	gui/qt/qml/mediacenter/MCVideoListDisplay.qml \
	gui/qt/qml/mediacenter/MCNetworkDisplay.qml \
	gui/qt/qml/mediacenter/MCNetworkBrowseDisplay.qml \
	gui/qt/qml/mediacenter/MCNetworkHomeDisplay.qml \
	gui/qt/qml/mediacenter/MCNetworksSectionSelectableDM.qml \
	gui/qt/qml/mediacenter/MusicAlbumsDisplay.qml \
	gui/qt/qml/mediacenter/MusicAlbumsGridExpandDelegate.qml \
	gui/qt/qml/mediacenter/MusicArtistsDisplay.qml \
	gui/qt/qml/mediacenter/MusicGenresDisplay.qml \
	gui/qt/qml/mediacenter/MusicTracksDisplay.qml \
	gui/qt/qml/mediacenter/MusicTrackListDisplay.qml \
	gui/qt/qml/mediacenter/NetworkGridItem.qml \
	gui/qt/qml/mediacenter/NetworkListItem.qml \
	gui/qt/qml/mediacenter/VideoExpandableGrid.qml \
	gui/qt/qml/mediacenter/VideoGridItem.qml \
	gui/qt/qml/playlist/PlaylistListView.qml \
	gui/qt/qml/playlist/PlaylistMainView.qml \
	gui/qt/qml/playlist/PLItem.qml \
	gui/qt/qml/playlist/PLItemFooter.qml \
	gui/qt/qml/playlist/PlaylistMenu.qml \
	gui/qt/qml/style/qmldir \
	gui/qt/qml/style/VLCIcons.qml \
	gui/qt/qml/style/VLCStyle.qml \
	gui/qt/qml/style/VLCColors.qml

EXTRA_DIST += gui/qt/vlc.qrc $(libqt_plugin_la_RES)

nodist_libqt_plugin_la_SOURCES += gui/qt/resources.cpp

if ENABLE_VLM
nodist_libqt_plugin_la_SOURCES += gui/qt/dialogs/vlm.moc.cpp
endif

if HAVE_QMLCACHE

nodist_libqt_plugin_la_SOURCES += gui/qt/qmlcache_loader.cpp
libqt_plugin_la_SOURCES += $(libqt_plugin_la_QML)

.qml.cpp:
	$(AM_V_GEN)$(QMLCACHE) --resource=$(srcdir)/gui/qt/vlc.qrc -o $@ $<

qml_cache.qrc: gui/qt/vlc.qrc
	$(AM_V_GEN)$(QMLCACHE) --filter-resource-file -o $@ $<

gui/qt/resources.cpp: qml_cache.qrc $(libqt_plugin_la_RES)
	$(AM_V_GEN)$(RCC) --name qml_cache -o $@ $<

#output name matters here
gui/qt/qmlcache_loader.cpp: gui/qt/vlc.qrc qml_cache.qrc $(libqt_plugin_la_QML)
	$(AM_V_GEN)$(QMLCACHE) --resource-file-mapping=$<=qml_cache.qrc $< -o $@

else

EXTRA_DIST += $(libqt_plugin_la_QML)

gui/qt/resources.cpp: gui/qt/vlc.qrc $(libqt_plugin_la_RES) $(libqt_plugin_la_QML)
	$(AM_V_GEN)$(RCC) --name vlc -o $@ $<

endif

vlc_qt_check_SOURCES = gui/qt/vlc-qt-check.cpp
vlc_qt_check_CXXFLAGS = $(AM_CXXFLAGS) $(QT_CFLAGS) -fPIC
vlc_qt_check_LDADD = $(QT_LIBS)

if ENABLE_QT
gui_LTLIBRARIES += libqt_plugin.la
BUILT_SOURCES += $(nodist_libqt_plugin_la_SOURCES)
if !HAVE_WIN32
if !HAVE_OS2
pkglibexec_PROGRAMS += vlc-qt-check
endif
endif
endif
