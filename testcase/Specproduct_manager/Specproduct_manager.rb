#encoding=gbk
require "../../lib/TestClass.rb"
  
class Specproduct_manager < TestKlass
  def setUp
	  getWebApplication
end
  
  def test_Login
         @b.goto("manage.coo8.com")
	 AutoTest("login_name").set TestData("name")
	 AutoTest("login_pwd").set TestData("pwd")
	 AutoTest("login_button").click
	 p AutoTest("logistics_link").exist?
  end
def tearDown
	@b.close
end

end 