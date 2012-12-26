#encoding=gbk

require 'pathname'
require "UIObject.rb"
require "Log.rb"
require "HandleExcelFile.rb"
require "ErrorCollection.rb"
require "ObjectData.rb"
require "TestData.rb"
require "Assertion.rb"
require "Report.rb"
require "WebApplication.rb"
require "Mail.rb"

class InitialClass
  
  def initialize
    @basicInfo = getNeedKey("basicinfo")
    getFilePath
    @log = Log.new(@logFile)    
    @error = ErrorCollection.new(@log,@reportFilePath,@reportHtmlFilePath)
    
  end  
  
  def getLogObject
    @log
  end
  
  def getError
    @error
  end
  
  def getDirPath(folderName)
    root = Pathname.new(File.join(File.dirname(__FILE__),"/../")).realpath    
    case folderName          
    when "lib"
      File.join(root , "/lib/")      
    when "log"
      File.join(root , "/log/")      
    when "report"
      File.join(root , "/report/")      
    when "testcase"
      File.join(root , "/testcase/")  
    when "config"
      File.join(root , "/config/")      
    else
      root
    end           
  end
    
  def getFilePath    
    @logFile = File.join(getDirPath("log"),"result.Log")
    @objectFile = File.join(getDirPath("testcase"),"#{@basicInfo[:project]}/","#{@basicInfo[:project]}.yaml")
    @dataPath = File.join(getDirPath("testcase"),"#{@basicInfo[:project]}/","#{@basicInfo[:project]}.xls")
    @transferdataPath = File.join(getDirPath("lib"),"transfer.yaml")
    @configdataPath = File.join(getDirPath("config"),"conf.yaml")
    @loadConfigDataPath = File.join(getDirPath("testcase"),"#{@basicInfo[:project]}/","conf.yaml")
    @reportFilePath = File.join(getDirPath("report"),"#{@basicInfo[:project]}/","#{@basicInfo[:project]}.yaml")
    @reportHtmlFilePath = File.join(getDirPath("report"),"#{@basicInfo[:project]}/","#{@basicInfo[:project]}.html")
    @mailInfoPath=File.join(getDirPath("config"),"mail_config.yaml")
  end 
  
  def getNeedKey(key)
    case key
    when "data"
      return ["TestCase Order","private","smoking","ExpectDataLink"]
    when "config"
      return {"RunTimeModule"=>["private","smoking"],"TimeOutSetting"=>Fixnum,"ReRun"=>String,"ReRunTimes"=>Fixnum}
    when "expect"
      return ["ExpectDataLink"]
    when "basicinfo"
      project_name = File.basename($0)
      return {:file=>$0,:project=>project_name[/.*(?=\.rb)/],:testclass=>"",:testcase=>""}       
    when "status"
      return ["Pass","N/A","Fail"]
    end       
  end
  
  def getBasicInfo
    @basicInfo    
  end  
  
  def setBasicInfo(h)
    h.each{|k,v|
      @basicInfo[k] = v
    }        
    p @basicInfo
  end
  
  def getErrorInfo
    @errorValue = {:project=>@basicInfo[:project],
                   :testclass=>@basicInfo[:testclass],
                   :testcase=>@basicInfo[:testcase],
                   :status=>getNeedKey("status")[2],
                   :errMes=>"",
                   :info=>"",
                   :flag=>true
                  }    
  end
  
  def setErrorInfo(h)
    h.each{|k,v|
      @errorValue[k] = v
    } 
  end
  
  def errorCollection(h)
    getErrorInfo
    setErrorInfo(h)    
    @error.errorCollection(@errorValue)    
  end
      
  def getConfigData
    begin
      cData = YAML.load(File.open(@configdataPath))      
      cData = Hash.new  if cData.class != Hash 
      lCData = loadConfigData
      (lCData==nil)?():(lCData.each{|k,v| cData[k]=v})      
      arr = getNeedKey("config")       
      arr.keys.each{|k|
        if cData.key?(k)    
          case arr[k].class.to_s
          when Array.to_s      
            unless arr[k].include?(cData[k])
              errorCollection({:errMes=>"Config data #{k}=>#{cData[k]} error from #{@configdataPath}"})              
            end
          when Class.to_s      
            unless arr[k] == cData[k].class            
              errorCollection({:errMes=>"Config data #{k}=>#{cData[k]} error from #{@configdataPath}"})
            else              
              if arr[k]==Fixnum and cData[k] < 0
                errorCollection({:errMes=>"Config data #{k}=>#{cData[k]} error from #{@configdataPath}"})
              end
            end
          end           
        else
          errorCollection({:errMes=>"Missed Config data key #{k} from #{@configdataPath}"})
        end        
      }      
      @log.writeLog("Get all config data from #{@configdataPath}")  
      return cData
    rescue
      errorCollection({:errMes=>"Get config data Failed from #{@configdataPath}" , :info=>$@})
    end
  end  
  
  def getMailInfo
	
       begin
	mData=YAML.load(File.open(@mailInfoPath))
	mData=Hash.new if mData.class !=Hash
	return mData
       rescue
        errorCollection({:errMes=>"Get mailInfo data Failed from #{@mailInfoPath}",:info=>$@})
	end
  end
  
  def sendMail(path)
	  # begin
	@mail=MailUtil.new(getMailInfo)
	@mail.mail_Send(getReportInfo(path))
	# rescue
     #   errorCollection({:errMes=>"",:info=>$@})
	#end
  end

 def getReportInfo(path)
	 @html=String.new
	begin
	File.open(path.to_s.gsub("/","\\"),"r")do|f|
		while line=f.gets
			@html<<line
		end
	end
	
	return @html
	rescue
	errorCollection({:errMes=>"Mail and  load Report from #{path}",:info=>$@})
	end
 end
  def loadConfigData
    begin
      if File::exists?(@loadConfigDataPath)
        lConfigData = YAML.load(File.open(@loadConfigDataPath))
        lConfigData = Hash.new  if lConfigData.class != Hash
        @log.writeLog("Get load config data from #{@loadConfigDataPath}")
        return lConfigData
      else
        @log.writeLog("No load config file")
      end
    rescue
      errorCollection({:errMes=>"Get load config data Failed from #{@loadConfigDataPath}" , :info=>$@})
    end
  end 
    
  def getCommObject                       
    getObject(@objectFile)    
  end
  
  def getCommTestData
    h = getAllData(@dataPath,"#{@basicInfo[:project]}_d") 
    dataKey = getNeedKey("data")
    h.each{|k,v|
      dataKey.each{|ke|
        errorCollection({:errMes=>"Get test data Failed from #{@configdataPath}, column #{ke} is not exist"}) unless v.key?(ke)
      }
    }
    @log.writeLog("Get all test data from #{@dataPath}")
    return h
  end
  
  def getAllExpectData
    begin      
      h = getAllData(@dataPath,"#{@basicInfo[:project]}_e")      
      @log.writeLog("Get all expect data from #{@dataPath}")
      return h
    rescue
      errorCollection({:errMes=>"Get expect data Failed" , :info=>$@})
    end
  end
  
  def getTransferData
    begin
      tData = YAML.load(File.open(@transferdataPath))    
      if tData.class != Hash     
        tData = Hash.new      
      end  
      @log.writeLog("Get all transfer data from #{@transferdataPath}")
      return tData
    rescue
      errorCollection({:errMes=>"Get transfer data Failed from #{@transferdataPath}" , :info=>$@})
    end
  end 
  
  def getExpectData(allValue,linkValue) 
    eArr = getNeedKey("expect")
    temp = Hash.new
    allValue.each{|k,v|
      temp[v[eArr[0]]] = v
    }
    if temp.key?(linkValue[eArr[0]])
      eData = temp[linkValue[eArr[0]]]
    else
      eData = Hash.new
    end  
    return eData
  end
      
  def getObject(path)
    begin       
      ui = UIObject.new(path)
      object = ui.combinElement(ui.integrateElement(ui.getYamlHash))
      @log.writeLog("Get the element object from #{path}")
      return object
    rescue      
      errorCollection({:errMes=>"Get Object failed from #{path}" , :info=>$@})
    end
  end
  
  def getAllData(path,sheetName)
    begin             
      e = ExcelFile.new(path.to_s.gsub("/","\\"),sheetName)
      h = e.ReadExcelFile      
      return h
    rescue
      errorCollection({:errMes=>"Get data failed" , :info=>$@})
    end
  end
  
  def TransferYamlFile(hash)
    begin
      File.open(@transferdataPath, "w"){|f| YAML.dump(hash, f)}      
    rescue
      errorCollection({:errMes=>"Generate Transfer Yaml File #{@transferdataPath} failed" ,:flag=>false})
      raise
    end
  end   
  
  def reHash(hash)
    tempHash = Hash.new
    p "F+#{hash}"
    hash.each{|k,v|
      tempHash[tempHash.length+1] = v
    }
    p tempHash
    return tempHash
  end
  
end  
