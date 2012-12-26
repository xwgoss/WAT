require "yaml"
require "pathname"
require "../lib/Report.rb"
require "../lib/Mail.rb"
#define path
filePath = Pathname.new(File.join(File.dirname(__FILE__),"..")).realpath
testcasePath = File.join(filePath,"testcase")
reportPath = File.join(filePath,"report")

#load the yaml file and get the project which need to run
runHash = YAML.load(File.open("run.yaml"))
(puts "No data in run.yaml file" ; exit) if runHash.class != Hash
runHash.each{|k,v|
  runHash.delete(k) unless v["status"].upcase == "Y"
}
(puts "No project need to run" ; exit) if runHash.length==0
runHash.each{|k,v|
  (puts "The project: #{v["project"]} is not exist in testcase";runHash.delete(k)) unless File::exists?(File.join(testcasePath,v["project"],"#{v["project"]}.rb"))
}
(puts "No project need to run" ; exit) if runHash.length==0

#initialize the testing environment
File.delete("run.bat") if File::exists?("run.bat")
File.delete(File.join(reportPath,"report.yaml")) if File::exists?(File.join(reportPath,"report.yaml"))
File.delete(File.join(reportPath,"report.html")) if File::exists?(File.join(reportPath,"report.html"))

#generate run  bat file of every project
allCount = 0
ff = 0
tableContent = ""
detailContent = ""
runHash.each{|k,v|
  projectPath = File.join(testcasePath,v["project"]).to_s.gsub("/","\\")
  runcaseStr = "cd /d \"#{projectPath}\"\nruby #{v["project"]}.rb"
  File.open("run.bat","w"){|file| file.puts(runcaseStr)} 
  #begin to run the project
  puts "Beginning to run the project: #{v["project"]}"
  system("run.bat")
  puts "Ending to run the project: #{v["project"]}"
  allResult = Hash.new  
  tempHash = YAML.load(File.open(File.join(reportPath,v["project"],"#{v["project"]}.yaml")))
  errorArr = Hash.new  
  tempHash.each{|ke,va|
    unless ke =~ /^re\./
      allCount=allCount+1 
      if va[:status] == "Fail"
        errorArr[ke[/\d+/]]=allCount.to_s
      end    
      allResult[allCount.to_s] = va    
    end
  }
  tempHash.each{|ke,va|
    if ke =~ /^re\./      
      allResult[ke[/[^\d+]+/] + errorArr[ke[/\d+/]]] = va      
    end
  }  
  report = Report.new
  report.dealHash(allResult)
  #generate the all running result yaml file  
  tempArrayKeys = allResult.keys.sort
  tempArrayKeys.each{|k|
    (ff == 0)?(fileFlag = "w"):(fileFlag = "a+")
    File.open(File.join(reportPath,"report.yaml"), fileFlag){|f| YAML.dump({k=>allResult[k]}, f)}      
    ff = ff + 1
  }
  
  tableContent = tableContent + report.getAllTableContent()
  detailContent = detailContent + report.getAllDetailContent()
} 

#generate the all running result html file
report = Report.new
str = "<html>" + "\n" + report.getReportHead + "\n" + report.getContent(tableContent,detailContent) + "\n" + "</html>"     
File.open(File.join(reportPath,"report.html"),"w") do |file|      
  file.puts(str)
end 
mailInfoPath=File.join(File.join(root , "/config/"),"mail_config.yaml")
mail=MailUtil.new(Yaml.load(mailInfoPath).class==Hash?(Yaml.load(mailInfoPath)):(Hash.new))
mail.mail_Send(str)



