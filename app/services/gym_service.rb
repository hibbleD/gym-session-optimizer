class GymService
  def self.get_busy_times(api_key, place_id)
    # running a python script from ruby seems weird 🤔
    # Set the correct path to your Python script
    script_path = Rails.root.join('get_busy_times.py').to_s

    # Update the command to run your Python script with the provided arguments
    command = "python3 #{script_path} #{api_key} #{place_id}"  # Use "python3" if that's the correct command on your system

    # Debug prints
    puts "Command: #{command}"

    # Execute the command and capture the output
    output = `#{command}`

    # Debug prints
    puts "Output: #{output}"

    # Attempt to parse the JSON output
    parsed_data = JSON.parse(output) rescue {}

    # Debug prints
    puts "Parsed Data: #{parsed_data}"

    # Return relevant data from the parsed output
    parsed_data['busy_times']
  end
end
