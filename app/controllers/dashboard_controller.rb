class DashboardController < ApplicationController
  def index
    api_key = ENV["GOOGLE_MAPS_API_KEY"]
    place_id = "ChIJ3RSaYE_LD4gRts0TShMrFjc"

    # Use backticks to capture the output of the Python script
    script_output = `python3 /workspaces/gym-session-optimizer/get_busy_times.py #{api_key} #{place_id}`

    # Print the raw output for debugging
    puts "Raw Script Output: #{script_output}"

    # Attempt to parse the JSON output
    begin
      @busy_times = JSON.parse(script_output)
    rescue JSON::ParserError => e
      puts "JSON Parsing Error: #{e.message}"
      @busy_times = []
    end

    # Set the current day dynamically
    @current_day = Date.today.strftime("%A")

    # Use @busy_times in your view or for further processing
  end
end
