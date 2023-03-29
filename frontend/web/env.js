fetch("../env")
  .then(response => response.text())
  .then(text => {
    const apiKeyLine = text.split("\n").find(line => line.startsWith("API_KEY="));
    if (apiKeyLine) {
      window.API_KEY = apiKeyLine.split("=")[1];
    } else {
      throw new Error(".env file not found or API_KEY not set");
    }
  });
