const randomButton = document.getElementById("randomButton");

if (randomButton) {
    randomButton.addEventListener("click", () => {
        fetch("http://localhost:4567/random_article")
            .then(response => {
                if (response.ok) {
                    return response;
                } else {
                    throw (new Error(`${response.status} (${response.statusText})`));
                }
            })
            .then(response => response.json())
            .then(jsonBody => {
                document.getElementById('title').innerText = "Title: " + jsonBody[0];
                document.getElementById('url').innerText = "URL: " + jsonBody[1];
                document.getElementById('description').innerText = "Description: " + jsonBody[2];
            })
            .catch(error => console.error(`Error in fetch: ${error.message}`));
    })
}

