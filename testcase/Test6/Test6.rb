#encoding=gbk
require "../../lib/TestClass.rb"
require 'win32ole'
require 'watir/windowhelper'
  
class Test6 < TestKlass
  def setUp
	  getWebApplication
  end
  
  def test_Login
         @b.goto("http://www.coo8.com/product/242838.html")
	 
	 @b.wait
	 @b.link(:id,"shopping").click
	 @b.link(:class,"btnClrCart").click
	 @autoit = WIN32OLE.new("AutoItX3.Control")
            result1 = @autoit.WinWaitActive("来自网页的消息",'',5)
            result2 = @autoit.ControlClick("来自网页的消息","确定","Button1")
	    @autoit.Send "{Enter}"
  end
def tearDown
	@b.close
end

end 