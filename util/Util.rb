#encoding=gbk
require 'iconv'
require 'win32ole'

module BasicTestUtil

#��վǰ̨CEC��½
def coo8_cec_login(name,pwd)
          @b.goto("www.coo8.com")
	  if @b.link(:class,"login").exist?
	  @b.link(:class,"login").click
	 # if @b.button(:text,"��Ȼ����").visible?
	 # @b.button(:text,"��Ȼ����").click
	 # end
	  @b.text_field(:id,"userName").set "#{name}"
	  @b.text_field(:id,"userPass").set "#{pwd}"
	  @b.button(:id,"btnSubmit").click
	  @b.wait
	  end
end

#֤����ת 
def continue_page
    if @b.title().strip=="֤�����: ��������ֹ" then
    @b.link(:text,"�����������վ(���Ƽ�)��").click
    else
    puts "occurs:no security problem to resolve"
    end
    
    
  end

#ѡ���ͻ�����������������Ϣ
def space_check(value)
	info_space=value.split("-")
	info=Array.new
			@b.span(:id,"areaselect").click
			@b.li(:id,"J-province").click
			sleep(2)
			@b.ul(:id,"J-stock-province").link(:text,"#{info_space.at(0)}").click
			@b.li(:id,"J-city").click
			#Watir::Wait.until {@b.link(:text,"#{info_space.at(1)}").visible?}			
			sleep(7)
			@b.link(:text,"#{info_space.at(1)}").click
			#@b.li(:id,"J-area").click
			#Watir::Wait.until {@b.link(:text,"#{info_space.at(2)}").visible?}	
			sleep(7)
			p @b.link(:text,"#{info_space.at(2)}").exist?
			@b.link(:text,"#{info_space.at(2)}").click	
		        @b.p(:id,"wldesc").text
			info<<@b.p(:id,"wldesc").text
			info<<@b.div(:id,"yfdesc").text
                        return info
end
=begin
#ת���ַ�������utf-8ת��Ϊgbk
def u_g_str(str)
   
      return Iconv.conv('gbk','utf-8',str)
end
=end

#��ĳ����Ʒ����ĳ���������빺�ﳵ
def shopping(proid,space)
	  @b.goto("http://www.coo8.com/product/#{proid}.html")
	  text=@b.span(:id,"areaselect").text
	   str=space.gsub('-','')
		if text!=str
			p str
			space_check("#{space}")	
		end
	    @b.link(:id,"shopping").click
    end
    
#�鿴������֧����ʽ
def info_pay
          @b.div(:id,"showshipType").span(:class,"ctn").link(:text,"�޸�").click
	  if @b.radio(:id,"0").exist?
		  @b.radio(:id,"0").set
		
		  if @b.span(:class,"ml").exist?
		
			  return "���������ֽ�"
			  else
				  return "��������POS��"
				  end
		  else
			  return "��֧�ֻ�������"
		  end
		  

end

#��չ��ﳵ
def clear_cart
		begin
		@b.goto('http://buy.coo8.com/cart/shoppingcart/queryshoppingcart.action')
		if @b.link(:text,'��չ��ﳵ').exists?
		@b.link(:text,'��չ��ﳵ').click_no_wait
		 @autoit = WIN32OLE.new("AutoItX3.Control")
            result1 = @autoit.WinWaitActive("������ҳ����Ϣ",'',5)
            result2 = @autoit.ControlClick("������ҳ����Ϣ","ȷ��","Button1")
            @autoit.Send "{Enter}"
		@b.refresh
		end
	rescue StandardError=>e
	return e.message+"error"
	end
	end



end
