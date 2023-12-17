from populartimes import get_id
import sys
import json


def categorize_busyness(busyness_level):
    if busyness_level <= 25:
        return "Not busy"
    elif 25 < busyness_level <= 75:
        return "Busy"
    else:
        return "Very busy"


def get_gym_busy_times(api_key, place_id):
    result = get_id(api_key, place_id)
    hour_data = result.get("populartimes", [])
    busyness_level = result.get("current_popularity", 0)
    busyness_label = categorize_busyness(busyness_level)
    return hour_data, busyness_level, busyness_label


if __name__ == "__main__":
    api_key = sys.argv[
        1
    ]  # Pass the Google Maps API key as the first command-line argument
    gym_place_id = sys.argv[
        2
    ]  # Pass the Google Place ID as the second command-line argument

    hours, busyness, busyness_label = get_gym_busy_times(api_key, gym_place_id)

    data = {
        "Hourly Busy Times": hours,
        "Busyness Level": busyness,
        "Busyness Label": busyness_label,
    }

    # Convert the dictionary to a JSON string and print it
    print(json.dumps(data))
