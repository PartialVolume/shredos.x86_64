import os

import infra.basetest


class TestOpensshBase(infra.basetest.BRTest):
    passwd = "testpwd"
    opensshconfig = \
        """
        BR2_TARGET_GENERIC_ROOT_PASSWD="{}"
        BR2_PACKAGE_OPENSSH=y
        BR2_PACKAGE_SSHPASS=y
        BR2_ROOTFS_POST_BUILD_SCRIPT="{}"
        # BR2_TARGET_ROOTFS_TAR is not set
        """.format(
            passwd,
            infra.filepath("tests/package/test_openssh/post-build.sh"))

    def openssh_test(self):
        img = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", img,
                                    "-net", "none"])
        self.emulator.login(self.passwd)

        cmd = "netstat -ltn 2>/dev/null | grep 0.0.0.0:22"
        self.assertRunOk(cmd)

        cmd = "sshpass -p {} ssh -oStrictHostKeyChecking=no localhost /bin/true".format(self.passwd)
        self.assertRunOk(cmd)


class TestOpenSshuClibc(TestOpensshBase):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        TestOpensshBase.opensshconfig + \
        """
        BR2_TARGET_ROOTFS_CPIO=y
        """

    def test_run(self):
        self.openssh_test()


class TestOpenSshGlibc(TestOpensshBase):
    config = \
        TestOpensshBase.opensshconfig + \
        """
        BR2_arm=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TOOLCHAIN_EXTERNAL_BOOTLIN=y
        BR2_PACKAGE_RNG_TOOLS=y
        BR2_TARGET_ROOTFS_CPIO=y
        """

    def test_run(self):
        self.openssh_test()
