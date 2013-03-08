require 'base64'

#
CONTACTS = 11
START_FROM = 1
#

FILE_NAME = "vcf_gmail"

AVATARS_DIR_NAME = "avatars"
AVATARS_DIR_PATH = File.join(Dir.pwd, AVATARS_DIR_NAME)
AVATARS_PATH_LIST = Dir[File.join(AVATARS_DIR_PATH, "*.jpg")]

OUTPUT_DIR_NAME = "vcfs"
OUTPUT_FILE_PATH = OUTPUT_DIR_NAME + '/' + FILE_NAME + "_#{CONTACTS}.vcf"

INDEX_CHARS = ('A'..'Z').to_a + ('0'..'9').to_a

# methods definition
def txt_str(length)
    (0...length).map{97.+(rand(26)).chr}.join
end

def txt_str_up(length)
    (0...length).map{65.+(rand(26)).chr}.join.capitalize
end

def num_str(length)
    (0...length).map{48.+(rand(10)).chr}.join
end

def email_str
    txt_str(5) + '.' + txt_str(8) + '@' + txt_str(5) + '.' + txt_str(2)
end

def web_str
    "http://www." + txt_str(12) + '.' + txt_str(2) 
end

def addr_str
	";;" + num_str(3) + ' ' + txt_str_up(6) + ' ' + txt_str_up(4) + ';' + 
	txt_str_up(8) + ';' + txt_str_up(5) + ';' + num_str(5) + ';' + txt_str_up(9)
end

File.open(OUTPUT_FILE_PATH, 'w') do |f|

    (START_FROM..(START_FROM + CONTACTS - 1)).each do |contact|
		index_char = INDEX_CHARS[(contact - 1)%INDEX_CHARS.length]
        temp_image = Base64.encode64(open(AVATARS_PATH_LIST.sample, 'rb').read)
        temp_image = temp_image.delete("\n")
        temp_str = 
        
        "BEGIN:VCARD" + "\n" +
        "VERSION:3.0" + "\n" +
        "N:#{index_char}_Last_#{contact};#{index_char}_First_#{contact};#{index_char}_Middle_#{contact};;" + "\n" +
        "FN:#{index_char}_First_#{contact} #{index_char}_Last_#{contact}" + "\n" +
		"ORG:" + txt_str_up(8) + "\n" +
		"TITLE:" + txt_str_up(6) + "\n" +
        "PHOTO;TYPE=JPEG;ENCODING=B:" + temp_image + "\n" +
        "TEL;TYPE=WORK,VOICE:" + num_str(9) + "\n" +
        "TEL;TYPE=HOME,VOICE:" + num_str(9) + "\n" +
        "TEL;TYPE=CELL,VOICE:" + num_str(12) + "\n" +
		"ADR;TYPE=HOME:" + addr_str + "\n" +
		"ADR;TYPE=WORK:" + addr_str + "\n" +
		"EMAIL;TYPE=INTERNET;TYPE=PREF:" + email_str + "\n" +
		"EMAIL;TYPE=INTERNET;TYPE=HOME:" + email_str + "\n" +		
		"EMAIL;TYPE=INTERNET;TYPE=WORK:" + email_str + "\n" +		
        "END:VCARD" + "\n" + "\n"
        
        f.print(temp_str)
    end
end

