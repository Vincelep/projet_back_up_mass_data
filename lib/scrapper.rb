######################################################################################
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   REQUIERED   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#


######################################################################################
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   METHODS   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#

page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))

PAGE_URL = "http://annuaire-des-mairies.com/val-d-oise.html"


#voici le code de noter SUuUUUUUUUUPPPPPer Scrapper ;) 
class Scrapper

	def get_the_email(page)
	  page = Nokogiri::HTML(open(page))
	  text = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text 
	  if text != "" 
	    return text 
	  else 
	    return "AUCUN EMAIL" 
	  end
	end

	def get_the_url(page) 
	    url = page.chomp("val-d-oise.html") 
	    page = Nokogiri::HTML(open(page))
	    municipalities = [] 
	    page.css("a.lientxt").each do |municipality| 

	    #municipalities[municipality.text] = (get_the_email(url + municipality['href'].sub!("./", "")))
	       municipalities << {municipality.text => get_the_email(url + municipality['href'].sub!("./", ""))}
	  end
	  return municipalities 
	end

#méthode pour afficher le scrap sur un fichier json
	  def save_as_JSON(municipalities)
	  	File.open("db/emails.json","w") do |f|
  			f.write(municipalities.to_json)
			end
	  end

# méthode pour afficher le scrap sur un fichier spreadsheet
	  def save_as_spreadsheet(municipalities)
	  	session =  GoogleDrive::Session.from_config(" config.json ")
	  	ws = session.spreadsheet_by_key("1_7qGu-tbIjlv7VgpfkjoasYnj9ri7tr5gBPEpyZRlsI").worksheets[0]
			
			i = 1
			municipalities.each do |municipality|
			municipality.each_pair do |key, value|
				ws[i, 1] = key
			  ws[i, 2] = value
			  i+=1
			end
		end
		  ws.save
			end

# méthode pour afficher le scrap sur un fichier csv
		def save_as_csv (municipalities)
			CSV.open("db/emails.csv", "w") do |csv| 
				municipalities.each do |municipality|
			municipality.each_pair do |key, value|
				csv << [key, value]
				end
			end
			end
		end

#Enlever le "#" pour lancer une méthode
 
	  def perform
	    municipalities = get_the_url(PAGE_URL)
	    for municipality in municipalities 
	      #puts municipality
	    end
	    #save_as_JSON(municipalities)
	    #save_as_spreadsheet(municipalities)    
	    #save_as_csv(municipalities) 
	  end
end  

#######################################################################################
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   INITIALIZE   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#

                              		    

#######################################################################################