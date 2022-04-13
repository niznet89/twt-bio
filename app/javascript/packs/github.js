
// Find HTML objects for query & button
const formInput = document.querySelector("#query");
const button = document.querySelector(".btn.btn-primary");

// Query Github API and retrieve collection of repository items
button.addEventListener('click', async () => {
  console.log(formInput.value);
  const ghUsername = formInput.value;
  const url = `https://api.github.com/users/${ghUsername}/repos`
  fetch(url, {
    method: 'GET',
    headers: {
    'Accept': 'application/json'
  },
  })
  .then((response) => response.json())
  .then((json) => json.forEach(element => {
    document.getElementById("projects").insertAdjacentHTML('beforeend', `<div class="card">
    <div class="card-header">
      <h5 class="card-title"><a href="${element.html_url}">${element.name}</a></h5>
    </div>
    <div class="card-body">
      <p class="card-text">${element.description || ""}</p>
    </div>
  </div>`)
  }))
})
