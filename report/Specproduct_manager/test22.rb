require 'net/smtp'
require 'rubygems'
require 'MailFactory'


$from_who="xxx"
$pass="xxx"
$to_who="xxx"
$smtp_server="smtp.163.com"
$smtp_port=25

mail=MailFactory.new

mail.to=['liuwenting@coo8.com','xiaowei@coo8.com'].join(',') #多个收件人


mail.from='xiaowei@coo8.com'

mail.subject='This is the subject'
@html=String.new
File.open("Specproduct_manager.html","r")do|file|
	while line = file.gets  
           @html<<line    
	end
	end

file=File.new("Specproduct_manager.html")
mail.rawhtml=file

#mail.attach('/usr/local/test.file')

Net::SMTP.start($smtp_server, $smtp_port,'163.com','fendou__110@163.com','xw02121835',:plain) do |smtp|
p "1"
smtp.send_message(mail.to_s(),"fendou__110@163.com","xiaowei@coo8.com")

end