
module GetObject
  def AutoTest(key)
    if @info[:object].key?(key)
	    
      @info[:log].writeLog("Get object[#{key}:#{@info[:object].fetch(key).fetch("element")}]")
      return eval("@b."+@info[:object][key]["element"])
    else
      @info[:inti].errorCollection({:errMes=>"Object: #{key} is not exist" , :flag=>false})      
    end
  end
  
   def LoadObject(path)
    begin
      root = Pathname.new(File.join(File.dirname(__FILE__),"/../")).realpath
      ui = UIObject.new(File.join(root,"testcase/#{@info[:basicInfo][:project]}/",path))
      lo = ui.combinElement(ui.integrateElement(ui.getYamlHash))
      lo.each{|k,v|
        @info[:object][k]=v
      }  
    rescue      
      @info[:inti].errorCollection({:errMes=>"Load Object #{File.join(root,"testcase/#{@info[:basicInfo][:project]}/",path)} failed" , :flag=>false})
      raise
    end
  end
end