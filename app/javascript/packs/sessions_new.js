const { toChecksumAddress } = require('ethereum-checksum-address')

// get nonce from /api/v1/users/ by account
async function getUuidByAccount(account) {
  const response = await fetch("/api/v1/users/" + account);
  const nonceJson = await response.json();
  if (!nonceJson) return null;
  const uuid = nonceJson[0].eth_nonce;
  return uuid;
}


// the button to connect to an ethereum wallet
const buttonEthConnect = document.querySelector('a#connect-wallet.nav-link');
// the read-only eth fields, we process them automatically
const formInputEthMessage = document.querySelector('input#session_eth_message');
const formInputEthAddress = document.querySelector('input#session_eth_address');
const formInputEthSignature = document.querySelector('input#session_eth_signature');
// get the new session form for submission later
const formNewSession = document.querySelector('form#new_session');
console.log(formNewSession);
// CheckSum test -- pass to rails/backend so this can be used to scrape from Mirror
const getChecksumAddress = async () => {
  const address = await ethereum.request({ method: 'eth_requestAccounts' });
  return toChecksumAddress(address[0]);
};


if (typeof window.ethereum !== 'undefined') {
  buttonEthConnect.addEventListener('click', async () => {

    //const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    const accounts = await getChecksumAddress();
    const etherbase = accounts;

    // sign a message with current time and nonce from database
    const nonce = await getUuidByAccount(etherbase.toLowerCase());
    console.log(ethereum.selectedAddress, accounts);
    if (nonce) {
      const customTitle = "Landing page on Ethereum";
      const requestTime = new Date().getTime();
      const message = customTitle + "," + requestTime + "," + nonce;
      const signature = await ethereum.request({ method: 'personal_sign', params: [ message, etherbase ] });
      // populate and submit form
      formInputEthMessage.value = message;
      formInputEthAddress.value = etherbase;
      formInputEthSignature.value = signature;
      document.body.appendChild(formNewSession);
      formNewSession.submit();
    } else {
      document.getElementById("sign-in-alert").insertAdjacentHTML('<div class="alert alert-danger" role="alert"> This is a danger alert—check it out!</div>')
    }
  })
}
