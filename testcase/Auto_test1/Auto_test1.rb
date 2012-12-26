#encoding=gbk
#涵盖自动化case2、3、4
require "../../lib/TestClass.rb"
require "../../util/Util"
include BasicTestUtil
  
class Auto_test1 < TestKlass

def setUp
 getWebApplication
end
  
  def test_Auto_test1
      
	  #coo8_cec_login(TestData("name"),TestData("pwd"))
	 
	  shopping(TestData("proid1"),TestData("space"))
          shopping(TestData("proid2"),TestData("space"))
	
	  AutoTest("before_order").click
	  info=Array.new
	  info<<info_pay
	  info<<AutoTest("yunfei").text
	  info_expect=Array.new
	  info_expect<<ExpectData("pay")
	  info_expect<<ExpectData("yunfei")
	  assert_array(info_expect,info)
	 
end
	  
   def test_Auto_test2
	   
	   
	  shopping(TestData("proid1"),TestData("space"))
          shopping(TestData("proid2"),TestData("space"))
	
	  AutoTest("before_order").click
	  info=Array.new
	  info<<info_pay
	  info<<AutoTest("yunfei").text
	  info_expect=Array.new
	  info_expect<<ExpectData("pay")
	  info_expect<<ExpectData("yunfei")
	  assert_array(info_expect,info)
	  

   end
   
   def test_Auto_test3
	    
	  shopping(TestData("proid1"),TestData("space"))
	  AutoTest("before_order").click
	  info=Array.new
	  info<<info_pay
	  info<<AutoTest("yunfei").text
	  info_expect=Array.new
	  info_expect<<ExpectData("pay")
	  info_expect<<ExpectData("yunfei")
	  assert_array(info_expect,info)
   end
   
   
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
def tearDown
	  clear_cart
 @b.close
end

end  
