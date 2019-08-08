const randomButton = document.getElementById("randomButton");
const gif = document.getElementById("gif");

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

if (gif) {
    let title = document.getElementById("gifTitle").textContent;
    fetch(`https://api.giphy.com/v1/gifs/search?api_key=jqpaJQ7xxZT5V4mQmUULF4TCybwarRK5&q=${title}&limit=20&offset=0&rating=G&lang=en`)
        .then(response => {
            if (response.ok) {
                return response;
            } else {
                throw (new Error(`${response.status} (${response.statusText})`));
            }
        })
        .then(response => response.json())
        .then(jsonBody => {
            let image = jsonBody.data[0].images.fixed_height.url;
            debugger
            if (image){
                gif.setAttribute("src", image);
            }
    })
}
