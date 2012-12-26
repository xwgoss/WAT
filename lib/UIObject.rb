#encoding=gbk
require 'yaml'

class UIObject
  
  def initialize(yamlFilePath)
    @yamlFilePath = yamlFilePath
  end 

  def getYamlHash    
    yamlHash = YAML.load(File.open(@yamlFilePath))
    (yamlHash.class == Hash)?(return yamlHash):(yamlHash=Hash.new ; return yamlHash)
  end   
    
  def integrateElement(h)    
	
    rehash = Hash.new     
    h.each{|key,value|      
      if value.class==Hash           
        temprehash = Hash.new
        tempStr = ""
        tempType = value.fetch("type")  
        tempType = "" if tempType == nil
        if not value.has_key?("parent")      
          value["parent"]=""
        end
        localHash = Hash.new
        value.each{|k,v|
          if k!="type" and k!="parent"
	    if v.class==String
		    v=v.force_encoding("gbk")
		  
	  end
    localHash[k]=v
          end
        }   	
        l = localHash.size
        if l>0
          tempJoin = Array.new
          localHash.each{|k,v|            
            isIndex = ((k=="index")?(""):("\"")) 
         	    
            if l==1
              tempJoin<<":"+k+","+isIndex+v.to_s+isIndex
            else
              tempJoin<<":"+k+"=>"+isIndex+v.to_s+isIndex
            end  
          }
	 
          tempStr = tempJoin.join(",")
        else
          puts "#{key} data error"
        end
        reelement = tempType+"("+tempStr+")"

        temprehash["parent"]=value.fetch("parent")
        temprehash["element"]=reelement  
        rehash[key]=temprehash
	
      end
      if value.class == String
        rehash[key]=value
      end      
    }

    return rehash
  end

  def combinElement(h)
	
    h.each{|key,value|
      if value.class==Hash
        tempParent = value.fetch("parent")
        tempElement = value.fetch("element")
        h.each{|k,v|          
          if v.class==Hash and v.fetch("parent")==key
            v["parent"]=tempParent
            v["element"]=tempElement + "." + v.fetch("element")
	   
          end          
        }
      end      
    }
    h.each{|key,value|
      if value.class == String
        valueHash = Hash.new
        valueHash["element"]=value
	
        h[key]=valueHash
      end  
    }
    p h
    return h
  end
  
end #class
