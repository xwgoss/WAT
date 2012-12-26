#encoding=gbk
#涵盖的case：10、11、12、13 
require "../../lib/TestClass.rb"
require "../../util/Util"
include BasicTestUtil
  
class Auto_test3 < TestKlass
  def setUp
          getWebApplication
	  clear_cart
  end
  
  def test_Auto_test1
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
  
  def test_Auto_test4
  
  end
  
  
  def tearDown
	    clear_cart
           @b.close
  end
  
end  
