// Originally we used the Moralis API (moralis.io) to gather NFTs directly associated with the public address.
// For now, we're using OpenSea's API. The hope would be to move to something more robust as OpenSea will be used for MVP stage
// It is rate-limited so if we get to any sort of scale we'll have to change providers or get an API key

// Grab the ETH public address from Edit page
const { toChecksumAddress } = require('ethereum-checksum-address')

const publicAddress = document.getElementById('hidden').innerHTML;

const url = `https://api.opensea.io/api/v1/assets?owner=${toChecksumAddress(publicAddress)}&order_direction=desc&limit=20&include_orders=false`;
console.log(toChecksumAddress(publicAddress));

fetch(url, {
  method: 'GET',
  headers: {
    'Accept': 'application/json'
  },
  })
  .then((response) => response.json())
  .then((json) => json.assets.forEach(nft => {
    document.getElementById("nfts").insertAdjacentHTML('beforeend', `
     <div class="carousel-item ${nft === json.assets[0] ? 'active' : ''}">
      <img class="rounded mx-auto d-block mb-3" src="${nft.image_url}">
     </div>`)
  }) );
