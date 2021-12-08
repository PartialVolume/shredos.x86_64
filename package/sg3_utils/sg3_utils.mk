################################################################################
#
# sg3_utils
#
################################################################################

SG3_UTILS_VERSION = 1.45
SG3_UTILS_SOURCE = sg3_utils-$(SG3_UTILS_VERSION).tar.xz
SG3_UTILS_SITE = http://sg.danny.cz/sg/p
SG3_UTILS_LICENSE = BSD-2-Clause (library)
# Some utils progs are GPL-2.0+ licensed while others are BSD-3-Clause
ifeq ($(BR2_PACKAGE_SG3_UTILS_PROGS),y)
SG3_UTILS_LICENSE += , GPL-2.0+ (programs), BSD-2-Clause (programs)
endif
SG3_UTILS_LICENSE_FILES = COPYING BSD_LICENSE

# Patching configure.ac/Makefile.am
SG3_UTILS_AUTORECONF = YES

# install the libsgutils2 library
SG3_UTILS_INSTALL_STAGING = YES

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
SG3_UTILS_CONF_ENV += LIBS="-latomic"
endif

ifeq ($(BR2_PACKAGE_SG3_UTILS_PROGS),)
define SG3_UTILS_REMOVE_PROGS
	for prog in \
		compare_and_write copy_results dd decode_sense \
		emc_trespass format get_config \
		get_lba_status ident inq logs luns map26 \
		map sgm_dd modes opcodes sgp_dd persist prevent \
		raw rbuf rdac read readcap read_block_limits \
		read_attr read_buffer read_long reassign referrals \
		rep_zones requests reset reset_wp rmsn rtpg safte sanitize \
		sat_identify sat_phy_event sat_read_gplog sat_set_features \
		scan senddiag ses ses_microcode start stpg sync test_rwbuf \
		timestamp turs unmap verify vpd write_buffer write_long \
		write_same write_verify wr_mode xcopy zone; do \
		$(RM) $(TARGET_DIR)/usr/bin/sg_$${prog} ; \
	done
	for prog in \
		logging_level mandat readcap ready satl start stop \
		temperature; do \
		$(RM) $(TARGET_DIR)/usr/bin/scsi_$${prog} ; \
	done
	for prog in \
		sginfo sgm_dd sgp_dd; do \
		$(RM) $(TARGET_DIR)/usr/bin/$${prog}; \
	done
endef

SG3_UTILS_POST_INSTALL_TARGET_HOOKS += SG3_UTILS_REMOVE_PROGS
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
