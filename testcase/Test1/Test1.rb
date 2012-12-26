require "../../lib/TestClass.rb"

class Test1 < TestKlass
	
  def setUp
    #getWebApplication
  end
  
  def tearDown
    #@b.close
  end
	def test_a_1  
    p @info[:object]
    LoadObject("Test1.0.yaml")  
    p @info[:object]
    LoadTestData("Test1.1.yaml")
    #LoadTestData("Test1.0.xls","Test1_d")  
    LoadExpectData("Test1.1.yaml")
    #puts AutoTest("testframe1")     
    puts ExpectData("hello")
    assert_string("3","3") 
    puts ExpectData("inputValue")
    puts TestData("inputValue")    
	end
  
  def ggtest_a_1
    @b.goto("http://baidu.com")
    @b.wait    
    AutoTest("input").set TestData("inputValue")
    AutoTest("button").click
  end
	
	def test_a_2   
    p @info[:object]
    puts TestData("inputValue")
    assert_string("3","3")
    assert_string("3","3")
    if TestData("inputValue") == "234"
      assert_string("4","3") 
    end
		puts ConfigData("TimeOutSetting")
	end
	
end

