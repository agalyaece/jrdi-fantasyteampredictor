import csv
import time

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

# Replace 'chromedriver.exe' with the path to your ChromeDriver executable
driver = webdriver.Firefox()

# Navigate to the URL
driver.get("http://localhost:5173/administration/add_players")

# Read data from CSV file
with open("PlayerData.csv", "r") as csvfile:
    reader = csv.DictReader(csvfile)

    for row in reader:

        player_name_element = driver.find_element(By.XPATH, '//*[@id="player_name"]')
        player_name_element.clear()
        player_name_element.send_keys(row["player_name"])
        time.sleep(5)

        # Select tournament name
        tournament_name_element = driver.find_element(By.XPATH, '//*[@id="tournament_name"]')
        Select(tournament_name_element).select_by_visible_text("ICC T20 World Cup")
        time.sleep(5)
        # Select team name
        team_name_element = driver.find_element(By.ID, "team_name")
        Select(team_name_element).select_by_visible_text(row["country"])
        time.sleep(5)
        # Input nationality
        nationality_element = driver.find_element(By.ID, "nationality")
        nationality_element.clear()
        nationality_element.send_keys(row["country"])
        time.sleep(5)
        # Input player name


        # Select role
        role_element = driver.find_element(By.ID, "role")
        if row["role"] == "Wicketkeeper Batter":
            Select(role_element).select_by_visible_text("WicketKeeper")
        elif row["role"] in ["Middle order Batter", "Opening Batter", "Batter"]:
            Select(role_element).select_by_visible_text("Batter")
        elif row["role"] in ["Bowling Allrounder", "Allrounder", "Batting Allrounder"]:
            Select(role_element).select_by_visible_text("AllRounder")
        elif row["role"] == "Bowler":
            Select(role_element).select_by_visible_text("Bowler")
        time.sleep(5)
        # Submit the form (replace '//*[@id="submit_button"]' with the actual XPath of the submit button)
        submit_button = driver.find_element(By.XPATH, '/html/body/div/main/form/p[2]/button')
        submit_button.click()
        time.sleep(3)

# Close the browser
driver.quit()