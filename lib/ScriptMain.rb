require "InitialClass.rb"

class Run  
  
  def testClassObject
    a = Array.new
    ObjectSpace.each_object(Class) do |klass|
      if klass.superclass == TestKlass  
            
        a<<klass			
      end
     
    end 

    return a
  end
  
  def run
    isRun = 0
    inti = InitialClass.new    
    basicInfo = inti.getBasicInfo    
    inti.getErrorInfo
    cData = inti.getConfigData
    object = inti.getCommObject
    allTestData = inti.getCommTestData
    allTestData.each{|k,v|      
      if v[cData["RunTimeModule"]].upcase != "Y"
        allTestData.delete(k)
      end    
    }   
    inti.errorCollection({:errMes=>"No case need to run",:status=>inti.getNeedKey("status")[1]}) if allTestData.length == 0      
    allTestData = inti.reHash(allTestData)
    allTestData = allTestData.sort
    edata = inti.getAllExpectData
    tData = inti.getTransferData
    allTestClass = testClassObject
    TestKlass.class_eval("include GetObject \n include GetTestData \n include Assertion \n include WebApplicationModule \n")
    TestKlass.class_eval("def system_testcase_information(hash) \n @info = hash \n end") 
    TestKlass.class_eval("def setUp\n end")   
    TestKlass.class_eval("def tearDown\n end")
    p allTestData
    allTestData.each{|allData|
      ke = allData[0]
      value = allData[1]
      allTestClass.each{|key|  
        k = key.new
        k.methods.grep(/^test/) do |method| 
          methodName = method.to_s
          if value["TestCase Order"] == methodName
            inti.setBasicInfo({:testclass=>key.to_s,:testcase=>methodName})            
            basicInfo = inti.getBasicInfo
            isRun = isRun + 1
            begin  
              s = inti.instance_variable_get(:@error).getErrorCollection.length
	
              testData = value.clone              
              expectData = inti.getExpectData(edata,testData)              
              log = inti.getLogObject            
              log.writeLog("Begining to run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]}")                           
              k.system_testcase_information({:object=>object.clone,:log=>log,:basicInfo=>basicInfo,:inti=>inti,:testData=>testData,:expectData=>expectData,:tData=>tData,:cData=>cData})
              class << k                
                undef system_testcase_information
              end 
              k.setUp
              rValue = k.__send__(method) 
              if rValue != nil                
                tData[methodName] = rValue
                inti.TransferYamlFile(tData)
              end    
              k.tearDown
              log.writeLog("Ending to run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]}")              
              inti.errorCollection({:errMes=>"Run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]} pass" , :flag=>false , :status=>inti.getNeedKey("status")[0]}) 
              e = inti.instance_variable_get(:@error).getErrorCollection.length
	      p ke
              inti.instance_variable_get(:@error).processHash(inti.instance_variable_get(:@error).getTestCaseHash(s,e),ke) unless s==e
            rescue              
              log.writeLog("Ending to run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]}")
              inti.errorCollection({:errMes=>"Run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]} fail",:info=>$@,:flag=>false})
              e = inti.instance_variable_get(:@error).getErrorCollection.length
              inti.instance_variable_get(:@error).processHash(inti.instance_variable_get(:@error).getTestCaseHash(s,e),ke) unless s==e
              if cData["ReRun"].upcase == "Y" and ke.to_s.scan(/re\./).length < cData["ReRunTimes"]
                allTestData<<["re\.#{ke.to_s}",value]                
              end
            end
          end
        end
        if isRun== 0      
          inti.errorCollection({:errMes=>"TestCase : #{value["TestCase Order"]} is not exist in #{basicInfo[:file]}" ,:testclass=>"",:testcase=>value["TestCase Order"], :flag=>false , :status=>inti.getNeedKey("status")[1]})
        else
          isRun = 0
        end
      }
    }    
    finalHash = inti.instance_variable_get(:@error).getErrorCollection      
    Report.new.putsReportFile(inti.instance_variable_get(:@reportHtmlFilePath),inti.instance_variable_get(:@reportFilePath),finalHash)
    inti.sendMail(inti.instance_variable_get(:@reportHtmlFilePath))
  end
end

at_exit do     
  Run.new.run
end

