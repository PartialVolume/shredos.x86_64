################################################################################
#
# gst1-plugins-good
#
################################################################################

GST1_PLUGINS_GOOD_VERSION = 1.18.5
GST1_PLUGINS_GOOD_SOURCE = gst-plugins-good-$(GST1_PLUGINS_GOOD_VERSION).tar.xz
GST1_PLUGINS_GOOD_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-good
GST1_PLUGINS_GOOD_LICENSE_FILES = COPYING
GST1_PLUGINS_GOOD_LICENSE = LGPL-2.1+

GST1_PLUGINS_GOOD_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)

GST1_PLUGINS_GOOD_CONF_OPTS = \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dasm=disabled \
	-Ddirectsound=disabled \
	-Dwaveform=disabled \
	-Drpicamsrc=disabled \
	-Dosxaudio=disabled \
	-Dosxvideo=disabled \
	-Daalib=disabled \
	-Dlibcaca=disabled \
	-Ddoc=disabled

# Options which require currently unpackaged libraries
GST1_PLUGINS_GOOD_CONF_OPTS += \
	-Ddv=disabled \
	-Ddv1394=disabled

GST1_PLUGINS_GOOD_DEPENDENCIES = \
	gstreamer1 \
	gst1-plugins-base \
	$(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_JACK),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Djack=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += jack2
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Djack=disabled
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dv4l2-libv4l2=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += libv4l
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dv4l2-libv4l2=disabled
endif

ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dorc=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += orc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ALPHA),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dalpha=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dalpha=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_APETAG),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dapetag=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dapetag=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUDIOFX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Daudiofx=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Daudiofx=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUDIOPARSERS),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Daudioparsers=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Daudioparsers=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUPARSE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dauparse=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dauparse=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUTODETECT),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dautodetect=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dautodetect=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AVI),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Davi=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Davi=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_CUTTER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dcutter=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dcutter=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DEBUGUTILS),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Ddebugutils=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Ddebugutils=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DEINTERLACE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Ddeinterlace=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Ddeinterlace=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DTMF),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Ddtmf=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Ddtmf=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_EFFECTV),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Deffectv=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Deffectv=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_EQUALIZER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dequalizer=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dequalizer=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLV),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dflv=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dflv=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dflx=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dflx=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GOOM),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dgoom=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dgoom=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GOOM2K1),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dgoom2k1=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dgoom2k1=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ICYDEMUX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dicydemux=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dicydemux=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ID3DEMUX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Did3demux=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Did3demux=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_IMAGEFREEZE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dimagefreeze=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dimagefreeze=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_INTERLEAVE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dinterleave=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dinterleave=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ISOMP4),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Disomp4=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Disomp4=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_LAME),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dlame=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += lame
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dlame=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MPG123),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmpg123=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += mpg123
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmpg123=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_LAW),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dlaw=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dlaw=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_LEVEL),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dlevel=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dlevel=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MATROSKA),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmatroska=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmatroska=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MONOSCOPE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmonoscope=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmonoscope=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MULTIFILE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmultifile=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmultifile=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MULTIPART),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmultipart=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dmultipart=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_REPLAYGAIN),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dreplaygain=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dreplaygain=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTP),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Drtp=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Drtp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTPMANAGER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Drtpmanager=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Drtpmanager=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTSP),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Drtsp=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Drtsp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SHAPEWIPE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dshapewipe=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dshapewipe=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SMPTE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dsmpte=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dsmpte=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SPECTRUM),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dspectrum=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dspectrum=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_UDP),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dudp=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dudp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOBOX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvideobox=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvideobox=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOCROP),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvideocrop=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvideocrop=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOFILTER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvideofilter=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvideofilter=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOMIXER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvideomixer=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvideomixer=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVENC),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dwavenc=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dwavenc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVPARSE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dwavparse=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dwavparse=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_Y4M),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dy4m=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dy4m=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_OSS),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Doss=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Doss=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_OSS4),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Doss4=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Doss4=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_QMLGL),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dqt5=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += qt5declarative
ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
GST1_PLUGINS_GOOD_DEPENDENCIES += qt5x11extras
endif
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dqt5=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SHOUT2),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dshout2=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += libshout
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dshout2=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_V4L2),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dv4l2=enabled
# Enable use of gudev if available, for device probing and monitoring.
ifeq ($(BR2_PACKAGE_LIBGUDEV),y)
GST1_PLUGINS_GOOD_DEPENDENCIES += libgudev
GST1_PLUGINS_GOOD_CONF_OPTS += -Dv4l2-gudev=enabled
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dv4l2-gudev=disabled
endif
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dv4l2=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_V4L2_PROBE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dv4l2-probe=true
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dv4l2-probe=false
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
GST1_PLUGINS_GOOD_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXv
GST1_PLUGINS_GOOD_CONF_OPTS += -Dximagesrc=enabled
ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
GST1_PLUGINS_GOOD_DEPENDENCIES += xlib_libXfixes
GST1_PLUGINS_GOOD_CONF_OPTS += -Dximagesrc-xfixes=enabled
endif
ifeq ($(BR2_PACKAGE_XLIB_LIBXDAMAGE),y)
GST1_PLUGINS_GOOD_DEPENDENCIES += xlib_libXdamage
GST1_PLUGINS_GOOD_CONF_OPTS += -Dximagesrc-xdamage=enabled
endif
else
GST1_PLUGINS_GOOD_CONF_OPTS += \
	-Dximagesrc=disabled \
	-Dximagesrc-xfixes=disabled \
	-Dximagesrc-xdamage=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_CAIRO),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dcairo=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += cairo
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dcairo=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLAC),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dflac=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += flac
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dflac=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GDKPIXBUF),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dgdk-pixbuf=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += gdk-pixbuf
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dgdk-pixbuf=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_JPEG),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Djpeg=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += jpeg
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Djpeg=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PNG),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dpng=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += libpng
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dpng=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_PULSE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dpulse=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += pulseaudio
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dpulse=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SOUPHTTPSRC),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dsoup=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += libsoup
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dsoup=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SPEEX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dspeex=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += speex
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dspeex=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_TAGLIB),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dtaglib=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += taglib
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dtaglib=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_TWOLAME),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dtwolame=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += twolame
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dtwolame=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VPX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvpx=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += libvpx
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dvpx=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVPACK),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dwavpack=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += wavpack
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dwavpack=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_ZLIB),y)
GST1_PLUGINS_GOOD_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_BZ2),y)
GST1_PLUGINS_GOOD_CONF_OPTS += -Dbz2=enabled
GST1_PLUGINS_GOOD_DEPENDENCIES += bzip2
else
GST1_PLUGINS_GOOD_CONF_OPTS += -Dbz2=disabled
endif

$(eval $(meson-package))
