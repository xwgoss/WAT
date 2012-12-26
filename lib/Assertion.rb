module Assertion
  def assert_string(expect , actual)
    assert_class(expect , actual , String)
    if expect == actual
      @info[:inti].errorCollection({:errMes=>"Assert string pass:#{expect}" , :flag=>false,:status=>"Pass"}) 
    else      
      @info[:inti].errorCollection({:errMes=>"Assert string error, expect is #{expect}, but actual is #{actual}" , :flag=>false})      
      raise
    end
  end
  
  def assert_array(expect , actual)
    assert_class(expect , actual , Array)
    unless expect == actual
      @info[:inti].errorCollection({:errMes=>"Assert array error, expect is #{expect.join(",")}, but actual is #{actual.join(",")}" , :flag=>false})
      raise
    else
      @info[:inti].errorCollection({:errMes=>"Assert array pass:#{expect.join(",")}" , :flag=>false,:status=>"Pass"})      
    end    
  end
  
  def assert_hash(expect , actual)
    assert_class(expect , actual , Hash)
    unless expect == actual
      @info[:inti].errorCollection({:errMes=>"Assert hash error, expect is #{expect.to_a.join(",")}, but actual is #{actual.to_a.join(",")}" , :flag=>false})
      raise
    else
      @info[:inti].errorCollection({:errMes=>"Assert hash pass:#{expect.to_a.join(",")}" , :flag=>false,:status=>"Pass"})
    end    
  end
  
  def assert_true(actual)
    assert_class(true , actual , TrueClass)
    unless true == actual
      @info[:inti].errorCollection({:errMes=>"Assert true error, actual is #{actual.to_s}" , :flag=>false})
      raise
    else
      @info[:inti].errorCollection({:errMes=>"Assert true pass:#{actual.to_s}" , :flag=>false,:status=>"Pass"})
    end  
  end
  
  def assert_false(actual)
    assert_class(false , actual , FalseClass)
    unless false == actual
      @info[:inti].errorCollection({:errMes=>"Assert false error, actual is #{actual}" , :flag=>false})
      raise
    else
      @info[:inti].errorCollection({:errMes=>"Assert false pass:#{actual.to_s}" , :flag=>false,:status=>"Pass"})
    end  
  end
  
  def assert_class(expect,actual,klass)
    temp = [expect,actual]
    temp.each{|k|
      unless k.class == klass
        @info[:inti].errorCollection({:errMes=>"#{k} class is #{k.class} , must be #{klass}" , :flag=>false})
        raise
      end
    }
  end
end