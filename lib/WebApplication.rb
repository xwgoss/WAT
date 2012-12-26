
#require "watir-webdriver"
require "watir"

class WebApplication
  def get_ie    
   #Watir::Browser.new :firefox   
   Watir::IE.new
   #Watir::Browser.new:chrome,:switches =>%w[--ignore-certificate-errors --disable-popup-blocking --disable-translate]
  end  
end

module WebApplicationModule
  def getWebApplication
    if @b == nil
      @b = WebApplication.new.get_ie
    end
  end
end