#encoding=gbk
require "../../lib/TestClass.rb"
  
class Login < TestKlass
     

    def setUp
	    getWebApplication
	p "你好"
	   
    end
    
    def test_01
	    p "test_01"
	    @b.goto("weibo.com")
	    @b.wait
	    AutoTest("button").click
	    p @b.div(:class,"error_text").span(:index,1).text
    
    end
        
    def tearDown
	   
             @b.close
    end
    
	
end
