require 'win32ole'
require 'yaml'
#require 'ftools' 
require 'pathname'
project = "Auto_test33"

#check and confirm the project name
($*[0].nil?)?(project = project):(project = $*[0])
if project=~/^[a-zA-Z]/
  project = project.capitalize
else
  puts "project name error"
  exit
end

#define the basic info
ehd = ["TestCase Order","private","smoking","ExpectDataLink"]
ehe = ["ExpectDataLink"]
snh = ["ehe","ehd"]
filePath = Pathname.new(File.dirname(__FILE__)).realpath
templatePath = Pathname.new(File.join(File.dirname(__FILE__),"/../template/")).realpath

#generate the project folder
if not FileTest::exist?(File.join(filePath , "/#{project}"))
  Dir.mkdir(File.join(filePath , "/#{project}"))
else
  puts "project #{project} is exist"
  exit
end

#generate the test data excel file
if not File::exists?(File.join(templatePath,"temp.xls"))  
  excel = WIN32OLE.new("excel.application")
  excel.visible = false
  workbook = excel.workbooks.add

  snh.each{|sn|
    
    worksheet = workbook.Worksheets.Add
    worksheet.name = "temp_#{sn[sn.length-1,sn.length]}"
    for i in 1..eval("#{sn}").length
      worksheet.cells(1,i).value = eval("#{sn}[#{i-1}]")
      worksheet.cells(1,i).Interior['ColorIndex'] = 43
    end
  }   
  workbook.Worksheets.each{|sheet|
    if sheet.name != "temp_e" and sheet.name != "temp_d"
      sheet.delete
    end
  }  
  workbook.saveAs(File.join(templatePath,"temp.xls").to_s.gsub("/","\\"))
  workbook.close
  excel.Quit
end
File.copy_stream File.join(templatePath,"temp.xls"), File.join(filePath , "/#{project}","/#{project}.xls")
excel = WIN32OLE.new("excel.application")
workbook = excel.Workbooks.Open(File.join(filePath , "/#{project}","/#{project}.xls"))    
snh.each{|sn|  
  worksheet = workbook.Worksheets("temp_#{sn[sn.length-1,sn.length]}") 
  worksheet.Select
  worksheet.name = "#{project}_#{sn[sn.length-1,sn.length]}"
}
workbook.save
workbook.close
excel.Quit

#generate the UI Object yaml file
if not File::exists?(File.join(templatePath,"temp.yaml"))
  arr = ["type","name","class","index","type","parent"]
  h = Hash.new
  arr.each{|key|
    h[key]="x"
  }
  hash = Hash.new
  hash["elementName"] = h
  hash["elementOtherName"] = "div(:id,\"123\")"
  File.open(File.join(templatePath,"temp.yaml"), 'w'){|f| YAML.dump(hash, f)}
end
File.copy_stream File.join(templatePath,"temp.yaml"), File.join(filePath , "/#{project}","/#{project}.yaml")

#generate the config yaml file
if not File::exists?(File.join(templatePath,"conf.yaml"))  
  File.new(File.join(templatePath,"conf.yaml"), 'w')
end
File.copy_stream File.join(templatePath,"conf.yaml"), File.join(filePath , "/#{project}","/conf.yaml")

#define the test case rb file format
def getRbStr(project)
  return tempRbStr = %{require "../../lib/TestClass.rb"
  
class #{project} < TestKlass
  
  def test_#{project}
    #AutoTest("")
    #LoadObject("")
    #TestData("")
    #ExpectData("")
    #LoadTestData("")
    #LoadExpectData("")
    #TransferData("")
    #ConfigData("")
    #assert_string("","")
    #assert_array("","")
    #assert_hash("","")
    #assert_true(true)
    #assert_false(false)    
  end
	
end  
}
end

#generate the test case rb file
if not File::exists?(File.join(templatePath,"temp.rb")) 
  tempRbStr = getRbStr("Temp")
  File.open(File.join(templatePath,"temp.rb"),"w"){|f| f.puts(tempRbStr)}
end
File.copy_stream File.join(templatePath,"temp.rb"), File.join(filePath , "/#{project}","/#{project}.rb")
File.open(File.join(filePath , "/#{project}","/#{project}.rb"),"r") do |lines|
  buffer = lines.read.gsub(/Temp/i,project)
  File.open(File.join(filePath , "/#{project}","/#{project}.rb"),"w"){|all| all.write(buffer)}
end




