#encoding=gbk
require 'net/smtp'
require 'rubygems'
require 'MailFactory'

class MailUtil
    def initialize(h)
        @mailInfo=h    #在newMailUtil的时候将从配置文件中读取的信息传入@mailInfo
	@mail=MailFactory.new  #构造maiFactory的实例
    end

    def mail_Send(str)
	
         @mail.to=@mailInfo.fetch('to_address')#
	 @mail.from=@mailInfo.fetch('from_address')
	 @mail.subject="Auto_report"
	 @mail.html=str
	 smtp_server=@mailInfo.fetch('server')
	 smtp_port=@mailInfo.fetch('port')
	 smtp_main=@mailInfo.fetch('main')
	 smtp_account=@mailInfo.fetch('account')
	 smtp_pwd=@mailInfo.fetch('pwd')
	 p @mail.to.to_s,@mail.from.to_s
	 Net::SMTP.start(smtp_server,smtp_port,smtp_main,smtp_account,smtp_pwd,:plain)do|smtp|
		 smtp.send_message(@mail.to_s(),"#{@mail.from.at(0)}","#{@mail.to.at(0)}")
		 end
	  
    end
    
end
