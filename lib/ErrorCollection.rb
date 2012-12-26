class ErrorCollection
  
  def initialize(log,reportFilePath,reportHtmlFilePath)
    @errorCollection = Hash.new 
    @log = log  
    @reportFilePath = reportFilePath
    @reportHtmlFilePath = reportHtmlFilePath
  end
  
  def getErrorCollection
    @errorCollection
  end
  
  def errorCollection(hash)    
    detailInfo = ""
    detailInfoLog = ""
    spaceLen = @log.logTime.length
    if hash[:info].class == Array      
      detailInfoLog = hash[:info].join("\n" + " "*(spaceLen.to_i+3))
      detailInfo = hash[:info].join("\n")
    else
      detailInfoLog = hash[:info]
      detailInfo = hash[:info]
    end 
    space="\n" + " "*(spaceLen.to_i+3)    
    (hash[:errMes]=="")?():((detailInfoLog=="")?(detailInfoLog=hash[:errMes]):(detailInfoLog=hash[:errMes]+space+detailInfoLog))
    (hash[:errMes]=="")?((detailInfo=="")?():(hash[:errMes]=detailInfo)):((detailInfo=="")?():(hash[:errMes]=hash[:errMes]+"\n"+detailInfo))
    flag = hash[:flag]
    hash.delete(:info)
    hash.delete(:flag)    
    @log.writeLog(detailInfoLog)       
    @errorCollection[@errorCollection.length+1] =  hash         
    (Report.new.putsReportFile(@reportHtmlFilePath,@reportFilePath,@errorCollection);exit) if flag          
  end 
  
  def getTestCaseHash(s,e)
    tempHash = Hash.new    
    for i in s+1..e
	   
      tempHash[tempHash.length+1]=@errorCollection[i]
      @errorCollection.delete(i)
    end
    return tempHash
  end
  
  def processHash(hash,kee)    
	
    hash.each{|k,v|       
      hash.delete(k)      
      hash.each{|ke,va|      
        if va[:project]==v[:project] and va[:testclass]== v[:testclass] and va[:testcase] == v[:testcase]          
          v[:errMes]=v[:errMes] + "\n" + va[:errMes]
          v[:status]=(statusLevel(va[:status])>statusLevel(v[:status]))?(va[:status]):(v[:status])
          hash.delete(ke)          
        end
      }      
      @errorCollection[kee.to_s] = v      
      p @errorCollection
    }    
  end
  
  def statusLevel(status)
    case status
    when "Pass"
      return 0
    when "N/A"
      return 1
    when "Fail"
      return 2
    end
  end   
  
end