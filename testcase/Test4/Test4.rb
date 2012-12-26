require "../../lib/TestClass.rb"
  
class Test4 < TestKlass
  
 
  def setUp
    getWebApplication
  end 
  
  def test_a_1
    @b.goto("http://baidu.com")
    @b.wait    
    AutoTest("input").set TestData("inputValue22")
    AutoTest("button").click
   p  ExpectData("hello22") 
  end
  
  def tearDown
    @b.close
  end
	
end  
