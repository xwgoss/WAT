#encoding=gbk
require "../../lib/TestClass.rb"
require 'iconv'
class Login_test < TestKlass
  def setUp
	    getWebApplication  
  end
  
  
  def test_Login_test
	  @b.goto("http://mail.126.com/")
	    @b.wait
	    AutoTest("input_name").set TestData("name")
	    AutoTest("input_pwd").set TestData("pwd")
	    AutoTest("button").click
	    str=AutoTest("span").text
	    p str
	    p ExpectData("hello")
	    assert_string(str,ExpectData("hello"))
	     
    #AutoTest("")
    #LoadObject("")
    #TestData("")
    #ExpectData("")
    #LoadTestData("")
    #LoadExpectData("")
    #TransferData("")
    #ConfigData("")
    #assert_string("","")
    #assert_array("","")
    #assert_hash("","")
    #assert_true(true)
    #assert_false(false)    
  end
	def teardown
	@b.close
	end
	
end  
