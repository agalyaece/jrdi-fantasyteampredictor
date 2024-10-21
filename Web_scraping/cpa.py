from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait
import json
import datetime
import time

# Load the JSON data
with open('MatchData.json', 'r') as jsonfile:
    match_data = json.load(jsonfile)

# Initialize Selenium WebDriver
driver = webdriver.Firefox()  # Replace with your preferred WebDriver
driver.get('http://localhost:5173/administration/add_teams')
time.sleep(5)

# Iterate through JSON data and fill the form for each match
for match_index, match in enumerate(match_data):
    country_1 = match.get('country_1')  # Use get() to avoid KeyError
    country_2 = match.get('country_2')

    # Fill team_A and team_B from the CSV data
    team_a_input = driver.find_element(By.XPATH, '//*[@id="team_A"]')
    team_a_input.clear()  # Clear previous values
    team_a_input.send_keys(country_1)
    time.sleep(5)

    team_b_input = driver.find_element(By.XPATH, '//*[@id="team_B"]')
    team_b_input.clear()  # Clear previous values
    team_b_input.send_keys(country_2)
    time.sleep(5)

    # Select the first tournament in the dropdown (adjust XPATH if needed)
    tournament_select = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.XPATH, '//*[@id="tournament_name"]'))
    )
    tournament_select = Select(tournament_select)
    tournament_select.select_by_visible_text("ICC T20 World Cup")  # Replace with the exact text
    time.sleep(5)

    # Get today's and tomorrow's dates based on the current match
    today = datetime.date.today()
    tomorrow = today + datetime.timedelta(days=match_index)  # Increment days based on index
    date_format = "%Y-%m-%d"  # Adjust format as needed
    date_start = tomorrow.strftime(date_format)
    date_end = tomorrow.strftime(date_format)

    date_start_input = driver.find_element(By.XPATH, '//*[@id="date_start"]')
    date_start_input.clear()  # Clear previous values
    date_start_input.send_keys(date_start)
    time.sleep(5)

    date_end_input = driver.find_element(By.XPATH, '//*[@id="date_end"]')
    date_end_input.clear()  # Clear previous values
    date_end_input.send_keys(date_end)
    time.sleep(5)

    # Fill match time (adjust as needed)
    time_input = driver.find_element(By.XPATH, '//*[@id="time"]')
    time_input.clear()  # Clear previous values
    time_input.send_keys("10:00")  # Example: 10:00 AM
    time.sleep(5)

    # Submit the form
    submit_button = driver.find_element(By.XPATH, '/html/body/div/main/form/p[2]/button')
    submit_button.click()
    time.sleep(5)

    # Handle success or failure (adjust as needed)
    try:
        # Wait for success message (adjust as needed)
        success_message = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.XPATH, '//div[@class="success-message"]'))
        )
        print("Form submitted successfully!")
    except Exception as e:
        print("Error submitting form:", e)

# Close the WebDriver
driver.quit()