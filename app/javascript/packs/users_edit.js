
//import { ENV } from 'env.js';
// import ENV from './env.js.erb';

// Grab the ETH public address from Edit page
const publicAddress = document.getElementById('hidden').innerHTML;

const url = `https://deep-index.moralis.io/api/v2/${publicAddress}/nft?chain=eth&format=decimal`;
console.log(publicAddress);

fetch(url, {
  method: 'GET',
  headers: {
    'Accept': 'application/json',
    'X-API-Key': "pgLPCDVnxJQ3oglH8pfLv45Wabjn8Uui03dDCwZxRS9fdhkzA3jPkA6ECS6As7xd"
  },
  })
  .then((response) => response.json())
  .then((json) => fetch(json.result[0].token_uri, {
      method: 'GET'
    })
    .then((response) => response.json() )
    .then((json) => document.getElementById("nfts").outerHTML = `<div class="card" style="width: 18rem;">
    <img class="card-img-top" src="${json.image_url}" alt="Card image cap">
    <div class="card-body">
      <p class="card-text">${json.description}</p>
    </div>
  </div>`) );
