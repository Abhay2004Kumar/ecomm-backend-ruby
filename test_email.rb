require 'net/smtp'

# Test SMTP connection
def test_smtp
  smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'gmail.com',
    user_name: ENV['GMAIL_USERNAME'],
    password: ENV['GMAIL_APP_PASSWORD'],
    authentication: :plain,
    enable_starttls_auto: true
  }
  
  puts "Testing SMTP connection..."
  puts "Username: #{smtp_settings[:user_name]}"
  puts "Password length: #{smtp_settings[:password]&.length || 0}"
  puts "Password: #{smtp_settings[:password]}"
  
  begin
    smtp = Net::SMTP.new(smtp_settings[:address], smtp_settings[:port])
    smtp.enable_starttls_auto
    smtp.start(smtp_settings[:domain], 
               smtp_settings[:user_name], 
               smtp_settings[:password], 
               smtp_settings[:authentication]) do |smtp_session|
      puts "✅ SMTP connection successful!"
    end
  rescue => e
    puts "❌ SMTP connection failed: #{e.message}"
    puts "Error class: #{e.class}"
  end
end

test_smtp
