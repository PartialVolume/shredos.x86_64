from tests.package.test_lua import TestLuaBase


class TestLuaLunix(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUA_LUNIX=y
        """

    def test_run(self):
        self.login()
        self.module_test("unix")


class TestLuajitLunix(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUA_LUNIX=y
        """

    def test_run(self):
        self.login()
        self.module_test("unix")
