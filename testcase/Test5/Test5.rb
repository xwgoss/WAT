#encoding:gbk
require "../../lib/TestClass.rb"
require 'win32ole'

  
class Test5 < TestKlass
	def setUp
		getWebApplication
	end
	
  
  def test_a_1
	 
	         @b.goto("http://www.coo8.com/product/242838.html")
	 
	 @b.wait
	 @b.link(:id,"shopping").click
	 @b.link(:class,"btnClrCart").click_no_wait
	 sleep(2.3)
	 @autoit = WIN32OLE.new("AutoItX3.Control")
	 p "11111"
            result1 = @autoit.WinWaitActive("������ҳ����Ϣ",'',5)
            result2 = @autoit.ControlClick("������ҳ����Ϣ","ȷ��","Button1")
	    @autoit.Send "{Enter}"
  end
	
end  
