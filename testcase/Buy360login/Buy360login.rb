require "../../lib/TestClass.rb"
  
class Buy360login < TestKlass
	
  def setUp
    getWebApplication
  end 
  
  def test_1_NoUsernameNoPassword
    @b.goto("https://passport.360buy.com/new/login.aspx?ReturnUrl=http%3A%2F%2Fwww.360buy.com%2F")
    @b.wait 
    AutoTest("username").set TestData("Username")
    AutoTest("password").set TestData("Password")
    AutoTest("button").click
    #@b.wait 
=begin
   #方法1：判断此页面中是否含有预期结果
    p ExpectData("loginStatus")
    assert_true(@b.contains_text(ExpectData("loginStatus"))!=nil)
=end
    #方法2：判断期望值是否与实际结果相等
    actual=AutoTest("label").text
    p actual
    p ExpectData("loginStatus")
    assert_string(actual,ExpectData("loginStatus"))
    

  end
	
end  
