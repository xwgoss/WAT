#encoding=gbk
require 'iconv'
require 'win32ole'

module BasicTestUtil

#网站前台CEC登陆
def coo8_cec_login(name,pwd)
          @b.goto("www.coo8.com")
	  if @b.link(:class,"login").exist?
	  @b.link(:class,"login").click
	 # if @b.button(:text,"仍然继续").visible?
	 # @b.button(:text,"仍然继续").click
	 # end
	  @b.text_field(:id,"userName").set "#{name}"
	  @b.text_field(:id,"userPass").set "#{pwd}"
	  @b.button(:id,"btnSubmit").click
	  @b.wait
	  end
end

#证书跳转 
def continue_page
    if @b.title().strip=="证书错误: 导航已阻止" then
    @b.link(:text,"继续浏览此网站(不推荐)。").click
    else
    puts "occurs:no security problem to resolve"
    end
    
    
  end

#选择送货地区并返回物流信息
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
#转码字符串，将utf-8转化为gbk
def u_g_str(str)
   
      return Iconv.conv('gbk','utf-8',str)
end
=end

#将某个商品按照某个地区加入购物车
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
    
#查看订单的支付方式
def info_pay
          @b.div(:id,"showshipType").span(:class,"ctn").link(:text,"修改").click
	  if @b.radio(:id,"0").exist?
		  @b.radio(:id,"0").set
		
		  if @b.span(:class,"ml").exist?
		
			  return "货到付款现金"
			  else
				  return "货到付款POS机"
				  end
		  else
			  return "不支持货到付款"
		  end
		  

end

#清空购物车
def clear_cart
		begin
		@b.goto('http://buy.coo8.com/cart/shoppingcart/queryshoppingcart.action')
		if @b.link(:text,'清空购物车').exists?
		@b.link(:text,'清空购物车').click_no_wait
		 @autoit = WIN32OLE.new("AutoItX3.Control")
            result1 = @autoit.WinWaitActive("来自网页的消息",'',5)
            result2 = @autoit.ControlClick("来自网页的消息","确定","Button1")
            @autoit.Send "{Enter}"
		@b.refresh
		end
	rescue StandardError=>e
	return e.message+"error"
	end
	end



end
